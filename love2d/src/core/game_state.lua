local H = require("src.utils.helpers")

local GameState = {
    week = 0,
    maxWeek = 17,
    chapter = 1,
    dayOfWeek = 1,
    timeOfDay = "morning",
    phase = "title",
    playerName = "not_a_genius",
    gold = 50,
    energy = 100,
    maxEnergy = 100,
    sanity = 100,
    maxSanity = 100,
    flags = {},
    relationships = {},
    party = {},
    inventory = {},
    unlockedLocations = {},
    combatLog = {},
    weekHistory = {},
    currentWeekData = nil,
    achievements = {},
    totalPlayTime = 0,
    difficulty = "normal",
    screenShake = { amount = 0, duration = 0, elapsed = 0 },
    notifications = {},
    questLog = {},
    darkIaiAccess = false,
    ogun0Awakened = false,
    hemeryfbTrust = 0,
    virusProgress = 0,
}

local STATS = {
    logic = { base = 5, max = 20, label = "Logique" },
    creativity = { base = 5, max = 20, label = "Créativité" },
    endurance = { base = 5, max = 20, label = "Endurance Mentale" },
    social = { base = 3, max = 20, label = "Social" },
    coding = { base = 5, max = 20, label = "Code" },
}

local function makeCharacter(id, data)
    local stats = {}
    for k, def in pairs(STATS) do
        stats[k] = {
            value = (data.stats and data.stats[k]) or def.base,
            base = (data.stats and data.stats[k]) or def.base,
            max = def.max,
            label = def.label
        }
    end
    return {
        id = id,
        name = data.name or id,
        title = data.title or "",
        hp = data.hp or 100,
        maxHp = data.hp or 100,
        mp = data.mp or 60,
        maxMp = data.mp or 60,
        xp = 0,
        level = 1,
        stats = stats,
        skills = data.skills or {},
        portrait = data.portrait or {},
        personality = data.personality or {},
        color = data.color or {r=1,g=1,b=1},
        isAlive = true,
        buffs = {},
        debuffs = {},
        description = data.description or ""
    }
end

function GameState.init()
    GameState.week = 1
    GameState.chapter = 1
    GameState.dayOfWeek = 1
    GameState.timeOfDay = "morning"
    GameState.phase = "title"
    GameState.gold = 50
    GameState.energy = 100
    GameState.sanity = 100
    GameState.flags = {}
    GameState.inventory = {}
    GameState.combatLog = {}
    GameState.weekHistory = {}
    GameState.notifications = {}
    GameState.questLog = {}
    GameState.darkIaiAccess = false
    GameState.ogun0Awakened = false
    GameState.hemeryfbTrust = 0
    GameState.virusProgress = 0
    GameState.totalPlayTime = 0
    GameState.achievements = {}

    GameState.relationships = {
        not_a_genius_laurencium = 50,
        not_a_genius_king = 50,
        not_a_genius_arsene = 50,
        not_a_genius_hemeryfb = 0,
        laurencium_king = 60,
        laurencium_arsene = 55,
        laurencium_hemeryfb = 10,
        king_arsene = 50,
        king_hemeryfb = 15,
        arsene_hemeryfb = 20,
    }

    GameState.unlockedLocations = {
        "bureau",
        "cafeteria",
        "salle_de_cours",
    }

    local Characters = require("src.data.characters")
    GameState.party = {}
    for id, data in pairs(Characters) do
        GameState.party[id] = makeCharacter(id, data)
    end
end

function GameState.getChar(id)
    return GameState.party[id]
end

function GameState.getCharHpPercent(id)
    local c = GameState.getChar(id)
    if not c then return 0 end
    return c.hp / c.maxHp
end

function GameState.getCharMpPercent(id)
    local c = GameState.getChar(id)
    if not c then return 0 end
    return c.mp / c.maxMp
end

function GameState.healChar(id, amount)
    local c = GameState.getChar(id)
    if not c then return end
    c.hp = math.min(c.maxHp, c.hp + amount)
end

function GameState.damageChar(id, amount)
    local c = GameState.getChar(id)
    if not c then return end
    c.hp = math.max(0, c.hp - amount)
    if c.hp <= 0 then
        c.isAlive = false
    end
end

function GameState.restoreMp(id, amount)
    local c = GameState.getChar(id)
    if not c then return end
    c.mp = math.min(c.maxMp, c.mp + amount)
