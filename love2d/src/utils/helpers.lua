local Helpers = {}

function Helpers.clamp(v, lo, hi)
    return math.max(lo, math.min(hi, v))
end

function Helpers.lerp(a, b, t)
    return a + (b - a) * t
end

function Helpers.lerpColor(c1, c2, t)
    return {
        r = Helpers.lerp(c1.r, c2.r, t),
        g = Helpers.lerp(c1.g, c2.g, t),
        b = Helpers.lerp(c1.b, c2.b, t),
        a = Helpers.lerp(c1.a or 1, c2.a or 1, t)
    }
end

function Helpers.hex(h)
    h = h:gsub("#", "")
    return {
        r = tonumber(h:sub(1, 2), 16) / 255,
        g = tonumber(h:sub(3, 4), 16) / 255,
        b = tonumber(h:sub(5, 6), 16) / 255,
        a = 1
    }
end

function Helpers.rgb(r, g, b, a)
    return { r = r / 255, g = g / 255, b = b / 255, a = a or 1 }
end

function Helpers.setColor(c, override_a)
    love.graphics.setColor(c.r, c.g, c.b, override_a or c.a or 1)
end

function Helpers.tween(opts)
    local t = {
        value = opts.from,
        from = opts.from,
        to = opts.to,
        duration = opts.duration or 1,
        elapsed = 0,
        easing = opts.easing or "linear",
        onUpdate = opts.onUpdate,
        onComplete = opts.onComplete,
        done = false
    }
    function t:update(dt)
        if self.done then return end
        self.elapsed = self.elapsed + dt
        local p = Helpers.clamp(self.elapsed / self.duration, 0, 1)
        local ep = Helpers.ease(p, self.easing)
        self.value = Helpers.lerp(self.from, self.to, ep)
        if self.onUpdate then self.onUpdate(self.value) end
        if p >= 1 then
            self.done = true
            if self.onComplete then self.onComplete() end
        end
    end
    function t:reset()
        self.elapsed = 0
        self.done = false
        self.value = self.from
    end
    return t
end

function Helpers.ease(t, style)
    if style == "inQuad" then return t * t
    elseif style == "outQuad" then return t * (2 - t)
    elseif style == "inOutQuad" then
        return t < 0.5 and 2 * t * t or -1 + (4 - 2 * t) * t
    elseif style == "outBack" then
        local c = 1.70158
        return 1 + (c + 1) * math.pow(t - 1, 3) + c * math.pow(t - 1, 2)
    elseif style == "outElastic" then
        if t == 0 or t == 1 then return t end
        return math.pow(2, -10 * t) * math.sin((t - 0.1) * 5 * math.pi) + 1
    elseif style == "outBounce" then
        if t < 1/2.75 then return 7.5625 * t * t
        elseif t < 2/2.75 then t = t - 1.5/2.75; return 7.5625 * t * t + 0.75
        elseif t < 2.5/2.75 then t = t - 2.25/2.75; return 7.5625 * t * t + 0.9375
        else t = t - 2.625/2.75; return 7.5625 * t * t + 0.984375
        end
    end
    return t
end

function Helpers.shallowCopy(t)
    local out = {}
    for k, v in pairs(t) do out[k] = v end
    return out
end

function Helpers.deepCopy(t)
    if type(t) ~= "table" then return t end
    local out = {}
    for k, v in pairs(t) do
        out[Helpers.deepCopy(k)] = Helpers.deepCopy(v)
    end
    return setmetatable(out, getmetatable(t))
end

function Helpers.weightedRandom(weights)
    local total = 0
    for _, w in pairs(weights) do total = total + w end
    local r = math.random() * total
    local acc = 0
    for k, w in pairs(weights) do
        acc = acc + w
        if r <= acc then return k end
    end
end

function Helpers.tableSize(t)
    local n = 0
    for _ in pairs(t) do n = n + 1 end
    return n
end

