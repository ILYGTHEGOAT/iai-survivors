local H = require("src.utils.helpers")

local CombatEngine = {}

CombatEngine.turnOrder = {}
CombatEngine.currentTurnIndex = 0
CombatEngine.enemies = {}
CombatEngine.party = {}
CombatEngine.state = "idle"
CombatEngine.log = {}
CombatEngine.turnCount = 0
CombatEngine.buffEffects = {}
CombatEngine.isBossFight = false
CombatEngine.bossPhase = 1
CombatEngine.onVictory = nil
CombatEngine.onDefeat = nil
CombatEngine.combatStats = {
    totalDamageDealt = 0,
    totalDamageTaken = 0,
    totalHealing = 0,
    turnsPlayed = 0,
}

function CombatEngine.init(enemies, party, options)
    CombatEngine.enemies = {}
    CombatEngine.party = {}
    CombatEngine.turnOrder = {}
    CombatEngine.currentTurnIndex = 0
    CombatEngine.log = {}
    CombatEngine.turnCount = 0
    CombatEngine.buffEffects = {}
    CombatEngine.isBossFight = options and options.isBoss or false
    CombatEngine.bossPhase = 1
    CombatEngine.onVictory = options and options.onVictory
    CombatEngine.onDefeat = options and options.onDefeat
    CombatEngine.combatStats = {
        totalDamageDealt = 0, totalDamageTaken = 0,
        totalHealing = 0, turnsPlayed = 0,
    }

    for i, e in ipairs(enemies) do
        CombatEngine.enemies[i] = {
            id = e.id .. "_" .. i,
            templateId = e.id,
            name = e.name,
            hp = e.hp, maxHp = e.maxHp,
            mp = e.mp or 0, maxMp = e.maxMp or 0,
            attack = e.attack, defense = e.defense,
            speed = e.speed, xp = e.xp, gold = e.gold,
            skills = e.skills or {},
            color = e.color, sprite = e.sprite,
            isBoss = e.isBoss or false,
            bossPhase = 1,
            maxPhases = e.maxPhases or 1,
            phaseData = e.phaseTwo and { e, e.phaseTwo, e.phaseThree, e.phaseFour } or nil,
            loot = e.loot or {},
            buffs = {}, debuffs = {},
            isAlive = true,
        }
    end

    for id, c in pairs(party) do
        if c.isAlive then
            CombatEngine.party[id] = {
                id = id,
                name = c.name,
                hp = c.hp, maxHp = c.maxHp,
                mp = c.mp, maxMp = c.maxMp,
                attack = c.stats.coding.value * 3 + c.stats.logic.value * 2,
                defense = c.stats.endurance.value * 2,
                speed = c.stats.logic.value + c.stats.creativity.value,
                skills = c.skills,
                buffs = {}, debuffs = {},
                isAlive = true,
            }
        end
    end

    CombatEngine._buildTurnOrder()
    CombatEngine.state = "player_turn"
    CombatEngine.currentTurnIndex = 1
    CombatEngine.turnCount = 1

    CombatEngine.addLog("⚔ Combat contre " .. CombatEngine._getEnemyNames() .. " !")
end