end

function GameState.spendMp(id, amount)
    local c = GameState.getChar(id)
    if not c then return false end
    if c.mp < amount then return false end
    c.mp = c.mp - amount
    return true
end

function GameState.modifyStat(id, stat, amount)
    local c = GameState.getChar(id)
    if not c then return end
    if c.stats[stat] then
        c.stats[stat].value = Helpers.clamp(
            c.stats[stat].value + amount, 1, c.stats[stat].max
        )
    end
end

function GameState.getRelationship(a, b)
    local key1 = a .. "_" .. b
    local key2 = b .. "_" .. a
    return GameState.relationships[key1] or GameState.relationships[key2] or 0
end

function GameState.modifyRelationship(a, b, amount)
    local key1 = a .. "_" .. b
    local key2 = b .. "_" .. a
    if GameState.relationships[key1] ~= nil then
        GameState.relationships[key1] = Helpers.clamp(
            GameState.relationships[key1] + amount, -100, 100
        )
    elseif GameState.relationships[key2] ~= nil then
        GameState.relationships[key2] = Helpers.clamp(
            GameState.relationships[key2] + amount, -100, 100
        )
    end
end

function GameState.setFlag(flag, value)
    GameState.flags[flag] = value ~= nil and value or true
end

function GameState.getFlag(flag)
    return GameState.flags[flag]
end

function GameState.hasFlag(flag)
    return GameState.flags[flag] ~= nil and GameState.flags[flag] ~= false
end

function GameState.addNotification(text, type)
    table.insert(GameState.notifications, {
        text = text,
        type = type or "info",
        elapsed = 0,
        duration = 3,
        alpha = 0
    })
end

function GameState.addQuest(quest)
    GameState.questLog[quest.id] = {
        id = quest.id,
        title = quest.title,
        description = quest.description,
        active = true,
        completed = false
    }
end

function GameState.completeQuest(id)
    if GameState.questLog[id] then
        GameState.questLog[id].active = false
        GameState.questLog[id].completed = true
    end
end

function GameState.addXp(id, amount)
    local c = GameState.getChar(id)
    if not c then return end
    c.xp = c.xp + amount
    local xpNeeded = c.level * 100
    while c.xp >= xpNeeded do
        c.xp = c.xp - xpNeeded
        c.level = c.level + 1
        c.maxHp = c.maxHp + 15
        c.maxMp = c.maxMp + 8
        c.hp = c.maxHp
        c.mp = c.maxMp
        for stat, def in pairs(c.stats) do
            c.stats[stat].value = math.min(def.max, c.stats[stat].value + 1)
        end
        GameState.addNotification(c.name .. " passe niveau " .. c.level .. " !", "levelup")
        xpNeeded = c.level * 100
    end
end

function GameState.allPartyAlive()
    for _, c in pairs(GameState.party) do
        if c.isAlive then return true end
    end
    return false
end

function GameState.reviveParty()
    for _, c in pairs(GameState.party) do
        c.isAlive = true
        c.hp = math.max(c.hp, math.floor(c.maxHp * 0.3))
        c.mp = math.max(c.mp, math.floor(c.maxMp * 0.3))
    end
end

function GameState.applyScreenShake(amount, duration)
    GameState.screenShake.amount = amount
    GameState.screenShake.duration = duration
    GameState.screenShake.elapsed = 0
end

function GameState.updateScreenShake(dt)
    local s = GameState.screenShake
    if s.duration > 0 then
        s.elapsed = s.elapsed + dt
        if s.elapsed >= s.duration then
            s.amount = 0
            s.duration = 0
            s.elapsed = 0
        end
    end
end

function GameState.getShakeOffset()
    local s = GameState.screenShake
    if s.amount > 0 then
        local intensity = s.amount * (1 - s.elapsed / s.duration)
        return math.random(-intensity, intensity), math.random(-intensity, intensity)
    end
    return 0, 0
end

function GameState.updateNotifications(dt)
    for i = #GameState.notifications, 1, -1 do
        local n = GameState.notifications[i]
        n.elapsed = n.elapsed + dt
        if n.elapsed < 0.3 then
            n.alpha = n.elapsed / 0.3
        elseif n.elapsed > n.duration - 0.5 then
            n.alpha = math.max(0, (n.duration - n.elapsed) / 0.5)
        else
            n.alpha = 1
        end
        if n.elapsed >= n.duration then
            table.remove(GameState.notifications, i)
        end
    end
