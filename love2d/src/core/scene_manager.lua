local SceneManager = {
    scenes = {},
    current = nil,
    currentName = nil,
    transition = nil,
    pendingScene = nil,
    pendingData = nil,
    stack = {}
}

function SceneManager.register(name, scene)
    SceneManager.scenes[name] = scene
end

function SceneManager.switchTo(name, data)
    if SceneManager.transition then return end
    SceneManager.pendingScene = name
    SceneManager.pendingData = data
    SceneManager.transition = {
        type = "out",
        elapsed = 0,
        duration = 0.3,
        alpha = 0
    }
end

function SceneManager.push(name, data)
    if SceneManager.current then
        SceneManager.stack[#SceneManager.stack + 1] = {
            name = SceneManager.currentName,
            data = SceneManager.current._stackData
        }
    end
    SceneManager.switchTo(name, data)
end

function SceneManager.pop(data)
    if #SceneManager.stack > 0 then
        local frame = table.remove(SceneManager.stack)
        SceneManager.switchTo(frame.name, frame.data or data)
    end
end

function SceneManager.goTo(name, data)
    SceneManager.stack = {}
    SceneManager.switchTo(name, data)
end

function SceneManager._doSwitch()
    local name = SceneManager.pendingScene
    local data = SceneManager.pendingData
    SceneManager.pendingScene = nil
    SceneManager.pendingData = nil

    if SceneManager.current and SceneManager.current.exit then
        SceneManager.current.exit()
    end

    SceneManager.currentName = name
    SceneManager.current = SceneManager.scenes[name]

    if SceneManager.current and SceneManager.current.enter then
        SceneManager.current.enter(data)
    end

    SceneManager.transition = {
        type = "in",
        elapsed = 0,
        duration = 0.3,
        alpha = 1
    }
end

function SceneManager.update(dt)
    if SceneManager.transition then
        SceneManager.transition.elapsed = SceneManager.transition.elapsed + dt
        local p = math.min(SceneManager.transition.elapsed / SceneManager.transition.duration, 1)

        if SceneManager.transition.type == "out" then
            SceneManager.transition.alpha = p
            if p >= 1 then
                SceneManager._doSwitch()
            end
        elseif SceneManager.transition.type == "in" then
            SceneManager.transition.alpha = 1 - p
            if p >= 1 then
                SceneManager.transition = nil
            end
        end
    end

    if SceneManager.current and SceneManager.current.update then
        SceneManager.current.update(dt)
    end
end

function SceneManager.draw()
    if SceneManager.current and SceneManager.current.draw then
        SceneManager.current.draw()
    end

    if SceneManager.transition then
        love.graphics.setColor(0, 0, 0, SceneManager.transition.alpha)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function SceneManager.keypressed(key, scancode, isrepeat)
    if SceneManager.current and SceneManager.current.keypressed then
        SceneManager.current.keypressed(key, scancode, isrepeat)
    end
end

function SceneManager.keyreleased(key, scancode)
    if SceneManager.current and SceneManager.current.keyreleased then
        SceneManager.current.keyreleased(key, scancode)
    end
end

function SceneManager.mousepressed(x, y, button, istouch)
    if SceneManager.current and SceneManager.current.mousepressed then
        SceneManager.current.mousepressed(x, y, button, istouch)
    end
end

function SceneManager.mousereleased(x, y, button, istouch)
    if SceneManager.current and SceneManager.current.mousereleased then
        SceneManager.current.mousereleased(x, y, button, istouch)
    end
end

function SceneManager.mousemoved(x, y, dx, dy, istouch)
    if SceneManager.current and SceneManager.current.mousemoved then
        SceneManager.current.mousemoved(x, y, dx, dy, istouch)
    end
end

function SceneManager.touchpressed(id, x, y, dx, dy, pressure)
    if SceneManager.current and SceneManager.current.touchpressed then
        SceneManager.current.touchpressed(id, x, y, dx, dy, pressure)
    end
end

function SceneManager.touchreleased(id, x, y, dx, dy, pressure)
    if SceneManager.current and SceneManager.current.touchreleased then
        SceneManager.current.touchreleased(id, x, y, dx, dy, pressure)
    end
end

function SceneManager.touchmoved(id, x, y, dx, dy, pressure)
    if SceneManager.current and SceneManager.current.touchmoved then
        SceneManager.current.touchmoved(id, x, y, dx, dy, pressure)
    end
end

return SceneManager