function CombatEngine._getEnemyNames()
    local names = {}
    for _, e in ipairs(CombatEngine.enemies) do
        if e.isAlive then names[#names + 1] = e.name end
    end
    return table.concat(names, ", ")
end

function CombatEngine._buildTurnOrder()
    CombatEngine.turnOrder = {}
    for _, e in ipairs(CombatEngine.enemies) do
        if e.isAlive then
            local spd = e.speed
            for _, buff in ipairs(e.buffs) do
                if buff.stat == "speed" then spd = spd + buff.value end
            end
            CombatEngine.turnOrder[#CombatEngine.turnOrder + 1] = {
                type = "enemy", ref = e, speed = spd
            }
        end
    end
    for id, c in pairs(CombatEngine.party) do
        if c.isAlive then
            local spd = c.speed
            for _, buff in ipairs(c.buffs) do
                if buff.stat == "speed" then spd = spd + buff.value end
            end
            CombatEngine.turnOrder[#CombatEngine.turnOrder + 1] = {
                type = "party", ref = c, id = id, speed = spd
            }
        end
    end
    table.sort(CombatEngine.turnOrder, function(a, b) return a.speed > b.speed end)
end

function CombatEngine.getCurrentTurn()
    if CombatEngine.currentTurnIndex > #CombatEngine.turnOrder then
        return nil
    end
    return CombatEngine.turnOrder[CombatEngine.currentTurnIndex]
end

function CombatEngine.isPlayerTurn()
    local turn = CombatEngine.getCurrentTurn()
    return turn and turn.type == "party"
end

function CombatEngine.isEnemyTurn()
    local turn = CombatEngine.getCurrentTurn()
    return turn and turn.type == "enemy"
end

function CombatEngine.addLog(text)
    table.insert(CombatEngine.log, {
        text = text,
        time = 0,
        alpha = 1
    })
    if #CombatEngine.log > 20 then
        table.remove(CombatEngine.log, 1)
    end
end

function CombatEngine.playerAttack(targetIndex, skillId)
    local turn = CombatEngine.getCurrentTurn()
    if not turn or turn.type ~= "party" then return false end

    local attacker = turn.ref
    local target = CombatEngine.enemies[targetIndex]
    if not target or not target.isAlive then return false end

    local skill = nil
    if skillId then
        local Skills = require("src.data.skills")
        local charSkills = Skills[attacker.id] or {}
        skill = charSkills[skillId]
    end

    local mpCost = skill and skill.mpCost or 5
    if attacker.mp < mpCost then
        CombatEngine.addLog("Pas assez de MP !")
        return false
    end
    attacker.mp = attacker.mp - mpCost

    if skill then
        if skill.type == "heal" then
            local healAmount = skill.power + math.floor(attacker.attack * 0.3)
            local allyId = CombatEngine._findLowestHpPartyMember()
            if allyId then
                local ally = CombatEngine.party[allyId]
                ally.hp = math.min(ally.maxHp, ally.hp + healAmount)
                CombatEngine.addLog(attacker.name .. " soigne " .. ally.name .. " (+" .. healAmount .. " HP)")
                CombatEngine.combatStats.totalHealing = CombatEngine.combatStats.totalHealing + healAmount
            end
        elseif skill.type == "defense" then
            local shieldAmount = skill.power
            attacker.buffs[#attacker.buffs + 1] = {
                stat = "shield", value = shieldAmount, turns = 3
            }
            CombatEngine.addLog(attacker.name .. " active " .. skill.name .. " (+" .. shieldAmount .. " bouclier)")
        elseif skill.type == "support" then
            for id, c in pairs(CombatEngine.party) do
                if c.isAlive then
                    c.buffs[#c.buffs + 1] = {
                        stat = "attack", value = 3, turns = 2
                    }
                end
            end
            CombatEngine.addLog(attacker.name .. " utilise " .. skill.name .. " ! Tous les alliés boostés !")
        elseif skill.type == "special" then
            CombatEngine.addLog(attacker.name .. " utilise " .. skill.name .. " !")
            if skill.effect and skill.effect.type == "time_slow" then
                CombatEngine.addLog("Temps ralenti ! Le prochain tour est à vous.")
            end
        else
            local baseDmg = skill.power + attacker.attack
            local def = target.defense
            for _, debuff in ipairs(target.debuffs) do
                if debuff.stat == "defense" then def = def + debuff.value end
            end
            local damage = math.max(1, baseDmg - def + math.random(-3, 3))

            if skill.effect and skill.effect.type == "multi_hit" then
                local totalDmg = 0
                for h = 1, (skill.effect.hits or 1) do
                    local hitDmg = math.max(1, math.floor(damage * 0.6) + math.random(-2, 2))
                    totalDmg = totalDmg + hitDmg
                end
                target.hp = target.hp - totalDmg
                CombatEngine.addLog(attacker.name .. " utilise " .. skill.name .. " ! " ..
                    (skill.effect.hits or 1) .. " coups, " .. totalDmg .. " dégâts totaux !")
                CombatEngine.combatStats.totalDamageDealt = CombatEngine.combatStats.totalDamageDealt + totalDmg
            else
                target.hp = target.hp - damage
                CombatEngine.addLog(attacker.name .. " utilise " .. skill.name .. " sur " .. target.name .. " (-" .. damage .. " HP)")
                CombatEngine.combatStats.totalDamageDealt = CombatEngine.combatStats.totalDamageDealt + damage
            end

            if target.hp <= 0 then
                target.hp = 0
                target.isAlive = false
                CombatEngine.addLog(target.name .. " est vaincu !")
            end
        end
    else
        local baseDmg = attacker.attack
        local def = target.defense
        local damage = math.max(1, baseDmg - def + math.random(-3, 3))

        for _, buff in ipairs(attacker.buffs) do
            if buff.stat == "attack" then damage = damage + buff.value end
        end

        local shield = 0
        for _, buff in ipairs(target.buffs) do
            if buff.stat == "shield" then shield = shield + buff.value end
        end
        damage = math.max(1, damage - shield)

        target.hp = target.hp - damage
        CombatEngine.addLog(attacker.name .. " attaque " .. target.name .. " (-" .. damage .. " HP)")
        CombatEngine.combatStats.totalDamageDealt = CombatEngine.combatStats.totalDamageDealt + damage

        if target.hp <= 0 then
            target.hp = 0
            target.isAlive = false
            CombatEngine.addLog(target.name .. " est vaincu !")
        end
    end

    CombatEngine._tickBuffs(attacker)
    CombatEngine._nextTurn()
    return true
end

function CombatEngine.enemyAI()
    local turn = CombatEngine.getCurrentTurn()
    if not turn or turn.type ~= "enemy" then return end

    local enemy = turn.ref
    if not enemy.isAlive then CombatEngine._nextTurn(); return end

    local targets = {}
    for id, c in pairs(CombatEngine.party) do
        if c.isAlive then targets[#targets + 1] = { id = id, ref = c } end
    end
    if #targets == 0 then return end

    local target = targets[math.random(#targets)]

    if enemy.isBoss and enemy.phaseData then
        local hpPercent = enemy.hp / enemy.maxHp
        local newPhase = 1
        if hpPercent <= 0.15 and #enemy.phaseData >= 4 then newPhase = 4
        elseif hpPercent <= 0.4 and #enemy.phaseData >= 3 then newPhase = 3
        elseif hpPercent <= 0.7 and #enemy.phaseData >= 2 then newPhase = 2
        end

        if newPhase > enemy.bossPhase then
            enemy.bossPhase = newPhase
            local phaseData = enemy.phaseData[newPhase]
            if phaseData then
                enemy.attack = phaseData.attack or enemy.attack
                enemy.defense = phaseData.defense or enemy.defense
                enemy.speed = phaseData.speed or enemy.speed
                if phaseData.hp then enemy.hp = phaseData.hp end
                CombatEngine.addLog("⚡ " .. enemy.name .. " entre en phase " .. newPhase .. " !")
            end
        end
    end

    local availableSkills = {}
    for _, s in ipairs(enemy.skills) do
        if not s.cooldown or math.random() > 0.3 then
            availableSkills[#availableSkills + 1] = s
        end
    end

    local skill = #availableSkills > 0 and availableSkills[math.random(#availableSkills)] or nil

    if skill then
        if skill.type == "attack" then
            local damage = skill.damage + enemy.attack - target.ref.defense
            damage = math.max(1, damage + math.random(-3, 3))

            for _, buff in ipairs(target.ref.buffs) do
                if buff.stat == "shield" then damage = math.max(1, damage - buff.value) end
            end

            target.ref.hp = target.ref.hp - damage
            CombatEngine.addLog(enemy.name .. " utilise " .. skill.name .. " sur " .. target.ref.name .. " (-" .. damage .. " HP)")
            CombatEngine.combatStats.totalDamageTaken = CombatEngine.combatStats.totalDamageTaken + damage

            if target.ref.hp <= 0 then
                target.ref.hp = 0
                target.ref.isAlive = false
                CombatEngine.addLog(target.ref.name .. " est K.O. !")
            end
        elseif skill.type == "dot" then
            target.ref.debuffs[#target.ref.debuffs + 1] = {
                stat = "dot", value = skill.damage or 5, turns = skill.turns or 3
            }
            CombatEngine.addLog(enemy.name .. " infecte " .. target.ref.name .. " avec " .. skill.name .. " !")
        elseif skill.type == "multi_hit" then
            local totalDmg = 0
            for h = 1, (skill.hits or 2) do
                local dmg = math.max(1, math.floor((skill.damage or 10) * 0.7) + math.random(-2, 2))
                target.ref.hp = target.ref.hp - dmg
                totalDmg = totalDmg + dmg
            end
            CombatEngine.addLog(enemy.name .. " frappe " .. (skill.hits or 2) .. " fois avec " .. skill.name .. " ! (" .. totalDmg .. " dégâts)")
            CombatEngine.combatStats.totalDamageTaken = CombatEngine.combatStats.totalDamageTaken + totalDmg
            if target.ref.hp <= 0 then
                target.ref.hp = 0
                target.ref.isAlive = false
                CombatEngine.addLog(target.ref.name .. " est K.O. !")
            end
        elseif skill.type == "aoe" then
            local totalDmg = 0
            for id, c in pairs(CombatEngine.party) do
                if c.isAlive then
                    local dmg = math.max(1, (skill.damage or 15) - c.defense + math.random(-2, 2))
                    c.hp = c.hp - dmg
                    totalDmg = totalDmg + dmg
                    if c.hp <= 0 then
                        c.hp = 0
                        c.isAlive = false
                        CombatEngine.addLog(c.name .. " est K.O. !")
                    end
                end
            end
            CombatEngine.addLog(enemy.name .. " utilise " .. skill.name .. " sur tout le groupe ! (" .. totalDmg .. " dégâts)")
            CombatEngine.combatStats.totalDamageTaken = CombatEngine.combatStats.totalDamageTaken + totalDmg
        elseif skill.debuff then
            if math.random() < (skill.chance or 0.5) then
                target.ref.debuffs[#target.ref.debuffs + 1] = {
                    stat = skill.debuff, value = -3, turns = 2
                }
                CombatEngine.addLog(enemy.name .. " utilise " .. skill.name .. " ! " .. target.ref.name .. " est affaibli !")
            else
                CombatEngine.addLog(enemy.name .. " utilise " .. skill.name .. " mais rate !")
            end
        end
    else
        local damage = enemy.attack - target.ref.defense + math.random(-3, 3)
        damage = math.max(1, damage)
        target.ref.hp = target.ref.hp - damage
        CombatEngine.addLog(enemy.name .. " attaque " .. target.ref.name .. " (-" .. damage .. " HP)")
        CombatEngine.combatStats.totalDamageTaken = CombatEngine.combatStats.totalDamageTaken + damage

        if target.ref.hp <= 0 then
            target.ref.hp = 0
            target.ref.isAlive = false
            CombatEngine.addLog(target.ref.name .. " est K.O. !")
        end
    end

    CombatEngine._tickBuffs(enemy)
    CombatEngine._nextTurn()
end

function CombatEngine._tickBuffs(entity)
    for i = #entity.buffs, 1, -1 do
        entity.buffs[i].turns = entity.buffs[i].turns - 1
        if entity.buffs[i].turns <= 0 then
            table.remove(entity.buffs, i)
        end
    end
    for i = #entity.debuffs, 1, -1 do
        local d = entity.debuffs[i]
        d.turns = d.turns - 1
        if d.stat == "dot" and d.value then
            entity.hp = entity.hp - d.value
            CombatEngine.addLog(entity.name .. " perd " .. d.value .. " HP (dot)")
            if entity.hp <= 0 then
                entity.hp = 0
                entity.isAlive = false
            end
        end
        if d.turns <= 0 then
            table.remove(entity.debuffs, i)
        end
    end
end

function CombatEngine._nextTurn()
    CombatEngine.currentTurnIndex = CombatEngine.currentTurnIndex + 1
    CombatEngine.combatStats.turnsPlayed = CombatEngine.combatStats.turnsPlayed + 1

    if CombatEngine._checkVictory() then
        CombatEngine.state = "victory"
        CombatEngine.addLog("Victoire !")
        if CombatEngine.onVictory then CombatEngine.onVictory(CombatEngine.combatStats) end
        return
    end

    if CombatEngine._checkDefeat() then
        CombatEngine.state = "defeat"
        CombatEngine.addLog("Défaite...")
        if CombatEngine.onDefeat then CombatEngine.onDefeat() end
        return
    end

    if CombatEngine.currentTurnIndex > #CombatEngine.turnOrder then
        CombatEngine.turnCount = CombatEngine.turnCount + 1
        CombatEngine._buildTurnOrder()
        CombatEngine.currentTurnIndex = 1
    end

    local current = CombatEngine.getCurrentTurn()
    if current and current.type == "enemy" and not current.ref.isAlive then
        CombatEngine._nextTurn()
    end
end

function CombatEngine._checkVictory()
    for _, e in ipairs(CombatEngine.enemies) do
        if e.isAlive then return false end
    end
    return true
end

function CombatEngine._checkDefeat()
    for id, c in pairs(CombatEngine.party) do
        if c.isAlive then return false end
    end
    return true
end

function CombatEngine.getAlivePartyIds()
    local ids = {}
    for id, c in pairs(CombatEngine.party) do
        if c.isAlive then ids[#ids + 1] = id end
    end
    return ids
end

function CombatEngine._findLowestHpPartyMember()
    local lowest, lowestHp = nil, math.huge
    for id, c in pairs(CombatEngine.party) do
        if c.isAlive and c.hp < lowestHp then
            lowest = id
            lowestHp = c.hp
        end
    end
    return lowest
end

function CombatEngine.getPlayerSkills()
    local turn = CombatEngine.getCurrentTurn()
    if not turn or turn.type ~= "party" then return {} end
    local Skills = require("src.data.skills")
    local charSkills = Skills[turn.id] or {}
    local available = {}
    for id, skill in pairs(charSkills) do
        if (turn.ref.mp >= (skill.mpCost or 0)) and (not skill.unlockLevel or turn.ref.level >= skill.unlockLevel) then
            available[#available + 1] = { id = id, skill = skill }
        end
    end
    return available
end

function CombatEngine.getRewards()
    local xpTotal, goldTotal = 0, 0
    for _, e in ipairs(CombatEngine.enemies) do
        xpTotal = xpTotal + (e.xp or 0)
        goldTotal = goldTotal + (e.gold or 0)
    end
    return { xp = xpTotal, gold = goldTotal }
end

return CombatEngine
