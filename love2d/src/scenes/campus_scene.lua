local H = require("src.utils.helpers")
local Input = require("src.core.input")
local Widgets = require("src.ui.widgets")
local GameState = require("src.core.game_state")
local PixelArt = require("src.ui.pixel_art")
local Weeks = require("src.data.weeks")

local CampusScene = {}
CampusScene.selectedAction = 1
CampusScene.showStats = false
CampusScene.showParty = false
CampusScene.bgScene = "campus_day"
CampusScene.actions = {}
CampusScene.weekData = nil
CampusScene.eventQueue = {}
CampusScene.currentEventIndex = 0
CampusScene.timeSlots = {"Matin", "Après-midi", "Soir", "Nuit"}
CampusScene.currentSlot = 1
CampusScene.completedSlots = {}
CampusScene.weekStarted = false

function CampusScene.enter(data)
    CampusScene.selectedAction = 1
    CampusScene.showStats = false
    CampusScene.showParty = false
    CampusScene.completedSlots = {}
    CampusScene.currentSlot = 1
    CampusScene.weekStarted = false

    if GameState.timeOfDay == "night" then
        CampusScene.bgScene = "campus_night"
    else
        CampusScene.bgScene = "campus_day"
    end

    CampusScene.weekData = Weeks[GameState.week]
    if CampusScene.weekData then
        GameState.currentWeekData = CampusScene.weekData
        if not GameState.hasFlag("week_" .. GameState.week .. "_started") then
            GameState.setFlag("week_" .. GameState.week .. "_started")
            GameState.addNotification("Semaine " .. GameState.week .. " : " .. CampusScene.weekData.title, "info")
        end
    end

    CampusScene._buildActions()
end

function CampusScene._buildActions()
    CampusScene.actions = {}
    local weekData = CampusScene.weekData
    if not weekData then return end

    if not CampusScene.completedSlots[1] then
        CampusScene.actions[#CampusScene.actions + 1] = {
            text = "📚 Étudier (Matin)", type = "study",
            desc = "Cours du matin. +Coding, +Logic", energy = -10
        }
    end
    if not CampusScene.completedSlots[2] then
        CampusScene.actions[#CampusScene.actions + 1] = {
            text = "💻 Coder (Après-midi)", type = "code",
            desc = "Pratique de programmation. +Coding, +Creativity", energy = -15
        }
    end
    if not CampusScene.completedSlots[3] then
        CampusScene.actions[#CampusScene.actions + 1] = {
            text = "👥 Socialiser (Soir)", type = "social",
            desc = "Passer du temps avec le groupe. +Social, +Amitié", energy = -5
        }
    end
    if not CampusScene.completedSlots[4] then
        CampusScene.actions[#CampusScene.actions + 1] = {
            text = "🌙 Explorer (Nuit)", type = "explore",
            desc = "Explorer le campus. Indices sur le mystère.", energy = -20
        }
    end

    if weekData.miniGame then
        CampusScene.actions[#CampusScene.actions + 1] = {
            text = "🎮 Mini-jeu : " .. weekData.miniGame, type = "minigame",
            desc = "Défi de programmation. Récompenses.", energy = -15
        }
    end

    if weekData.boss then
        CampusScene.actions[#CampusScene.actions + 1] = {
            text = "⚔ Affronter le Boss", type = "boss",
            desc = "Combat contre " .. (weekData.boss.name or "ennemi"), energy = -20
        }
    end

    if weekData.weekEnd then
        CampusScene.actions[#CampusScene.actions + 1] = {
            text = "⏩ Terminer la semaine", type = "end_week",
            desc = "Passer à la semaine suivante.", energy = 0
        }
    end
end

function CampusScene.update(dt)
    GameState.updateNotifications(dt)
    GameState.updateScreenShake(dt)
end