function Helpers.tableKeys(t)
    local keys = {}
    for k in pairs(t) do keys[#keys + 1] = k end
    return keys
end

function Helpers.tableFind(t, v)
    for i, val in ipairs(t) do
        if val == v then return i end
    end
    return nil
end

function Helpers.tableRemove(t, v)
    local i = Helpers.tableFind(t, v)
    if i then table.remove(t, i) end
end

function Helpers.shuffle(t)
    local out = Helpers.shallowCopy(t)
    for i = #out, 2, -1 do
        local j = math.random(1, i)
        out[i], out[j] = out[j], out[i]
    end
    return out
end

function Helpers.wrapText(text, font, maxWidth)
    local lines = {}
    local words = {}
    for word in text:gmatch("%S+") do
        words[#words + 1] = word
    end
    local currentLine = ""
    for _, word in ipairs(words) do
        local testLine = currentLine == "" and word or (currentLine .. " " .. word)
        if font:getWidth(testLine) > maxWidth and currentLine ~= "" then
            lines[#lines + 1] = currentLine
            currentLine = word
        else
            currentLine = testLine
        end
    end
    if currentLine ~= "" then lines[#lines + 1] = currentLine end
    return lines
end

function Helpers.drawRoundRect(x, y, w, h, r, segments)
    segments = segments or 8
    local pts = {}
    for i = 0, segments do
        local a = math.pi + math.pi / 2 * (i / segments)
        pts[#pts + 1] = x + r + math.cos(a) * r
        pts[#pts + 1] = y + r + math.sin(a) * r
    end
    for i = 0, segments do
        local a = -math.pi / 2 + math.pi / 2 * (i / segments)
        pts[#pts + 1] = x + w - r + math.cos(a) * r
        pts[#pts + 1] = y + r + math.sin(a) * r
    end
    for i = 0, segments do
        local a = 0 + math.pi / 2 * (i / segments)
        pts[#pts + 1] = x + w - r + math.cos(a) * r
        pts[#pts + 1] = y + h - r + math.sin(a) * r
    end
    for i = 0, segments do
        local a = math.pi / 2 + math.pi / 2 * (i / segments)
        pts[#pts + 1] = x + r + math.cos(a) * r
        pts[#pts + 1] = y + h - r + math.sin(a) * r
    end
    love.graphics.polygon("fill", pts)
end

function Helpers.drawTextShadow(text, font, x, y, shadowOff, color)
    local so = shadowOff or 2
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.setFont(font)
    love.graphics.print(text, x + so, y + so)
    Helpers.setColor(color or {r=1,g=1,b=1,a=1})
    love.graphics.print(text, x, y)
end

function Helpers.drawGlow(x, y, radius, color, alpha)
    love.graphics.setColor(color.r, color.g, color.b, (alpha or 0.3))
    love.graphics.setBlendMode("add")
    love.graphics.circle("fill", x, y, radius)
    love.graphics.circle("fill", x, y, radius * 0.7)
    love.graphics.circle("fill", x, y, radius * 0.4)
    love.graphics.setBlendMode("alpha")
end

function Helpers.formatNumber(n)
    if n >= 1000000 then return string.format("%.1fM", n / 1000000)
    elseif n >= 1000 then return string.format("%.1fK", n / 1000)
    else return tostring(math.floor(n))
    end
end

function Helpers.sign(x)
    if x > 0 then return 1 elseif x < 0 then return -1 else return 0 end
end

function Helpers.distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function Helpers.angle(x1, y1, x2, y2)
    return math.atan2(y2 - y1, x2 - x1)
end

function Helpers.pointInRect(px, py, rx, ry, rw, rh)
    return px >= rx and px <= rx + rw and py >= ry and py <= ry + rh
end

function Helpers.pointInCircle(px, py, cx, cy, r)
    return Helpers.distance(px, py, cx, cy) <= r
end

function Helpers.randomFrom(t)
    return t[math.random(#t)]
end

function Helpers.splitString(s, sep)
    local parts = {}
    for part in s:gmatch("[^" .. sep .. "]+") do
        parts[#parts + 1] = part
    end
    return parts
end

return Helpers
