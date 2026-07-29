local H = require("src.utils.helpers")
local Input = require("src.core.input")
local Widgets = require("src.ui.widgets")
local GameState = require("src.core.game_state")
local PixelArt = require("src.ui.pixel_art")
local Dialogues = require("src.data.dialogues")

local DialogueScene = {}
DialogueScene.currentNode = nil
DialogueScene.dialogueId = nil
DialogueScene.textReveal = 0
DialogueScene.textSpeed = 30
DialogueScene.onComplete = nil
DialogueScene.selectedChoice = 1
DialogueScene.waitingForInput = false
DialogueScene.textComplete = false

function DialogueScene.enter(data)
    DialogueScene.dialogueId = data and data.dialogueId or "welcome_speech"
    DialogueScene.onComplete = data and data.onComplete
    DialogueScene.selectedChoice = 1
    DialogueScene.waitingForInput = false
    DialogueScene.textComplete = false
    DialogueScene.textReveal = 0

    DialogueScene.currentNode = Dialogues[DialogueScene.dialogueId]
    if DialogueScene.currentNode then
        DialogueScene.currentNode = DialogueScene.currentNode.start
    end
    DialogueScene._applyEffects()
end

function DialogueScene._applyEffects()
    if not DialogueScene.currentNode then return end
    if DialogueScene.currentNode.setFlag then
        GameState.setFlag(DialogueScene.currentNode.setFlag)
    end
end

function DialogueScene.update(dt)
    DialogueScene.textReveal = DialogueScene.textReveal + DialogueScene.textSpeed * dt

    if DialogueScene.currentNode then
        local text = DialogueScene.currentNode.text or ""
        if DialogueScene.textReveal >= #text then
            DialogueScene.textComplete = true
            if DialogueScene.currentNode.choices then
                DialogueScene.waitingForInput = false
            else
                DialogueScene.waitingForInput = true
            end
        end
    end
end

function DialogueScene.draw()
    PixelArt.drawBackground("classroom", 1280, 720)

    Widgets.drawPanel(50, 50, 1180, 350, {
        bgColor = { r = 0.05, g = 0.05, b = 0.12 },
    })

    if DialogueScene.currentNode then
        local node = DialogueScene.currentNode
        local speaker = node.speaker or "..."
        local portrait = node.portrait

        local speakerColor = { r = 0.3, g = 0.8, b = 1 }
        if speaker == "narrator" then
            speakerColor = { r = 0.6, g = 0.6, b = 0.6 }
        elseif speaker == "hemeryfb" then
            speakerColor = { r = 0.7, g = 0.1, b = 0.9 }
        elseif speaker == "king" then
            speakerColor = { r = 0.9, g = 0.2, b = 0.4 }
        elseif speaker == "laurencium" then
            speakerColor = { r = 1, g = 0.85, b = 0.2 }
        elseif speaker == "arsene" then
            speakerColor = { r = 0.5, g = 0.8, b = 0.5 }
        end

        Widgets.drawTextWithShadow(speaker, Widgets.fonts.large, 80, 70, speakerColor)

        if portrait and PixelArt.characters[portrait] then
            PixelArt.drawCharacter(portrait, 80, 110, 3)
        elseif portrait == "narrator" then
            love.graphics.setColor(0.5, 0.5, 0.6, 0.3)
            love.graphics.setFont(Widgets.fonts.title)
            love.graphics.print("...", 100, 150)
        end

        local textX = portrait and PixelArt.characters[portrait] and 200 or 80
        local fullText = node.text or ""
        local visibleText = fullText:sub(1, math.floor(DialogueScene.textReveal))

        local lines = H.wrapText(visibleText, Widgets.fonts.medium, 1000)
        for i, line in ipairs(lines) do
            love.graphics.setColor(0.9, 0.9, 0.9, 1)
            love.graphics.setFont(Widgets.fonts.medium)
            love.graphics.print(line, textX, 120 + (i - 1) * 28)
        end

        if not DialogueScene.textComplete then
            local pulse = (math.sin(love.timer.getTime() * 6) + 1) / 2
            love.graphics.setColor(1, 1, 1, 0.5 + pulse * 0.5)
            love.graphics.setFont(Widgets.fonts.tiny)
            love.graphics.print("▼", 1200, 370)
        end
    end

    if DialogueScene.currentNode and DialogueScene.textComplete then
        local node = DialogueScene.currentNode
        if node.choices then
            Widgets.drawPanel(100, 420, 1080, 280, {
                bgColor = { r = 0.05, g = 0.05, b = 0.15 },
            })

            for i, choice in ipairs(node.choices) do
                local cy = 440 + (i - 1) * 60
                local selected = DialogueScene.selectedChoice == i
                local isHovered = Input.isMouseInRect(120, cy, 1040, 50)

                if selected or isHovered then
                    love.graphics.setColor(0, 0.6, 0.4, 0.2)
                    H.drawRoundRect(120, cy, 1040, 50, 5)
                end

                love.graphics.setColor(selected and 1 or 0.7, selected and 1 or 0.7, selected and 1 or 0.7, 1)
                love.graphics.setFont(Widgets.fonts.medium)
                love.graphics.print(i .. ". " .. choice.text, 140, cy + 12)
            end
        else
            local pulse = (math.sin(love.timer.getTime() * 3) + 1) / 2
            love.graphics.setColor(1, 1, 1, 0.5 + pulse * 0.3)
            love.graphics.setFont(Widgets.fonts.small)
            love.graphics.print("Appuyez sur Entrée ou cliquez pour continuer...", 400, 660)
        end
    end

    for i, notif in ipairs(GameState.notifications) do
        Widgets.drawNotification(notif.text, notif.type, notif.alpha, 80 + (i - 1) * 45)
    end

    love.graphics.setColor(1, 1, 1, 1)
