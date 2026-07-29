local H = require("src.utils.helpers")
local Input = require("src.core.input")
local Widgets = require("src.ui.widgets")
local GameState = require("src.core.game_state")

local MinigameScene = {}
MinigameScene.gameType = "bubble_sort"
MinigameScene.state = "intro"
MinigameScene.score = 0
MinigameScene.maxScore = 100
MinigameScene.timer = 0
MinigameScene.maxTime = 30
MinigameScene.pieces = {}
MinigameScene.selectedIndex = 1
MinigameScene.swapIndex = nil
MinigameScene.targetSlot = 1
MinigameScene.codeLines = {}
MinigameScene.bugs = {}
MinigameScene.selectedBug = nil
MinigameScene.pipes = {}
MinigameScene.dataFlow = {}
MinigameScene.completed = false
MinigameScene.resultTimer = 0

function MinigameScene.enter(data)
    MinigameScene.gameType = data and data.gameType or "bubble_sort"
    MinigameScene.state = "intro"
    MinigameScene.score = 0
    MinigameScene.timer = 0
    MinigameScene.maxTime = 30
    MinigameScene.selectedIndex = 1
    MinigameScene.swapIndex = nil
    MinigameScene.completed = false
    MinigameScene.resultTimer = 0

    if MinigameScene.gameType == "bubble_sort" or MinigameScene.gameType == "algo_puzzle" then
        MinigameScene._initSortGame()
    elseif MinigameScene.gameType == "debug_marathon" then
        MinigameScene._initDebugGame()
    elseif MinigameScene.gameType == "hack_puzzle" or MinigameScene.gameType == "decode_puzzle" then
        MinigameScene._initHackGame()
    elseif MinigameScene.gameType == "data_flow" then
        MinigameScene._initDataFlow()
    elseif MinigameScene.gameType == "code_marathon" then
        MinigameScene._initSortGame()
        MinigameScene.maxTime = 60
    elseif MinigameScene.gameType == "audio_analysis" then
        MinigameScene._initDebugGame()
    elseif MinigameScene.gameType == "labyrinth_puzzle" then
        MinigameScene._initHackGame()
    elseif MinigameScene.gameType == "antidote_code" then
        MinigameScene._initDebugGame()
    else
        MinigameScene._initSortGame()
    end
end

function MinigameScene._initSortGame()
    local n = 8
    MinigameScene.pieces = {}
    for i = 1, n do
        MinigameScene.pieces[i] = math.random(20, 95)
    end
    MinigameScene.selectedIndex = 1
    MinigameScene.swapIndex = nil
    MinigameScene.maxTime = 30
end

