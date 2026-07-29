local H = require("src.utils.helpers")
local Input = require("src.core.input")
local Widgets = require("src.ui.widgets")
local GameState = require("src.core.game_state")
local PixelArt = require("src.ui.pixel_art")
local CombatEngine = require("src.systems.combat_engine")
local Skills = require("src.data.skills")

local CombatScene = {}
CombatScene.selectedIndex = 1
CombatScene.skillMenuOpen = false
CombatScene.skillIndex = 1
CombatScene.targetIndex = 1
CombatScene.mode = "action"
CombatScene.animTimer = 0
CombatScene.resultScreen = false
CombatScene.rewards = nil
CombatScene.enemyHoverIndex = 0
CombatScene.logScroll = 0
CombatScene.turnTimer = 0
CombatScene.showingResult = false

function CombatScene.enter(data)
    CombatScene.selectedIndex = 1
    CombatScene.skillMenuOpen = false
    CombatScene.skillIndex = 1
    CombatScene.targetIndex = 1
    CombatScene.mode = "action"
    CombatScene.animTimer = 0
    CombatScene.resultScreen = false
    CombatScene.rewards = nil
    CombatScene.enemyHoverIndex = 0
    CombatScene.logScroll = 0
    CombatScene.turnTimer = 0
    CombatScene.showingResult = false

    local enemies = data.enemies or {}
    CombatEngine.init(enemies, GameState.party, {
        isBoss = data.isBoss or false,
        onVictory = function(stats)
            CombatScene._onVictory(stats)
        end,
        onDefeat = function()
            CombatScene._onDefeat()
        end,
    })

    GameState.applyScreenShake(5, 0.3)
end

function CombatScene._onVictory(stats)
    CombatScene.resultScreen = true
    CombatScene.rewards = CombatEngine.getRewards()

    for id, _ in pairs(CombatEngine.party) do
        GameState.addXp(id, CombatScene.rewards.xp)
    end
    GameState.gold = GameState.gold + CombatScene.rewards.gold
end

function CombatScene._onDefeat()
    CombatScene.resultScreen = true
    CombatScene.rewards = { xp = 0, gold = 0, defeat = true }
end

function CombatScene.update(dt)
    GameState.updateScreenShake(dt)
    CombatScene.animTimer = CombatScene.animTimer + dt

    if CombatScene.turnTimer > 0 then
        CombatScene.turnTimer = CombatScene.turnTimer - dt
        if CombatScene.turnTimer <= 0 then
            CombatScene.turnTimer = 0
            if CombatEngine.isEnemyTurn() then
                CombatEngine.enemyAI()
            end
        end
    end

    if CombatEngine.isEnemyTurn() and CombatScene.turnTimer <= 0 and not CombatScene.resultScreen then
        CombatScene.turnTimer = 0.8
    end
end

