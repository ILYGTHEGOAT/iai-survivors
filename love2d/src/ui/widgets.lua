local H = require("src.utils.helpers")
local Input = require("src.core.input")

local Widgets = {}

Widgets.fonts = {
    title = nil,
    large = nil,
    medium = nil,
    small = nil,
    tiny = nil,
}

function Widgets.init()
    Widgets.fonts.title = love.graphics.newFont(42)
    Widgets.fonts.large = love.graphics.newFont(28)
    Widgets.fonts.medium = love.graphics.newFont(20)
    Widgets.fonts.small = love.graphics.newFont(16)
    Widgets.fonts.tiny = love.graphics.newFont(12)
end

function Widgets.drawButton(x, y, w, h, text, opts)
    opts = opts or {}
    local hovered = Input.isMouseInRect(x, y, w, h)
    local pressed = hovered and (love.mouse.isDown(1) or Input.isTouchedInRect(x, y, w, h))
    local color = opts.color or { r = 0.2, g = 0.6, b = 0.9 }
    local textColor = opts.textColor or { r = 1, g = 1, b = 1 }
    local font = opts.font or Widgets.fonts.medium

    if opts.disabled then
        color = { r = 0.3, g = 0.3, b = 0.3 }
    elseif pressed then
        color = { r = color.r * 0.7, g = color.g * 0.7, b = color.b * 0.7 }
    elseif hovered then
        color = { r = color.r * 1.2, g = color.g * 1.2, b = color.b * 1.2 }
    end

    love.graphics.setColor(color.r, color.g, color.b, opts.alpha or 0.9)
    H.drawRoundRect(x, y, w, h, 6)

    if pressed and not opts.disabled then
        love.graphics.setColor(color.r * 0.5, color.g * 0.5, color.b * 0.5, 0.3)
        H.drawRoundRect(x, y, w, h, 6)
    end

    love.graphics.setColor(0, 0, 0, 0.3)
    H.drawRoundRect(x + 2, y + 2, w, h, 6)

    love.graphics.setColor(textColor.r, textColor.g, textColor.b, opts.alpha or 1)
    love.graphics.setFont(font)
    local tw = font:getWidth(text)
    local th = font:getHeight()
    love.graphics.print(text, x + (w - tw) / 2, y + (h - th) / 2)

    love.graphics.setColor(1, 1, 1, 1)
    return hovered and not opts.disabled
end

function Widgets.drawButtonClicked(x, y, w, h, text, opts)
    local clicked = Widgets.drawButton(x, y, w, h, text, opts)
    return clicked and Input.isClickInRect(x, y, w, h)
end

function Widgets.drawPanel(x, y, w, h, opts)
    opts = opts or {}
    local bgColor = opts.bgColor or { r = 0.1, g = 0.1, b = 0.15 }
    local borderColor = opts.borderColor or { r = 0.3, g = 0.3, b = 0.5 }
    local alpha = opts.alpha or 0.85

    love.graphics.setColor(0, 0, 0, 0.4)
    H.drawRoundRect(x + 3, y + 3, w, h, 8)
    love.graphics.setColor(bgColor.r, bgColor.g, bgColor.b, alpha)
    H.drawRoundRect(x, y, w, h, 8)
    love.graphics.setColor(borderColor.r, borderColor.g, borderColor.b, 0.6)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", x, y, w, h, 8, 8)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1, 1)
end

function Widgets.drawHpBar(x, y, w, h, current, max, opts)
    opts = opts or {}
    local barColor = opts.color or { r = 0.2, g = 0.8, b = 0.2 }
    local bgColor = opts.bgColor or { r = 0.15, g = 0.15, b = 0.15 }
    local pct = max > 0 and current / max or 0

    if pct < 0.3 then barColor = { r = 0.9, g = 0.2, b = 0.2 }
    elseif pct < 0.6 then barColor = { r = 0.9, g = 0.7, b = 0.1 }
    end

    love.graphics.setColor(bgColor.r, bgColor.g, bgColor.b, 0.8)
    love.graphics.rectangle("fill", x, y, w, h, 3, 3)
    love.graphics.setColor(barColor.r, barColor.g, barColor.b, 0.9)
    love.graphics.rectangle("fill", x + 1, y + 1, (w - 2) * pct, h - 2, 3, 3)

    if opts.showText then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(Widgets.fonts.tiny)
        love.graphics.print(math.floor(current) .. "/" .. math.floor(max), x + 4, y + 1)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function Widgets.drawMpBar(x, y, w, h, current, max, opts)
    Widgets.drawHpBar(x, y, w, h, current, max, H.shallowCopy(opts or {}, {
        color = { r = 0.3, g = 0.4, b = 0.9 }
    }))
end

function Widgets.drawTextWithShadow(text, font, x, y, color, shadowColor)
    shadowColor = shadowColor or { r = 0, g = 0, b = 0 }
    love.graphics.setFont(font)
    love.graphics.setColor(shadowColor.r, shadowColor.g, shadowColor.b, 0.5)
    love.graphics.print(text, x + 2, y + 2)
    love.graphics.setColor(color.r, color.g, color.b, 1)
    love.graphics.print(text, x, y)
    love.graphics.setColor(1, 1, 1, 1)
end

