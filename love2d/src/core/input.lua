local Input = {
    keys = {},
    mouse = { x = 0, y = 0, pressed = {}, released = {} },
    touches = {},
    touchesThisFrame = {},
    keysThisFrame = {},
    mouseThisFrame = { pressed = {}, released = {} },
    touchAreas = {},
    scale = 1,
    offsetX = 0,
    offsetY = 0,
    gameWidth = 1280,
    gameHeight = 720,
}

function Input.update()
    Input.keysThisFrame = {}
    Input.mouseThisFrame = { pressed = {}, released = {} }
    Input.touchesThisFrame = {}

    local sw, sh = love.graphics.getDimensions()
    Input.scale = math.min(sw / Input.gameWidth, sh / Input.gameHeight)
    Input.offsetX = (sw - Input.gameWidth * Input.scale) / 2
    Input.offsetY = (sh - Input.gameHeight * Input.scale) / 2

    Input.mouse.x, Input.mouse.y = love.mouse.getPosition()
    Input.mouse.gameX = (Input.mouse.x - Input.offsetX) / Input.scale
    Input.mouse.gameY = (Input.mouse.y - Input.offsetY) / Input.scale
end

function Input.keypressed(key, scancode, isrepeat)
    Input.keys[key] = true
    Input.keysThisFrame[key] = true
end

function Input.keyreleased(key, scancode)
    Input.keys[key] = false
end

function Input.mousepressed(x, y, button, istouch)
    Input.mouse.pressed[button] = true
    Input.mouseThisFrame.pressed[button] = true
end

function Input.mousereleased(x, y, button, istouch)
    Input.mouse.pressed[button] = false
    Input.mouseThisFrame.released[button] = true
end

function Input.mousemoved(x, y, dx, dy, istouch)
end

function Input.touchpressed(id, x, y, dx, dy, pressure)
    Input.touches[id] = {
        x = x, y = y,
        startX = x, startY = y,
        dx = 0, dy = 0,
        pressed = true
    }
    Input.touchesThisFrame[id] = { x = x, y = y }
end

function Input.touchmoved(id, x, y, dx, dy, pressure)
    if Input.touches[id] then
        Input.touches[id].x = x
        Input.touches[id].y = y
        Input.touches[id].dx = x - Input.touches[id].startX
        Input.touches[id].dy = y - Input.touches[id].startY
    end
end

function Input.touchreleased(id, x, y, dx, dy, pressure)
    if Input.touches[id] then
        Input.touches[id].x = x
        Input.touches[id].y = y
        Input.touches[id].pressed = false
        Input.touches[id].releasedThisFrame = true
    end
end

function Input.isDown(key)
    return Input.keys[key] or false
end

function Input.isMouseInRect(rx, ry, rw, rh)
    local mx, my = Input.mouse.gameX, Input.mouse.gameY
    return mx >= rx and mx <= rx + rw and my >= ry and my <= ry + rh
end

function Input.isMouseInCircle(cx, cy, r)
    local mx, my = Input.mouse.gameX, Input.mouse.gameY
    return ((mx - cx)^2 + (my - cy)^2) <= r^2
end

function Input.isMousePressed(button)
    return Input.mouseThisFrame.pressed[button or 1] or false
end

function Input.isMouseReleased(button)
    return Input.mouseThisFrame.released[button or 1] or false
end

function Input.isKeyJustPressed(key)
    return Input.keysThisFrame[key] or false
end

function Input.getTouchInRect(rx, ry, rw, rh)
    for id, t in pairs(Input.touchesThisFrame) do
        local gx = (t.x - Input.offsetX) / Input.scale
        local gy = (t.y - Input.offsetY) / Input.scale
        if gx >= rx and gx <= rx + rw and gy >= ry and gy <= ry + rh then
            return id
        end
    end
    return nil
end

function Input.isTouchedInRect(rx, ry, rw, rh)
    for id, t in pairs(Input.touches) do
        if t.pressed then
            local gx = (t.x - Input.offsetX) / Input.scale
            local gy = (t.y - Input.offsetY) / Input.scale
            if gx >= rx and gx <= rx + rw and gy >= ry and gy <= ry + rh then
                return true
            end
        end
    end
    local mx, my = Input.mouse.gameX, Input.mouse.gameY
    if love.mouse.isDown(1) then
        return mx >= rx and mx <= rx + rw and my >= ry and my <= ry + rh
    end
    return false
end

function Input.isTouchReleasedInRect(rx, ry, rw, rh)
    for id, t in pairs(Input.touches) do
        if t.releasedThisFrame then
            local gx = (t.x - Input.offsetX) / Input.scale
            local gy = (t.y - Input.offsetY) / Input.scale
            if gx >= rx and gx <= rx + rw and gy >= ry and gy <= ry + rh then
                t.releasedThisFrame = false
                return true
            end
        end
    end
    if Input.mouseThisFrame.released[1] then
        local mx, my = Input.mouse.gameX, Input.mouse.gameY
        return mx >= rx and mx <= rx + rw and my >= ry and my <= ry + rh
    end
    return false
end

function Input.isClickInRect(rx, ry, rw, rh)
    if Input.isMousePressed(1) then
        return Input.isMouseInRect(rx, ry, rw, rh)
    end
    return Input.getTouchInRect(rx, ry, rw, rh) ~= nil
end

function Input.isJustPressedInRect(rx, ry, rw, rh)
    if Input.isKeyJustPressed("return") or Input.isKeyJustPressed("space") then
        return true
    end
    return Input.isClickInRect(rx, ry, rw, rh)
end

function Input.getGameCoords(x, y)
    return (x - Input.offsetX) / Input.scale, (y - Input.offsetY) / Input.scale
end

function Input.clear()
    Input.touchesThisFrame = {}
    for id, t in pairs(Input.touches) do
        if not t.pressed then
            Input.touches[id] = nil
        end
    end
end

return Input
