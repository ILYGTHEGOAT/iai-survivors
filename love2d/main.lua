local SceneManager = require("src.core.scene_manager")
local Input = require("src.core.input")
local Widgets = require("src.ui.widgets")
local GameState = require("src.core.game_state")

local TitleScene = require("src.scenes.title_scene")
local CampusScene = require("src.scenes.campus_scene")
local CombatScene = require("src.scenes.combat_scene")
local DialogueScene = require("src.scenes.dialogue_scene")
local MinigameScene = require("src.scenes.minigame_scene")
local GameOverScene = require("src.scenes.game_over_scene")

function love.load()
    love.graphics.setBackgroundColor(0, 0, 0)
    love.window.setTitle("IA Survivors — Semestre 1")

    Widgets.init()

    SceneManager.register("title", TitleScene)
    SceneManager.register("campus", CampusScene)
    SceneManager.register("combat", CombatScene)
    SceneManager.register("dialogue", DialogueScene)
    SceneManager.register("minigame", MinigameScene)
    SceneManager.register("game_over", GameOverScene)

    SceneManager.goTo("title")
end

function love.update(dt)
    Input.update()
    SceneManager.update(dt)
    Input.clear()
end

function love.draw()
    local sw, sh = love.graphics.getDimensions()
    local scale = math.min(sw / 1280, sh / 720)
    local offsetX = (sw - 1280 * scale) / 2
    local offsetY = (sh - 720 * scale) / 2

    love.graphics.push()
    love.graphics.translate(offsetX, offsetY)
    love.graphics.scale(scale, scale)

    love.graphics.setScissor(offsetX, offsetY, 1280 * scale, 720 * scale)

    SceneManager.draw()

    love.graphics.setScissor()
    love.graphics.pop()

    love.graphics.setColor(0, 0, 0)
    if offsetX > 0 then
        love.graphics.rectangle("fill", 0, 0, offsetX, sh)
        love.graphics.rectangle("fill", sw - offsetX, 0, offsetX, sh)
    end
    if offsetY > 0 then
        love.graphics.rectangle("fill", 0, 0, sw, offsetY)
        love.graphics.rectangle("fill", 0, sh - offsetY, sw, offsetY)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function love.keypressed(key, scancode, isrepeat)
    Input.keypressed(key, scancode, isrepeat)
    SceneManager.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
    Input.keyreleased(key, scancode)
    SceneManager.keyreleased(key, scancode)
end

function love.mousepressed(x, y, button, istouch)
    Input.mousepressed(x, y, button, istouch)
    SceneManager.mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
    Input.mousereleased(x, y, button, istouch)
    SceneManager.mousereleased(x, y, button, istouch)
end

function love.mousemoved(x, y, dx, dy, istouch)
    Input.mousemoved(x, y, dx, dy, istouch)
    SceneManager.mousemoved(x, y, dx, dy, istouch)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    Input.touchpressed(id, x, y, dx, dy, pressure)
    SceneManager.touchpressed(id, x, y, dx, dy, pressure)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    Input.touchreleased(id, x, y, dx, dy, pressure)
    SceneManager.touchreleased(id, x, y, dx, dy, pressure)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    Input.touchmoved(id, x, y, dx, dy, pressure)
    SceneManager.touchmoved(id, x, y, dx, dy, pressure)
end

function love.resize(w, h)
end