end

function DialogueScene.keypressed(key, scancode, isrepeat)
    if not DialogueScene.currentNode then return end

    if DialogueScene.textComplete then
        if DialogueScene.currentNode.choices then
            if key == "up" or key == "w" then
                DialogueScene.selectedChoice = math.max(1, DialogueScene.selectedChoice - 1)
            elseif key == "down" or key == "s" then
                DialogueScene.selectedChoice = math.min(#DialogueScene.currentNode.choices, DialogueScene.selectedChoice + 1)
            elseif key == "return" or key == "space" then
                DialogueScene._selectChoice(DialogueScene.selectedChoice)
            end
        elseif DialogueScene.waitingForInput then
            if key == "return" or key == "space" then
                DialogueScene._advance()
            end
        end
    else
        DialogueScene.textReveal = 999
    end
end

function DialogueScene.mousepressed(x, y, button, istouch)
    if not DialogueScene.currentNode then return end
    if not DialogueScene.textComplete then
        DialogueScene.textReveal = 999
        return
    end

    if DialogueScene.currentNode.choices then
        for i, choice in ipairs(DialogueScene.currentNode.choices) do
            local cy = 440 + (i - 1) * 60
            if Input.isClickInRect(120, cy, 1040, 50) then
                DialogueScene._selectChoice(i)
                return
            end
        end
    elseif DialogueScene.waitingForInput then
        DialogueScene._advance()
    end
end

function DialogueScene.touchreleased(id, x, y, dx, dy, pressure)
    DialogueScene.mousepressed(x, y, 1, false)
end

function DialogueScene._selectChoice(choiceIndex)
    local node = DialogueScene.currentNode
    if not node or not node.choices then return end

    local choice = node.choices[choiceIndex]
    if not choice then return end

    if choice.stat and choice.value then
        GameState.modifyStat("not_a_genius", choice.stat, choice.value)
    end
    if choice.groupRelation then
        GameState.modifyRelationship("not_a_genius", "laurencium", choice.groupRelation)
        GameState.modifyRelationship("not_a_genius", "king", choice.groupRelation)
        GameState.modifyRelationship("not_a_genius", "arsene", choice.groupRelation)
    end
    if choice.hemeryfbRelation then
        GameState.hemeryfbTrust = GameState.hemeryfbTrust + choice.hemeryfbRelation
        GameState.modifyRelationship("not_a_genius", "hemeryfb", choice.hemeryfbRelation)
    end
    if choice.flag then
        GameState.setFlag(choice.flag, choice.value or true)
    end
    if choice.sanityEffect then
        GameState.addSanity(choice.sanityEffect)
    end
    if choice.energyEffect then
        GameState.addEnergy(choice.energyEffect)
    end
    if choice.combatBuff then
        GameState.setFlag("combat_buff", choice.combatBuff)
    end

    if choice.next then
        DialogueScene._goToNode(choice.next)
    else
        DialogueScene._endDialogue()
    end
end

function DialogueScene._advance()
    local node = DialogueScene.currentNode
    if not node then return end

    if node.startCombat then
        local SceneManager = require("src.core.scene_manager")
        local Enemies = require("src.data.enemies")
        local bossData = Enemies[node.startCombat]
        if bossData then
            SceneManager.push("combat", { enemies = { bossData }, isBoss = true })
        end
        return
    end

    if node.next then
        DialogueScene._goToNode(node.next)
    else
        DialogueScene._endDialogue()
    end
end

function DialogueScene._goToNode(nodeId)
    local dialogueData = Dialogues[DialogueScene.dialogueId]
    if dialogueData and dialogueData[nodeId] then
        DialogueScene.currentNode = dialogueData[nodeId]
        DialogueScene.textReveal = 0
        DialogueScene.textComplete = false
        DialogueScene.waitingForInput = false
        DialogueScene.selectedChoice = 1
        DialogueScene._applyEffects()
    else
        DialogueScene._endDialogue()
    end
end

function DialogueScene._endDialogue()
    if DialogueScene.onComplete then
        DialogueScene.onComplete()
    end
    local SceneManager = require("src.core.scene_manager")
    SceneManager.pop()
end

return DialogueScene
