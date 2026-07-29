local H = require("src.utils.helpers")
local Input = require("src.core.input")
local Widgets = require("src.ui.widgets")
local GameState = require("src.core.game_state")
local PixelArt = require("src.ui.pixel_art")

local TitleScene = {}
TitleScene.bgAlpha = 0
TitleScene.menuAlpha = 0
TitleScene.selectedIndex = 1
TitleScene.titlePulse = 0
TitleScene.stars = {}
TitleScene.glitchTimer = 0
TitleScene.glitchActive = false

function TitleScene.enter(data)
    TitleScene.bgAlpha = 0
    TitleScene.menuAlpha = 0
    TitleScene.selectedIndex = 1
    TitleScene.titlePulse = 0
    TitleScene.stars = {}
    TitleScene.glitchTimer = 0
    TitleScene.glitchActive = false

    for i = 1, 100 do
        TitleScene.stars[i] = {
            x = math.random(1280),
            y = math.random(720),
            speed = math.random(20, 60),
            size = math.random(1, 3),
            alpha = math.random() * 0.5 + 0.3
        }
    end
end

function TitleScene.update(dt)
    TitleScene.bgAlpha = math.min(1, TitleScene.bgAlpha + dt * 0.5)
    TitleScene.menuAlpha = math.min(1, TitleScene.menuAlpha + dt * 0.8)
    TitleScene.titlePulse = TitleScene.titlePulse + dt

    for _, star in ipairs(TitleScene.stars) do
        star.y = star.y + star.speed * dt
        if star.y > 720 then star.y = 0; star.x = math.random(1280) end
    end

    TitleScene.glitchTimer = TitleScene.glitchTimer + dt
    if TitleScene.glitchTimer > 3 then
        TitleScene.glitchActive = math.random() < 0.1
        if TitleScene.glitchActive then TitleScene.glitchTimer = 0 end
    end
end

function TitleScene.draw()
    PixelArt.drawBackground("dark_iai", 1280, 720)

    love.graphics.setColor(0, 1, 0.5, 0.15)
    for i = 1, 30 do
        local x = (i * 43 + love.timer.getTime() * 10) % 1280
        love.graphics.rectangle("fill", x, math.random(720), math.random(10, 60), 1)
    end

    for _, star in ipairs(TitleScene.stars) do
        love.graphics.setColor(0.5, 1, 0.8, star.alpha * TitleScene.bgAlpha)
        love.graphics.rectangle("fill", star.x, star.y, star.size, star.size)
    end

    local titleY = 120 + math.sin(TitleScene.titlePulse * 1.5) * 5

    if TitleScene.glitchActive then
        love.graphics.setColor(1, 0, 0, 0.3)
        love.graphics.setFont(Widgets.fonts.title)
        love.graphics.print("IA SURVIVORS", 442 + math.random(-5, 5), titleY + math.random(-3, 3))
        love.graphics.setColor(0, 1, 0, 0.3)
        love.graphics.print("IA SURVIVORS", 438 + math.random(-5, 5), titleY + math.random(-3, 3))
    end

    Widgets.drawTextWithShadow(
        "IA SURVIVORS", Widgets.fonts.title,
        440, titleY,
        { r = 0.1, g = 1, b = 0.7 }
    )
    Widgets.drawTextWithShadow(
        "SEMESTRE 1", Widgets.fonts.large,
        520, titleY + 55,
        { r = 0.8, g = 0.2, b = 0.5 }
    )

    local subtitle = "Le code est la magie moderne, mais toute magie a un prix."
    love.graphics.setColor(0.6, 0.6, 0.7, TitleScene.bgAlpha * 0.7)
    love.graphics.setFont(Widgets.fonts.small)
    local sw = Widgets.fonts.small:getWidth(subtitle)
    love.graphics.print(subtitle, (1280 - sw) / 2, titleY + 100)

    if TitleScene.menuAlpha > 0.5 then
        local menuX = 440
        local menuY = 340
        local menuW = 400
        local menuH = 240

        Widgets.drawPanel(menuX, menuY, menuW, menuH, {
            bgColor = { r = 0.05, g = 0.05, b = 0.1 },
            borderColor = { r = 0, g = 0.8, b = 0.5 },
            alpha = TitleScene.menuAlpha * 0.9,
        })

        local menuItems = {
            { text = "▶  Nouvelle Partie", id = "new" },
            { text = "📂  Continuer", id = "continue" },
            { text = "⚙  Options", id = "options" },
        }

        for i, item in ipairs(menuItems) do
            local iy = menuY + 30 + (i - 1) * 65
            local isHovered = Input.isMouseInRect(menuX + 20, iy, menuW - 40, 50)
            local isSelected = (TitleScene.selectedIndex == i)

            if isSelected or isHovered then
                love.graphics.setColor(0, 0.8, 0.5, 0.15)
                H.drawRoundRect(menuX + 20, iy, menuW - 40, 50, 6)
            end

            love.graphics.setColor(
                isSelected and 1 or 0.7,
                isSelected and 1 or 0.7,
                isSelected and 1 or 0.7,
                TitleScene.menuAlpha
            )
            love.graphics.setFont(Widgets.fonts.large)
            love.graphics.print(item.text, menuX + 40, iy + 10)
        end

        love.graphics.setColor(0, 0.8, 0.5, 0.4 * TitleScene.menuAlpha)
        love.graphics.setFont(Widgets.fonts.tiny)
        love.graphics.print("Flèches/Haut-Bas + Entrée ou Clic", menuX + 80, menuY + menuH - 25)
    end

    love.graphics.setColor(0.3, 0.3, 0.4, TitleScene.menuAlpha * 0.5)
    love.graphics.setFont(Widgets.fonts.tiny)
    love.graphics.print("IA Survivors — Semestre 1 v0.1", 10, 700)
    love.graphics.print("Un jeu sur l'amitié, le code, et la survie", 10, 680)

    love.graphics.setColor(1, 1, 1, 1)
end

function TitleScene.keypressed(key, scancode, isrepeat)
    if key == "up" or key == "w" then
        TitleScene.selectedIndex = math.max(1, TitleScene.selectedIndex - 1)
    elseif key == "down" or key == "s" then
        TitleScene.selectedIndex = math.min(3, TitleScene.selectedIndex + 1)
    elseif key == "return" or key == "space" then
        TitleScene._select()
    end
end

function TitleScene.mousepressed(x, y, button, istouch)
    if button == 1 then
        TitleScene._checkClick()
    end
end

function TitleScene.touchreleased(id, x, y, dx, dy, pressure)
    TitleScene._checkClick()
end

function TitleScene._checkClick()
    local menuX = 440
    local menuY = 340
    local menuW = 400

    for i = 1, 3 do
        local iy = menuY + 30 + (i - 1) * 65
        if Input.isClickInRect(menuX + 20, iy, menuW - 40, 50) then
            TitleScene.selectedIndex = i
            TitleScene._select()
            return
        end
    end
end

function TitleScene._select()
    local choice = TitleScene.selectedIndex
    if choice == 1 then
        GameState.init()
        local SceneManager = require("src.core.scene_manager")
        SceneManager.switchTo("campus")
    elseif choice == 2 then
        local ok = GameState.load()
        if ok then
            local SceneManager = require("src.core.scene_manager")
            SceneManager.switchTo("campus")
        else
            GameState.addNotification("Aucune sauvegarde trouvée !", "warning")
        end
    elseif choice == 3 then
        GameState.addNotification("Options à venir...", "info")
    end
end

return TitleScene