function MinigameScene._initDebugGame()
    local codeTemplates = {
        {"function", "fib(n)", "{", "  if n <= 1 then return n", "  return fib(n-1) + fib(n-2)", "}"},
        {"for", "i = 1, #arr do", "  sum = sum + arr[i]", "end", "return sum", ""},
        {"local", "x = 0", "while x < 10 do", "  x = x + 1", "end", "print(x)"},
        {"if", "a > b then", "  max = a", "else", "  max = b", "end"},
        {"function", "factorial(n)", "  if n == 0 then return 1", "  return n * factorial(n-1)", "}", ""},
    }
    local template = codeTemplates[math.random(#codeTemplates)]

    MinigameScene.codeLines = {}
    MinigameScene.bugs = {}

    local bugLine = math.random(1, #template)
    for i, line in ipairs(template) do
        MinigameScene.codeLines[i] = line
    end

    local bugTypes = {
        function(l) return l:gsub("=", "=="):gsub("==", "=", 1) end,
        function(l) return l .. " END" end,
        function(l) return l:gsub("then", "than") end,
        function(l) return l:gsub("%(", "{"):gsub("%)", "}") end,
        function(l) return l .. " ;" end,
    }
    local bugFn = bugTypes[math.random(#bugTypes)]
    MinigameScene.codeLines[bugLine] = bugFn(MinigameScene.codeLines[bugLine])
    MinigameScene.bugs[bugLine] = true
    MinigameScene.selectedBug = nil
    MinigameScene.maxTime = 20
end

function MinigameScene._initHackGame()
    MinigameScene.codeLines = {
        "a]  decode(payload)",
        "b]    key = xor(payload, SECRET)",
        "c]    return key.decrypt()",
        "d]  end",
        "e]  if valid(token) then",
        "f]    grant_access()",
        "g]  end",
    }
    MinigameScene.bugs = { c = true }
    MinigameScene.selectedBug = nil
    MinigameScene.maxTime = 25
end

function MinigameScene._initDataFlow()
    MinigameScene.pipes = {}
    local gridSize = 5
    for y = 1, gridSize do
        MinigameScene.pipes[y] = {}
        for x = 1, gridSize do
            MinigameScene.pipes[y][x] = {
                type = math.random(1, 4),
                rotation = math.random(0, 3),
                filled = false,
            }
        end
    end
    MinigameScene.pipes[1][1].filled = true
    MinigameScene.targetSlot = 1
    MinigameScene.maxTime = 40
end

function MinigameScene.update(dt)
    if MinigameScene.state == "playing" then
        MinigameScene.timer = MinigameScene.timer + dt
        if MinigameScene.timer >= MinigameScene.maxTime then
            MinigameScene.state = "timeout"
        end
    elseif MinigameScene.state == "result" then
        MinigameScene.resultTimer = MinigameScene.resultTimer + dt
    end
end

function MinigameScene.draw()
    love.graphics.setColor(0.1, 0.1, 0.15)
    love.graphics.rectangle("fill", 0, 0, 1280, 720)

    if MinigameScene.state == "intro" then
        MinigameScene._drawIntro()
    elseif MinigameScene.state == "playing" then
        if MinigameScene.gameType == "bubble_sort" or MinigameScene.gameType == "algo_puzzle" or MinigameScene.gameType == "code_marathon" then
            MinigameScene._drawSortGame()
        elseif MinigameScene.gameType == "debug_marathon" or MinigameScene.gameType == "audio_analysis" or MinigameScene.gameType == "antidote_code" then
            MinigameScene._drawDebugGame()
        elseif MinigameScene.gameType == "hack_puzzle" or MinigameScene.gameType == "decode_puzzle" or MinigameScene.gameType == "labyrinth_puzzle" then
            MinigameScene._drawHackGame()
        elseif MinigameScene.gameType == "data_flow" then
            MinigameScene._drawDataFlow()
        end
    elseif MinigameScene.state == "result" or MinigameScene.state == "timeout" then
        MinigameScene._drawResult()
    end

    love.graphics.setColor(1, 1, 1, 1)
end

function MinigameScene._drawIntro()
    love.graphics.setColor(0.2, 0.6, 1, 1)
    love.graphics.setFont(Widgets.fonts.large)
    local title = "Mini-jeu de Code"
    love.graphics.print(title, 480, 200)

    love.graphics.setColor(0.7, 0.7, 0.8, 1)
    love.graphics.setFont(Widgets.fonts.medium)
    local desc = "Résolvez le défi avant la fin du temps !"
    love.graphics.print(desc, 420, 260)

    local gameDescs = {
        bubble_sort = "Triez les valeurs en ordre croissant en échangeant les blocs adjacents.",
        algo_puzzle = "Assemblez l'algorithme dans le bon ordre.",
        debug_marathon = "Trouvez et cliquez sur l'erreur dans le code.",
        hack_puzzle = "Corrigez le code pour accéder au système.",
        decode_puzzle = "Déchiffrez le message en trouvant l'erreur.",
        data_flow = "Orientez les tuyaux pour guider les données.",
        code_marathon = "Corrigez le maximum de bugs en temps limité.",
        audio_analysis = "Analysez le code et trouvez l'anomalie.",
        labyrinth_puzzle = "Résolvez l'énigme du labyrinthe.",
        antidote_code = "Écrivez le code de l'antidote.",
    }
    local desc2 = gameDescs[MinigameScene.gameType] or "Défi de programmation."
    love.graphics.setColor(0.5, 0.5, 0.6, 1)
    love.graphics.print(desc2, 380, 300)

    Widgets.drawButtonClicked(540, 400, 200, 60, "COMMENCER", {
        color = {r = 0.2, g = 0.7, b = 0.3},
    })
    if Input.isClickInRect(540, 400, 200, 60) then
        MinigameScene.state = "playing"
        MinigameScene.timer = 0
    end

    Widgets.drawButtonClicked(540, 480, 200, 50, "Retour", {
        color = {r = 0.3, g = 0.3, b = 0.4},
    })
    if Input.isClickInRect(540, 480, 200, 50) then
        local SceneManager = require("src.core.scene_manager")
        SceneManager.pop()
    end
end

function MinigameScene._drawSortGame()
    Widgets.drawTextWithShadow("Trie les valeurs (clic sur 2 blocs pour échanger)", Widgets.fonts.small, 50, 20, {r=0.5, g=0.8, b=1})

    local timeLeft = math.max(0, MinigameScene.maxTime - MinigameScene.timer)
    Widgets.drawTextWithShadow("Temps: " .. string.format("%.1f", timeLeft), Widgets.fonts.medium, 1100, 20,
        timeLeft < 5 and {r=1, g=0.3, b=0.3} or {r=1, g=1, b=1})

    local barW = 1000
    local barX = 140
    local barY = 80
    local blockW = barW / #MinigameScene.pieces

    for i, val in ipairs(MinigameScene.pieces) do
        local bx = barX + (i - 1) * blockW
        local bh = val * 4
        local by = barY + 300 - bh

        local isSelected = MinigameScene.selectedIndex == i
        local isSwapping = MinigameScene.swapIndex == i

        if isSelected or isSwapping then
            love.graphics.setColor(0, 1, 0.5, 0.3)
            love.graphics.rectangle("fill", bx - 2, by - 2, blockW - 4, bh + 4, 3)
        end

        local hue = (i / #MinigameScene.pieces) * 0.6
        love.graphics.setColor(hue + 0.2, 0.5, 1 - hue, 0.9)
        love.graphics.rectangle("fill", bx + 2, by, blockW - 6, bh, 3)

        love.graphics.setColor(1, 1, 1, 0.9)
        love.graphics.setFont(Widgets.fonts.tiny)
        love.graphics.print(tostring(val), bx + blockW / 2 - 8, by - 15)
    end

    local sorted = true
    for i = 2, #MinigameScene.pieces do
        if MinigameScene.pieces[i] < MinigameScene.pieces[i-1] then
            sorted = false
            break
        end
    end

    if sorted and MinigameScene.timer > 1 then
        MinigameScene.score = math.max(0, 100 - math.floor(MinigameScene.timer * 3))
        MinigameScene.state = "result"
        MinigameScene.completed = true
    end
end

function MinigameScene._drawDebugGame()
    Widgets.drawTextWithShadow("Trouve et clique sur la ligne buguée !", Widgets.fonts.small, 50, 20, {r=1, g=0.6, b=0.2})

    local timeLeft = math.max(0, MinigameScene.maxTime - MinigameScene.timer)
    Widgets.drawTextWithShadow("Temps: " .. string.format("%.1f", timeLeft), Widgets.fonts.medium, 1100, 20,
        timeLeft < 5 and {r=1, g=0.3, b=0.3} or {r=1, g=1, b=1})

    local codeX = 150
    local codeY = 80
    local lineH = 32

    love.graphics.setColor(0.15, 0.15, 0.2, 0.9)
    H.drawRoundRect(codeX - 20, codeY - 10, 800, #MinigameScene.codeLines * lineH + 30, 8)

    for i, line in ipairs(MinigameScene.codeLines) do
        local ly = codeY + (i - 1) * lineH
        local isBug = MinigameScene.bugs[i]

        love.graphics.setColor(0.3, 0.3, 0.4, 0.6)
        love.graphics.setFont(Widgets.fonts.tiny)
        love.graphics.print(string.format("%2d", i), codeX - 10, ly)

        if MinigameScene.selectedBug == i then
            if isBug then
                love.graphics.setColor(0, 0.8, 0.3, 0.3)
            else
                love.graphics.setColor(1, 0.2, 0.2, 0.3)
            end
            love.graphics.rectangle("fill", codeX, ly - 2, 750, lineH, 3)
        end

        love.graphics.setColor(isBug and {r=1, g=0.9, b=0.5} or {r=0.7, g=0.8, b=0.9}, 0.9)
        love.graphics.setFont(Widgets.fonts.small)
        love.graphics.print(line, codeX + 10, ly + 4)
    end

    love.graphics.setColor(0.4, 0.4, 0.5, 0.7)
    love.graphics.setFont(Widgets.fonts.tiny)
    love.graphics.print("Clique sur la ligne contenant le bug", 350, 680)
end

function MinigameScene._drawHackGame()
    Widgets.drawTextWithShadow("Corrigez le code pour accéder au système", Widgets.fonts.small, 50, 20, {r=0, g=1, b=0.5})

    local timeLeft = math.max(0, MinigameScene.maxTime - MinigameScene.timer)
    Widgets.drawTextWithShadow("Temps: " .. string.format("%.1f", timeLeft), Widgets.fonts.medium, 1100, 20,
        timeLeft < 5 and {r=1, g=0.3, b=0.3} or {r=1, g=1, b=1})

    local codeX = 150
    local codeY = 80
    local lineH = 32

    for i, line in ipairs(MinigameScene.codeLines) do
        local ly = codeY + (i - 1) * lineH
        local isBug = MinigameScene.bugs[i]

        love.graphics.setColor(0, isBug and 0.8 or 0.3, isBug and 0.3 or 0.3, 0.9)
        love.graphics.rectangle("fill", codeX - 5, ly - 2, 800, lineH, 3)

        love.graphics.setColor(1, 1, 1, 0.9)
        love.graphics.setFont(Widgets.fonts.small)
        love.graphics.print(line, codeX + 10, ly + 4)
    end

    love.graphics.setColor(0.4, 0.4, 0.5, 0.7)
    love.graphics.setFont(Widgets.fonts.tiny)
    love.graphics.print("Trouvez la ligne corrompue et cliquez dessus", 350, 680)
end

function MinigameScene._drawDataFlow()
    Widgets.drawTextWithShadow("Orientez les tuyaux pour guider le flux", Widgets.fonts.small, 50, 20, {r=0.3, g=0.8, b=1})

    local timeLeft = math.max(0, MinigameScene.maxTime - MinigameScene.timer)
    Widgets.drawTextWithShadow("Temps: " .. string.format("%.1f", timeLeft), Widgets.fonts.medium, 1100, 20,
        timeLeft < 5 and {r=1, g=0.3, b=0.3} or {r=1, g=1, b=1})

    local gridSize = 5
    local cellSize = 80
    local startX = (1280 - gridSize * cellSize) / 2
    local startY = 100

    for y = 1, gridSize do
        for x = 1, gridSize do
            local cell = MinigameScene.pipes[y][x]
            local cx = startX + (x - 1) * cellSize
            local cy = startY + (y - 1) * cellSize

            love.graphics.setColor(0.15, 0.15, 0.2, 0.8)
            love.graphics.rectangle("fill", cx + 5, cy + 5, cellSize - 10, cellSize - 10, 4)

            if cell.filled then
                love.graphics.setColor(0, 0.8, 0.5, 0.6)
            else
                love.graphics.setColor(0.3, 0.3, 0.4, 0.6)
            end

            local pipeChars = {"─", "│", "┐", "└"}
            love.graphics.setFont(Widgets.fonts.large)
            love.graphics.push()
            love.graphics.translate(cx + cellSize / 2, cy + cellSize / 2)
            love.graphics.rotate(cell.rotation * math.pi / 2)
            love.graphics.print(pipeChars[cell.type] or "+", -8, -12)
            love.graphics.pop()
        end
    end
end

function MinigameScene._drawResult()
    if MinigameScene.state == "timeout" then
        love.graphics.setColor(1, 0.3, 0.2, 1)
        love.graphics.setFont(Widgets.fonts.large)
        love.graphics.print("TEMPS ÉCOULÉ !", 500, 280)
    else
        love.graphics.setColor(0.2, 1, 0.5, 1)
        love.graphics.setFont(Widgets.fonts.large)
        love.graphics.print("RÉUSSI !", 540, 250)
    end

    love.graphics.setColor(0.7, 0.7, 0.8, 1)
    love.graphics.setFont(Widgets.fonts.medium)
    love.graphics.print("Score: " .. MinigameScene.score .. "/100", 530, 320)
    love.graphics.print("Temps: " .. string.format("%.1f", MinigameScene.timer) .. "s", 530, 355)

    if MinigameScene.resultTimer > 1 then
        Widgets.drawButtonClicked(540, 420, 200, 50, "Continuer", {
            color = {r = 0.2, g = 0.6, b = 0.3},
        })
        if Input.isClickInRect(540, 420, 200, 50) then
            if MinigameScene.completed then
                GameState.addNotification("Mini-jeu réussi ! +" .. MinigameScene.score .. " XP", "success")
                for id, _ in pairs(GameState.party) do
                    GameState.addXp(id, math.floor(MinigameScene.score / 2))
                end
            else
                GameState.addNotification("Mini-jeu terminé.", "info")
            end
            local SceneManager = require("src.core.scene_manager")
            SceneManager.pop()
        end
    end
end

function MinigameScene.keypressed(key, scancode, isrepeat)
    if MinigameScene.state ~= "playing" then return end

    if MinigameScene.gameType == "bubble_sort" or MinigameScene.gameType == "algo_puzzle" or MinigameScene.gameType == "code_marathon" then
        if key == "left" or key == "a" then
            MinigameScene.selectedIndex = math.max(1, MinigameScene.selectedIndex - 1)
        elseif key == "right" or key == "d" then
            MinigameScene.selectedIndex = math.min(#MinigameScene.pieces, MinigameScene.selectedIndex + 1)
        elseif key == "space" or key == "return" then
            if MinigameScene.swapIndex then
                local a, b = MinigameScene.swapIndex, MinigameScene.selectedIndex
                MinigameScene.pieces[a], MinigameScene.pieces[b] = MinigameScene.pieces[b], MinigameScene.pieces[a]
                MinigameScene.swapIndex = nil
                MinigameScene.score = MinigameScene.score + 5
            else
                MinigameScene.swapIndex = MinigameScene.selectedIndex
            end
        elseif key == "escape" then
            MinigameScene.swapIndex = nil
        end
    end
end

function MinigameScene.mousepressed(x, y, button, istouch)
    if MinigameScene.state ~= "playing" then return end

    if MinigameScene.gameType == "bubble_sort" or MinigameScene.gameType == "algo_puzzle" or MinigameScene.gameType == "code_marathon" then
        local barX = 140
        local blockW = 1000 / #MinigameScene.pieces
        for i = 1, #MinigameScene.pieces do
            local bx = barX + (i - 1) * blockW
            if Input.isClickInRect(bx, 80, blockW, 380) then
                if MinigameScene.swapIndex then
                    local a, b = MinigameScene.swapIndex, i
                    MinigameScene.pieces[a], MinigameScene.pieces[b] = MinigameScene.pieces[b], MinigameScene.pieces[a]
                    MinigameScene.swapIndex = nil
                    MinigameScene.score = MinigameScene.score + 5
                else
                    MinigameScene.swapIndex = i
                    MinigameScene.selectedIndex = i
                end
                return
            end
        end
    elseif MinigameScene.gameType == "debug_marathon" or MinigameScene.gameType == "audio_analysis" or MinigameScene.gameType == "antidote_code" then
        local codeY = 80
        local lineH = 32
        for i = 1, #MinigameScene.codeLines do
            local ly = codeY + (i - 1) * lineH
            if Input.isClickInRect(150, ly - 2, 750, lineH) then
                MinigameScene.selectedBug = i
                if MinigameScene.bugs[i] then
                    MinigameScene.score = 100
                    MinigameScene.completed = true
                    MinigameScene.state = "result"
                else
                    MinigameScene.score = math.max(0, MinigameScene.score - 10)
                    GameState.addSanity(-3)
                end
                return
            end
        end
    elseif MinigameScene.gameType == "hack_puzzle" or MinigameScene.gameType == "decode_puzzle" or MinigameScene.gameType == "labyrinth_puzzle" then
        local codeY = 80
        local lineH = 32
        for i = 1, #MinigameScene.codeLines do
            local ly = codeY + (i - 1) * lineH
            if Input.isClickInRect(150, ly - 2, 800, lineH) then
                if MinigameScene.bugs[i] then
                    MinigameScene.score = 100
                    MinigameScene.completed = true
                    MinigameScene.state = "result"
                else
                    MinigameScene.score = math.max(0, MinigameScene.score - 10)
                    GameState.addSanity(-3)
                end
                return
            end
        end
    elseif MinigameScene.gameType == "data_flow" then
        local gridSize = 5
        local cellSize = 80
        local startX = (1280 - gridSize * cellSize) / 2
        local startY = 100
        for y = 1, gridSize do
            for x = 1, gridSize do
                local cx = startX + (x - 1) * cellSize
                local cy = startY + (y - 1) * cellSize
                if Input.isClickInRect(cx, cy, cellSize, cellSize) then
                    MinigameScene.pipes[y][x].rotation = (MinigameScene.pipes[y][x].rotation + 1) % 4
                    return
                end
            end
        end
    end
end

function MinigameScene.touchreleased(id, x, y, dx, dy, pressure)
    MinigameScene.mousepressed(x, y, 1, false)
end

return MinigameScene