end

function GameState.addEnergy(amount)
    GameState.energy = Helpers.clamp(GameState.energy + amount, 0, GameState.maxEnergy)
end

function GameState.spendEnergy(amount)
    if GameState.energy < amount then return false end
    GameState.energy = GameState.energy - amount
    return true
end

function GameState.addSanity(amount)
    GameState.sanity = Helpers.clamp(GameState.sanity + amount, 0, GameState.maxSanity)
end

function GameState.spendSanity(amount)
    GameState.sanity = math.max(0, GameState.sanity - amount)
end

function GameState.save()
    local data = {
        week = GameState.week,
        chapter = GameState.chapter,
        dayOfWeek = GameState.dayOfWeek,
        timeOfDay = GameState.timeOfDay,
        playerName = GameState.playerName,
        gold = GameState.gold,
        energy = GameState.energy,
        sanity = GameState.sanity,
        flags = GameState.flags,
        relationships = GameState.relationships,
        inventory = GameState.inventory,
        unlockedLocations = GameState.unlockedLocations,
        darkIaiAccess = GameState.darkIaiAccess,
        ogun0Awakened = GameState.ogun0Awakened,
        hemeryfbTrust = GameState.hemeryfbTrust,
        virusProgress = GameState.virusProgress,
        achievements = GameState.achievements,
        questLog = GameState.questLog,
    }
    local partyData = {}
    for id, c in pairs(GameState.party) do
        local stats = {}
        for k, s in pairs(c.stats) do
            stats[k] = { value = s.value, base = s.base, max = s.max, label = s.label }
        end
        partyData[id] = {
            id = c.id, name = c.name, title = c.title,
            hp = c.hp, maxHp = c.maxHp, mp = c.mp, maxMp = c.maxMp,
            xp = c.xp, level = c.level, stats = stats,
            skills = c.skills, isAlive = c.isAlive,
            personality = c.personality, color = c.color,
            description = c.description
        }
    end
    data.party = partyData
    local json = require("src.utils.json")
    local ok, err = pcall(function()
        local f = io.open("save.json", "w")
        if f then
            f:write(json.encode(data))
            f:close()
        end
    end)
    return ok, err
end

function GameState.load()
    local json = require("src.utils.json")
    local ok, data = pcall(function()
        local f = io.open("save.json", "r")
        if not f then return nil end
        local content = f:read("*a")
        f:close()
        return json.decode(content)
    end)
    if not ok or not data then return false end

    GameState.week = data.week or 1
    GameState.chapter = data.chapter or 1
    GameState.dayOfWeek = data.dayOfWeek or 1
    GameState.timeOfDay = data.timeOfDay or "morning"
    GameState.gold = data.gold or 50
    GameState.energy = data.energy or 100
    GameState.sanity = data.sanity or 100
    GameState.flags = data.flags or {}
    GameState.relationships = data.relationships or {}
    GameState.inventory = data.inventory or {}
    GameState.unlockedLocations = data.unlockedLocations or {}
    GameState.darkIaiAccess = data.darkIaiAccess or false
    GameState.ogun0Awakened = data.ogun0Awakened or false
    GameState.hemeryfbTrust = data.hemeryfbTrust or 0
    GameState.virusProgress = data.virusProgress or 0
    GameState.achievements = data.achievements or {}
    GameState.questLog = data.questLog or {}

    if data.party then
        for id, pd in pairs(data.party) do
            local stats = {}
            for k, s in pairs(pd.stats) do
                stats[k] = { value = s.value, base = s.base, max = s.max, label = s.label }
            end
            GameState.party[id] = {
                id = pd.id, name = pd.name, title = pd.title or "",
                hp = pd.hp, maxHp = pd.maxHp, mp = pd.mp, maxMp = pd.maxMp,
                xp = pd.xp or 0, level = pd.level or 1, stats = stats,
                skills = pd.skills or {}, isAlive = pd.isAlive ~= false,
                portrait = pd.portrait or {},
                personality = pd.personality or {},
                color = pd.color or {r=1,g=1,b=1},
                buffs = {}, debuffs = {},
                description = pd.description or ""
            }
        end
    end
    return true
end

return GameState