function Widgets.drawDialogBox(x, y, w, h, speaker, text, opts)
    opts = opts or {}
    Widgets.drawPanel(x, y, w, h, { bgColor = { r = 0.05, g = 0.05, b = 0.12 } })

    if speaker and speaker ~= "narrator" then
        local speakerColor = opts.speakerColor or { r = 0.3, g = 0.8, b = 1 }
        Widgets.drawTextWithShadow(speaker, Widgets.fonts.small, x + 15, y + 10, speakerColor)
    end

    local textColor = opts.textColor or { r = 0.9, g = 0.9, b = 0.9 }
    local lines = H.wrapText(text, Widgets.fonts.medium, w - 30)
    local textY = speaker and speaker ~= "narrator" and (y + 30) or (y + 15)
    for i, line in ipairs(lines) do
        if textY + i * 24 > y + h - 10 then break end
        love.graphics.setColor(textColor.r, textColor.g, textColor.b, 1)
        love.graphics.setFont(Widgets.fonts.medium)
        love.graphics.print(line, x + 15, textY + (i - 1) * 24)
    end

    if opts.showContinue then
        local pulse = (math.sin(love.timer.getTime() * 4) + 1) / 2
        love.graphics.setColor(1, 1, 1, 0.5 + pulse * 0.5)
        love.graphics.setFont(Widgets.fonts.tiny)
        love.graphics.print("▼ Continuer", x + w - 100, y + h - 20)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function Widgets.drawChoiceBox(x, y, w, h, choices, selectedIndex, opts)
    opts = opts or {}
    Widgets.drawPanel(x, y, w, h, { bgColor = { r = 0.05, g = 0.05, b = 0.15 } })

    local choiceH = 40
    local padding = 8
    for i, choice in ipairs(choices) do
        local cy = y + padding + (i - 1) * (choiceH + 5)
        local isSelected = (selectedIndex == i)
        local isHovered = Input.isMouseInRect(x + 10, cy, w - 20, choiceH)

        if isSelected or isHovered then
            love.graphics.setColor(0.2, 0.5, 0.8, 0.4)
            H.drawRoundRect(x + 10, cy, w - 20, choiceH, 4)
        end

        love.graphics.setColor(isSelected and 1 or 0.8, isSelected and 1 or 0.8, isSelected and 1 or 0.8, 1)
        love.graphics.setFont(Widgets.fonts.small)
        local lines = H.wrapText(choice.text or choice, Widgets.fonts.small, w - 40)
        for li, line in ipairs(lines) do
            love.graphics.print(line, x + 20, cy + 5 + (li - 1) * 16)
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function Widgets.drawStatBar(x, y, w, h, label, value, maxValue, color)
    love.graphics.setFont(Widgets.fonts.tiny)
    love.graphics.setColor(0.7, 0.7, 0.7, 1)
    love.graphics.print(label, x, y)
    local barY = y + 14
    love.graphics.setColor(0.15, 0.15, 0.2, 0.8)
    love.graphics.rectangle("fill", x, barY, w, h - 14, 2)
    love.graphics.setColor(color.r, color.g, color.b, 0.9)
    local pct = maxValue > 0 and value / maxValue or 0
    love.graphics.rectangle("fill", x, barY, w * pct, h - 14, 2)
    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.print(tostring(math.floor(value)) .. "/" .. tostring(maxValue), x + w + 5, y)
    love.graphics.setColor(1, 1, 1, 1)
end

function Widgets.drawTooltip(x, y, text, opts)
    opts = opts or {}
    local font = opts.font or Widgets.fonts.small
    local lines = H.wrapText(text, font, 200)
    local h = #lines * 18 + 16
    local w = 220

    if x + w > 1280 then x = 1280 - w end
    if y + h > 720 then y = 720 - h end

    Widgets.drawPanel(x, y, w, h, {
        bgColor = { r = 0.08, g = 0.08, b = 0.12 },
        borderColor = { r = 0.4, g = 0.4, b = 0.6 },
    })

    for i, line in ipairs(lines) do
        love.graphics.setColor(0.9, 0.9, 0.85, 1)
        love.graphics.setFont(font)
        love.graphics.print(line, x + 8, y + 8 + (i - 1) * 18)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function Widgets.drawNotification(text, type, alpha, y)
    local colors = {
        info = { r = 0.2, g = 0.6, b = 1 },
        warning = { r = 1, g = 0.7, b = 0.1 },
        error = { r = 1, g = 0.2, b = 0.2 },
        levelup = { r = 0.3, g = 1, b = 0.3 },
        success = { r = 0.2, g = 0.8, b = 0.3 },
    }
    local color = colors[type] or colors.info

    local w = Widgets.fonts.medium:getWidth(text) + 30
    local x = (1280 - w) / 2
    y = y or 80

    love.graphics.setColor(0, 0, 0, 0.7 * alpha)
    H.drawRoundRect(x, y, w, 36, 8)
    love.graphics.setColor(color.r, color.g, color.b, 0.8 * alpha)
    H.drawRoundRect(x, y, w, 36, 8)
    love.graphics.setColor(1, 1, 1, alpha)
    love.graphics.setFont(Widgets.fonts.small)
    love.graphics.print(text, x + 15, y + 9)
    love.graphics.setColor(1, 1, 1, 1)
end

function Widgets.drawWeekHeader(week, title, act)
    local actColors = {
        [1] = { r = 0.3, g = 0.8, b = 0.3, label = "ACTE I — Découverte" },
        [2] = { r = 1, g = 0.7, b = 0.1, label = "ACTE II — Pression" },
        [3] = { r = 0.9, g = 0.2, b = 0.3, label = "ACTE III — Confrontation" },
    }
    local actInfo = actColors[act] or actColors[1]

    Widgets.drawPanel(0, 0, 1280, 60, {
        bgColor = { r = 0.05, g = 0.05, b = 0.1 },
        borderColor = actInfo,
    })

    love.graphics.setColor(actInfo.r, actInfo.g, actInfo.b, 0.9)
    love.graphics.setFont(Widgets.fonts.tiny)
    love.graphics.print(actInfo.label, 15, 8)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(Widgets.fonts.large)
    love.graphics.print("SEM. " .. week .. " — " .. title, 15, 28)
    love.graphics.setColor(1, 1, 1, 1)
end

return Widgets