function CampusScene.draw()
    local sx, sy = GameState.getShakeOffset()
    love.graphics.push()
    love.graphics.translate(sx, sy)

    PixelArt.drawBackground(CampusScene.bgScene, 1280, 720)

    if CampusScene.weekData then
        Widgets.drawWeekHeader(GameState.week, CampusScene.weekData.title, CampusScene.weekData.act or 1)
    end

    Widgets.drawPanel(10, 70, 350, 640, {
        bgColor = { r = 0.05, g = 0.05, b = 0.1 },
    })

    love.graphics.setColor(1, 1, 1, 0.9)
    love.graphics.setFont(Widgets.fonts.medium)
    love.graphics.print("Actions Disponibles", 25, 80)

    for i, action in ipairs(CampusScene.actions) do
        local ay = 110 + (i - 1) * 55
        local isSelected = (CampusScene.selectedAction == i)
        local isHovered = Input.isMouseInRect(20, ay, 330, 48)

        if isSelected or isHovered then
            love.graphics.setColor(0, 0.7, 0.4, 0.2)
            H.drawRoundRect(20, ay, 330, 48, 5)
        end

        love.graphics.setColor(isSelected and 1 or 0.7, isSelected and 1 or 0.7, isSelected and 1 or 0.7, 1)
        love.graphics.setFont(Widgets.fonts.small)
        love.graphics.print(action.text, 30, ay + 5)

        love.graphics.setColor(0.5, 0.5, 0.6, 0.8)
        love.graphics.setFont(Widgets.fonts.tiny)
        love.graphics.print(action.desc, 30, ay + 25)
    end

    Widgets.drawPanel(380, 70, 520, 300, {
        bgColor = { r = 0.05, g = 0.05, b = 0.1 },
    })

    love.graphics.setColor(1, 1, 1, 0.9)
    love.graphics.setFont(Widgets.fonts.medium)
    love.graphics.print("Statut du Groupe", 400, 80)

    local partyIds = {"not_a_genius", "laurencium", "king", "arsene"}
    for i, id in ipairs(partyIds) do
        local char = GameState.getChar(id)
        if char then
            local px = 400 + (i - 1) * 125
            local py = 110

            PixelArt.drawCharacter(id, px, py, 2)

            love.graphics.setColor(char.color.r, char.color.g, char.color.b, 1)
            love.graphics.setFont(Widgets.fonts.tiny)
            love.graphics.print(char.name, px, py + 45)

            Widgets.drawHpBar(px, py + 62, 100, 10, char.hp, char.maxHp)
            Widgets.drawMpBar(px, py + 75, 100, 10, char.mp, char.maxMp)

            love.graphics.setColor(0.6, 0.6, 0.6, 0.8)
            love.graphics.setFont(Widgets.fonts.tiny)
            love.graphics.print("Lv." .. char.level, px, py + 90)
        end
    end

    Widgets.drawPanel(380, 390, 520, 100, {
        bgColor = { r = 0.05, g = 0.05, b = 0.1 },
    })

    love.graphics.setColor(0.3, 0.8, 0.3, 0.9)
    love.graphics.setFont(Widgets.fonts.small)
    love.graphics.print("Énergie", 400, 400)
    Widgets.drawHpBar(470, 400, 200, 16, GameState.energy, GameState.maxEnergy, {
        color = { r = 0.2, g = 0.8, b = 0.2 }
    })

    love.graphics.setColor(0.8, 0.3, 0.8, 0.9)
    love.graphics.print("Sanité", 400, 425)
    Widgets.drawHpBar(470, 425, 200, 16, GameState.sanity, GameState.maxSanity, {
        color = { r = 0.8, g = 0.3, b = 0.8 }
    })

    love.graphics.setColor(1, 0.85, 0.2, 0.9)
    love.graphics.print("Or: " .. GameState.gold, 400, 455)

    Widgets.drawPanel(920, 70, 350, 640, {
        bgColor = { r = 0.05, g = 0.05, b = 0.1 },
    })

    love.graphics.setColor(1, 1, 1, 0.9)
    love.graphics.setFont(Widgets.fonts.medium)
    love.graphics.print("Informations", 940, 80)

    if CampusScene.weekData then
        love.graphics.setColor(0.7, 0.7, 0.8, 0.9)
        love.graphics.setFont(Widgets.fonts.small)
        local descLines = H.wrapText(CampusScene.weekData.description, Widgets.fonts.small, 310)
        for li, line in ipairs(descLines) do
            love.graphics.print(line, 940, 110 + (li - 1) * 20)
        end

        if CampusScene.weekData.objectives then
            love.graphics.setColor(0, 0.8, 0.5, 0.9)
            love.graphics.print("Objectifs:", 940, 220)
            for oi, obj in ipairs(CampusScene.weekData.objectives) do
                love.graphics.setColor(0.6, 0.6, 0.7, 0.8)
                love.graphics.print("• " .. obj, 950, 245 + (oi - 1) * 20)
            end
        end
    end

    love.graphics.setColor(0.4, 0.4, 0.5, 0.7)
    love.graphics.setFont(Widgets.fonts.tiny)
    love.graphics.print("Semaine " .. GameState.week .. "/17", 940, 690)

    for i, notif in ipairs(GameState.notifications) do
        Widgets.drawNotification(notif.text, notif.type, notif.alpha, 80 + (i - 1) * 45)
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.pop()
end