function CombatScene.draw()
    local sx, sy = GameState.getShakeOffset()
    love.graphics.push()
    love.graphics.translate(sx, sy)

    PixelArt.drawBackground("combat", 1280, 720)

    love.graphics.setColor(1, 1, 1, 0.9)
    love.graphics.setFont(Widgets.fonts.large)
    local title = "COMBAT"
    if CombatEngine.isBossFight then title = "⚔ BOSS FIGHT ⚔" end
    love.graphics.print(title, 560, 15)

    love.graphics.setFont(Widgets.fonts.tiny)
    love.graphics.print("Tour " .. CombatEngine.turnCount, 620, 50)

    for i, enemy in ipairs(CombatEngine.enemies) do
        if enemy.isAlive then
            local ew, eh = PixelArt.getEnemySize(enemy.sprite, 4)
            local ex = 700 + (i - 1) * 180
            local ey = 120

            local hover = CombatScene.enemyHoverIndex == i
            local isTarget = CombatScene.mode == "target" and CombatScene.targetIndex == i

            if isTarget then
                love.graphics.setColor(1, 0.3, 0.3, 0.3)
                love.graphics.rectangle("fill", ex - 5, ey - 5, ew + 10, eh + 10, 4)
            end

            PixelArt.drawEnemy(enemy.sprite, ex, ey, 4, hover and {1.2, 1.2, 1.2} or nil)

            Widgets.drawHpBar(ex, ey + eh + 10, ew, 12, enemy.hp, enemy.maxHp)

            love.graphics.setColor(enemy.color.r, enemy.color.g, enemy.color.b, 1)
            love.graphics.setFont(Widgets.fonts.tiny)
            local nameW = Widgets.fonts.tiny:getWidth(enemy.name)
            love.graphics.print(enemy.name, ex + (ew - nameW) / 2, ey + eh + 26)

            if enemy.isBoss and enemy.phaseData then
                love.graphics.setColor(1, 0.5, 0, 0.8)
                love.graphics.print("Phase " .. enemy.bossPhase .. "/" .. enemy.maxPhases, ex, ey - 15)
            end
        end
    end

    local partyIds = CombatEngine.getAlivePartyIds()
    for i, id in ipairs(partyIds) do
        local char = CombatEngine.party[id]
        if char then
            local px = 50 + (i - 1) * 150
            local py = 320

            PixelArt.drawCharacter(id, px, py, 2)

            love.graphics.setColor(1, 1, 1, 0.9)
            love.graphics.setFont(Widgets.fonts.tiny)
            love.graphics.print(char.name, px, py + 40)

            Widgets.drawHpBar(px, py + 55, 120, 10, char.hp, char.maxHp, { showText = true })
            Widgets.drawMpBar(px, py + 68, 120, 10, char.mp, char.maxMp, { showText = true })

            local currentTurn = CombatEngine.getCurrentTurn()
            if currentTurn and currentTurn.type == "party" and currentTurn.id == id then
                love.graphics.setColor(0, 1, 0.5, 0.5 + math.sin(CombatScene.animTimer * 4) * 0.3)
                love.graphics.rectangle("line", px - 3, py - 3, 126, 85, 4)
            end

            for _, buff in ipairs(char.buffs) do
                love.graphics.setColor(0, 0.8, 0.3, 0.7)
                love.graphics.print("↑" .. buff.stat, px + 100, py + 40)
            end
            for _, debuff in ipairs(char.debuffs) do
                love.graphics.setColor(1, 0.3, 0.3, 0.7)
                love.graphics.print("↓" .. debuff.stat, px + 100, py + 50)
            end
        end
    end

    Widgets.drawPanel(50, 430, 500, 280, {
        bgColor = { r = 0.03, g = 0.03, b = 0.08 },
    })

    love.graphics.setColor(0.5, 0.5, 0.6, 0.9)
    love.graphics.setFont(Widgets.fonts.small)
    love.graphics.print("Journal de Combat", 60, 440)

    local maxLog = 8
    local startLog = math.max(1, #CombatEngine.log - maxLog + 1)
    for i = startLog, #CombatEngine.log do
        local log = CombatEngine.log[i]
        local ly = 465 + (i - startLog) * 22
        love.graphics.setColor(0.7, 0.7, 0.8, 0.9)
        love.graphics.setFont(Widgets.fonts.tiny)
        love.graphics.print(log.text, 60, ly)
    end

    Widgets.drawPanel(570, 430, 690, 280, {
        bgColor = { r = 0.03, g = 0.03, b = 0.08 },
    })

    if CombatScene.resultScreen then
        CombatScene._drawResult()
    elseif CombatScene.mode == "action" and CombatEngine.isPlayerTurn() then
        CombatScene._drawActionBar()
    elseif CombatScene.mode == "skill" then
        CombatScene._drawSkillMenu()
    elseif CombatScene.mode == "target" then
        CombatScene._drawTargetSelect()
    else
        love.graphics.setColor(0.6, 0.6, 0.7, 0.8)
        love.graphics.setFont(Widgets.fonts.medium)
        if CombatEngine.isEnemyTurn() then
            love.graphics.print("Tour de l'ennemi...", 700, 540)
        end
    end

    for i, notif in ipairs(GameState.notifications) do
        Widgets.drawNotification(notif.text, notif.type, notif.alpha, 80 + (i - 1) * 45)
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.pop()
end

function CombatScene._drawActionBar()
    love.graphics.setColor(1, 1, 0.5, 0.9)
    love.graphics.setFont(Widgets.fonts.medium)
    local turn = CombatEngine.getCurrentTurn()
    local name = turn and turn.ref.name or "?"
    love.graphics.print("Tour de " .. name, 590, 445)

    local actions = {
        { text = "⚔ Attaque", id = "attack" },
        { text = "✨ Compétence", id = "skill" },
        { text = "🛡 Défendre", id = "defend" },
        { text = "🏃 Fuir", id = "flee" },
    }

    for i, action in ipairs(actions) do
        local ax = 590 + (i - 1) * 170
        local ay = 480
        local selected = CombatScene.selectedIndex == i

        local clicked = Widgets.drawButtonClicked(ax, ay, 155, 50, action.text, {
            color = selected and {r=0.3, g=0.7, b=1} or {r=0.15, g=0.15, b=0.25},
            textColor = {r=1, g=1, b=1},
        })

        if clicked then
            CombatScene._selectAction(action.id)
        end
    end

    love.graphics.setColor(0.5, 0.5, 0.6, 0.7)
    love.graphics.setFont(Widgets.fonts.tiny)
    love.graphics.print("Flèches + Entrée ou Clic", 590, 690)
end

function CombatScene._drawSkillMenu()
    local skills = CombatEngine.getPlayerSkills()

    love.graphics.setColor(0.3, 0.8, 1, 0.9)
    love.graphics.setFont(Widgets.fonts.medium)
    love.graphics.print("Choisir une compétence:", 590, 445)

    for i, s in ipairs(skills) do
        local sy = 480 + (i - 1) * 40
        local selected = CombatScene.skillIndex == i
        local canAfford = (CombatEngine.getCurrentTurn().ref.mp >= s.skill.mpCost)

        local clicked = Widgets.drawButtonClicked(590, sy, 650, 35, s.skill.name .. " (MP: " .. s.skill.mpCost .. ")", {
            color = selected and {r=0.2, g=0.5, b=0.8} or {r=0.1, g=0.1, b=0.2},
            disabled = not canAfford,
        })

        if selected then
            love.graphics.setColor(0.7, 0.7, 0.8, 0.9)
            love.graphics.setFont(Widgets.fonts.tiny)
            love.graphics.print(s.skill.description or "", 600, sy + 38)
        end

        if clicked and canAfford then
            CombatScene.skillIndex = i
            CombatScene.mode = "target"
            CombatScene.selectedIndex = 1
        end
    end

    if Input.isKeyJustPressed("escape") or Input.isKeyJustPressed("backspace") then
        CombatScene.mode = "action"
    end
end

function CombatScene._drawTargetSelect()
    love.graphics.setColor(1, 0.5, 0.3, 0.9)
    love.graphics.setFont(Widgets.fonts.medium)
    love.graphics.print("Choisir une cible:", 590, 445)

    for i, enemy in ipairs(CombatEngine.enemies) do
        if enemy.isAlive then
            local ty = 480 + (i - 1) * 40
            local selected = CombatScene.targetIndex == i

            local clicked = Widgets.drawButtonClicked(590, ty, 300, 35, enemy.name, {
                color = selected and {r=0.8, g=0.2, b=0.2} or {r=0.15, g=0.1, b=0.1},
            })

            if clicked then
                CombatScene._executeSkill(i)
            end
        end
    end

    if Input.isKeyJustPressed("escape") or Input.isKeyJustPressed("backspace") then
        CombatScene.mode = "skill"
    end
end

function CombatScene._drawResult()
    if CombatScene.rewards.defeat then
        love.graphics.setColor(1, 0.2, 0.2, 0.9)
        love.graphics.setFont(Widgets.fonts.large)
        love.graphics.print("DÉFAITE", 780, 480)

        love.graphics.setColor(0.7, 0.7, 0.8, 0.9)
        love.graphics.setFont(Widgets.fonts.small)
        love.graphics.print("Vos héros sont K.O...", 750, 520)

        Widgets.drawButtonClicked(780, 570, 200, 50, "Continuer", {
            color = {r=0.5, g=0.1, b=0.1},
        })
        if Input.isClickInRect(780, 570, 200, 50) then
            GameState.reviveParty()
            local SceneManager = require("src.core.scene_manager")
            SceneManager.pop()
        end
    else
        love.graphics.setColor(1, 0.9, 0.2, 0.9)
        love.graphics.setFont(Widgets.fonts.large)
        love.graphics.print("VICTOIRE !", 780, 480)

        love.graphics.setColor(0.7, 0.7, 0.8, 0.9)
        love.graphics.setFont(Widgets.fonts.small)
        love.graphics.print("XP: +" .. CombatScene.rewards.xp, 750, 520)
        love.graphics.print("Or: +" .. CombatScene.rewards.gold, 750, 545)

        local stats = CombatEngine.combatStats
        love.graphics.print("Dégâts infligés: " .. stats.totalDamageDealt, 750, 575)
        love.graphics.print("Soins: " .. stats.totalHealing, 750, 595)

        Widgets.drawButtonClicked(780, 640, 200, 50, "Continuer", {
            color = {r=0.1, g=0.5, b=0.1},
        })
        if Input.isClickInRect(780, 640, 200, 50) then
            local SceneManager = require("src.core.scene_manager")
            SceneManager.pop()
        end
    end
end

function CombatScene._selectAction(actionId)
    if actionId == "attack" then
        CombatScene.mode = "target"
        CombatScene.skillIndex = 0
        CombatScene.targetIndex = 1
    elseif actionId == "skill" then
        CombatScene.mode = "skill"
        CombatScene.skillIndex = 1
    elseif actionId == "defend" then
        local turn = CombatEngine.getCurrentTurn()
        if turn and turn.ref then
            turn.ref.buffs[#turn.ref.buffs + 1] = {
                stat = "defense", value = 10, turns = 1
            }
            CombatEngine.addLog(turn.ref.name .. " se défend !")
            CombatEngine._nextTurn()
        end
    elseif actionId == "flee" then
        if CombatEngine.isBossFight then
            GameState.addNotification("Impossible de fuir un boss !", "warning")
        elseif math.random() < 0.4 then
            GameState.addNotification("Fuite réussie !", "info")
            local SceneManager = require("src.core.scene_manager")
            SceneManager.pop()
        else
            GameState.addNotification("Fuite échouée !", "error")
            CombatEngine._nextTurn()
        end
    end
end

function CombatScene._executeSkill(targetIdx)
    local skills = CombatEngine.getPlayerSkills()
    local skillData = skills[CombatScene.skillIndex]

    if skillData then
        CombatEngine.playerAttack(targetIdx, skillData.id)
    else
        CombatEngine.playerAttack(targetIdx, nil)
    end

    CombatScene.mode = "action"
    CombatScene.selectedIndex = 1
end

function CombatScene.keypressed(key, scancode, isrepeat)
    if CombatScene.resultScreen then return end

    if CombatScene.mode == "action" then
        if key == "left" or key == "a" then
            CombatScene.selectedIndex = math.max(1, CombatScene.selectedIndex - 1)
        elseif key == "right" or key == "d" then
            CombatScene.selectedIndex = math.min(4, CombatScene.selectedIndex + 1)
        elseif key == "return" or key == "space" then
            local actions = {"attack", "skill", "defend", "flee"}
            CombatScene._selectAction(actions[CombatScene.selectedIndex])
        end
    elseif CombatScene.mode == "skill" then
        local skills = CombatEngine.getPlayerSkills()
        if key == "up" or key == "w" then
            CombatScene.skillIndex = math.max(1, CombatScene.skillIndex - 1)
        elseif key == "down" or key == "s" then
            CombatScene.skillIndex = math.min(#skills, CombatScene.skillIndex + 1)
        elseif key == "return" or key == "space" then
            local s = skills[CombatScene.skillIndex]
            if s and CombatEngine.getCurrentTurn().ref.mp >= s.skill.mpCost then
                CombatScene.mode = "target"
                CombatScene.targetIndex = 1
            end
        elseif key == "escape" then
            CombatScene.mode = "action"
        end
    elseif CombatScene.mode == "target" then
        if key == "up" or key == "w" then
            CombatScene.targetIndex = math.max(1, CombatScene.targetIndex - 1)
        elseif key == "down" or key == "s" then
            CombatScene.targetIndex = math.min(#CombatEngine.enemies, CombatScene.targetIndex + 1)
        elseif key == "return" or key == "space" then
            CombatScene._executeSkill(CombatScene.targetIndex)
        elseif key == "escape" then
            if CombatScene.skillIndex == 0 then
                CombatScene.mode = "action"
            else
                CombatScene.mode = "skill"
            end
        end
    end
end

function CombatScene.mousepressed(x, y, button, istouch)
end

return CombatScene