function CampusScene.keypressed(key, scancode, isrepeat)
    if key == "up" or key == "w" then
        CampusScene.selectedAction = math.max(1, CampusScene.selectedAction - 1)
    elseif key == "down" or key == "s" then
        CampusScene.selectedAction = math.min(#CampusScene.actions, CampusScene.selectedAction + 1)
    elseif key == "return" or key == "space" then
        CampusScene._selectAction()
    elseif key == "tab" then
        CampusScene.showStats = not CampusScene.showStats
    end
end

function CampusScene.mousepressed(x, y, button, istouch)
    if button == 1 then
        for i, action in ipairs(CampusScene.actions) do
            local ay = 110 + (i - 1) * 55
            if Input.isClickInRect(20, ay, 330, 48) then
                CampusScene.selectedAction = i
                CampusScene._selectAction()
                return
            end
        end
    end
end

function CampusScene.touchreleased(id, x, y, dx, dy, pressure)
    for i, action in ipairs(CampusScene.actions) do
        local ay = 110 + (i - 1) * 55
        if Input.isClickInRect(20, ay, 330, 48) then
            CampusScene.selectedAction = i
            CampusScene._selectAction()
            return
        end
    end
end

function CampusScene._selectAction()
    local action = CampusScene.actions[CampusScene.selectedAction]
    if not action then return end

    if action.type == "study" then
        CampusScene._doAction(1, function()
            GameState.modifyStat("not_a_genius", "logic", 1)
            GameState.modifyStat("not_a_genius", "coding", 1)
            GameState.addEnergy(-10)
            GameState.addNotification("+1 Logique, +1 Code", "success")
        end)
    elseif action.type == "code" then
        CampusScene._doAction(2, function()
            GameState.modifyStat("not_a_genius", "coding", 2)
            GameState.modifyStat("not_a_genius", "creativity", 1)
            GameState.addEnergy(-15)
            GameState.addNotification("+2 Code, +1 Créativité", "success")
        end)
    elseif action.type == "social" then
        CampusScene._doAction(3, function()
            GameState.modifyStat("not_a_genius", "social", 2)
            GameState.modifyRelationship("not_a_genius", "laurencium", 5)
            GameState.modifyRelationship("not_a_genius", "king", 5)
            GameState.modifyRelationship("not_a_genius", "arsene", 5)
            GameState.addEnergy(-5)
            GameState.addNotification("+2 Social, Liens +5", "success")
        end)
    elseif action.type == "explore" then
        CampusScene._doAction(4, function()
            GameState.addEnergy(-20)
            GameState.addSanity(-5)
            GameState.addNotification("Exploration terminée. Indice trouvé.", "info")
        end)
    elseif action.type == "minigame" then
        local SceneManager = require("src.core.scene_manager")
        SceneManager.push("minigame", { gameType = CampusScene.weekData.miniGame })
    elseif action.type == "boss" then
        local SceneManager = require("src.core.scene_manager")
        local Enemies = require("src.data.enemies")
        local bossData = nil
        if type(CampusScene.weekData.boss) == "string" then
            bossData = Enemies[CampusScene.weekData.boss]
        elseif type(CampusScene.weekData.boss) == "table" then
            bossData = Enemies[CampusScene.weekData.boss.id] or CampusScene.weekData.boss
        end
        if bossData then
            SceneManager.push("combat", { enemies = { bossData }, isBoss = true })
        end
    elseif action.type == "end_week" then
        CampusScene._endWeek()
    end
end

function CampusScene._doAction(slotIndex, callback)
    if CampusScene.completedSlots[slotIndex] then
        GameState.addNotification("Déjà fait cette fois.", "warning")
        return
    end

    CampusScene.completedSlots[slotIndex] = true
    callback()
    CampusScene._buildActions()
end

function CampusScene._endWeek()
    if GameState.week >= GameState.maxWeek then
        local SceneManager = require("src.core.scene_manager")
        SceneManager.switchTo("game_over")
        return
    end

    GameState.week = GameState.week + 1
    GameState.completedSlots = {}
    GameState.currentSlot = 1
    GameState.addEnergy(50)
    GameState.addSanity(10)
    GameState.setFlag("week_" .. GameState.week - 1 .. "_complete")

    local SceneManager = require("src.core.scene_manager")

    local weekData = Weeks[GameState.week]
    if weekData then
        if weekData.energyCost and weekData.energyCost > 0 then
            GameState.addEnergy(-weekData.energyCost)
        end
        if weekData.sanityEffect and weekData.sanityEffect < 0 then
            GameState.addSanity(weekData.sanityEffect)
        end

        if weekData.events then
            for _, event in ipairs(weekData.events) do
                if event.type == "dialogue" and event.dialogue then
                    SceneManager.switchTo("dialogue", {
                        dialogueId = event.dialogue,
                        onComplete = function()
                            if event.miniGame then
                                SceneManager.push("minigame", { gameType = event.miniGame })
                            end
                        end
                    })
                    return
                end
            end
        end
    end

    CampusScene.enter({})
end

return CampusScene
