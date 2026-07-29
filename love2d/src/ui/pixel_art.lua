local H = require("src.utils.helpers")

local PixelArt = {}

PixelArt.characters = {
    not_a_genius = {
        width = 12, height = 16,
        pixels = {
            "............",
            "...HHHHHH...",
            "..HHHHHHHH..",
            "..HHSSSSHH..",
            "..HSSSSSSH..",
            "..HSGGSSGH..",
            "..SSSSSSSS..",
            "...SSSSSS...",
            "..CCCCCCCC..",
            ".CCCCCCCCCC.",
            ".CCCCcCCcCC.",
            "..CCCCCCCC..",
            "..SSCCCSS...",
            "..SS....SS..",
            "..BB....BB..",
            "..BB....BB..",
        },
        colors = {
            H = {0.15, 0.1, 0.1},
            S = {0.76, 0.6, 0.42},
            G = {0.7, 0.85, 1.0},
            C = {0.2, 0.25, 0.4},
            c = {0.3, 0.5, 0.8},
            B = {0.15, 0.15, 0.25},
        }
    },
    laurencium = {
        width = 14, height = 18,
        pixels = {
            "..............",
            "....HHHHHH....",
            "...HHHHHHHH...",
            "..HHHHHHHHHH..",
            "..HHSSSSSSHH..",
            "..HSSSSSSSSH..",
            "..SSSSSSSSSS..",
            "..SSFFSSFFSS..",
            "...SSSSSSSS...",
            "...SSMSSMSS...",
            "..RRRRRRRRRR..",
            ".RRRRRRRRRRR..",
            ".RRRRrRRRrRR..",
            "..RRRRRRRRR...",
            "..SS.RRRR.SS..",
            "..SS..SS..SS..",
            "..BB..SS..BB..",
            "..BB......BB..",
        },
        colors = {
            H = {0.1, 0.08, 0.06},
            S = {0.85, 0.72, 0.55},
            F = {0.1, 0.1, 0.15},
            M = {0.6, 0.45, 0.35},
            R = {0.8, 0.2, 0.3},
            r = {0.9, 0.3, 0.4},
            B = {0.2, 0.2, 0.3},
        }
    },
    king = {
        width = 12, height = 16,
        pixels = {
            "............",
            "...HHHHHH...",
            "..HHHHHHHH..",
            "..HHSSSSHH..",
            "..HSSSSSSH..",
            "..SSSSSSSS..",
            "..SSEESEES..",
            "...SSSSSS...",
            "..DDDDDDDD..",
            ".DDDDDDDDDD.",
            ".DDDDJDDDDD.",
            "..DDDDDDDD..",
            "..SSDDDDSS..",
            "..SS....SS..",
            "..BB....BB..",
            "..BB....BB..",
        },
        colors = {
            H = {0.2, 0.15, 0.1},
            S = {0.65, 0.5, 0.35},
            E = {0.8, 0.15, 0.15},
            D = {0.15, 0.15, 0.2},
            J = {0.9, 0.2, 0.4},
            B = {0.25, 0.2, 0.15},
        }
    },
    arsene = {
        width = 12, height = 16,
        pixels = {
            ".HH......HH.",
            ".HHH.HH.HHH.",
            "..HHHHHHHH...",
            "..HHSSSSHH...",
            "..HSSSSSSH...",
            "..SSSSSSSS...",
            "..SSSSSSSS...",
            "...SSSSSS....",
            "..NNNNNNNN...",
            ".NNNNNNNNNN..",
            ".NNNNnNNNNN..",
            "..NNNNNNNN...",
            "..SSNNNNSS...",
            "..SS....SS...",
            "..BB....BB...",
            "..BB....BB...",
        },
        colors = {
            H = {0.1, 0.08, 0.05},
            S = {0.55, 0.4, 0.3},
            N = {0.3, 0.35, 0.3},
            n = {0.25, 0.3, 0.25},
            B = {0.2, 0.18, 0.15},
        }
    },
    hemeryfb = {
        width = 12, height = 16,
        pixels = {
            "............",
            "...HHHHHH...",
            "..HHHHHHHH..",
            "..HHSSSSHH..",
            "..HSSSSSSH..",
            "..SSSSSSSS..",
            "..SGGGSSGGSS..",
            "...SSSSSS...",
            "..TTTTTTTT..",
            ".TTTTTTTTTT.",
            ".TTTTtTTTTT.",
            "..TTTTTTTT..",
            "..SSTTTTSS..",
            "..SS....SS..",
            "..BB....BB..",
            "..BB....BB..",
        },
        colors = {
            H = {0.05, 0.05, 0.15},
            S = {0.7, 0.55, 0.4},
            G = {0.7, 0.9, 0.3},
            T = {0.25, 0.05, 0.35},
            t = {0.4, 0.1, 0.5},
            B = {0.15, 0.1, 0.2},
        }
    },
}

PixelArt.enemies = {
    bug_small = {
        width = 8, height = 8,
        pixels = {
            "..RR....",
            ".RRRR...",
            "RRRRRR..",
            "RWRWRW..",
            "RRRRRR..",
            ".RRRR...",
            "..RRRR..",
            "...RR...",
        },
        colors = {R = {0.8, 0.2, 0.2}, W = {1, 1, 1}}
    },
    goblin = {
        width = 10, height = 12,
        pixels = {
            "...GGGG...",
            "..GGGGGG..",
            ".GGGGGGG..",
            ".GYGGGYG..",
            ".GGGGGGG..",
            "..GGGGG...",
            ".BBBBBBB..",
            ".BBBBBBB..",
            "..BBBBB...",
            "..GG.GG...",
            "..GG.GG...",
            "..BB.BB...",
        },
        colors = {G = {0.4, 0.8, 0.3}, Y = {1, 1, 0.2}, B = {0.3, 0.3, 0.35}}
    },
    leak = {
        width = 8, height = 10,
        pixels = {
            "..PP....",
            ".PPPP...",
            "PPPPPP..",
            "PPWPWP..",
            "PPPPPP..",
            ".PPPP...",
            "..PPPP..",
            ".PP..PP.",
            ".PP..PP.",
            "..PPPP..",
        },
        colors = {P = {0.5, 0.3, 0.8}, W = {0.8, 0.8, 1}}
    },
    boss_algorithm = {
        width = 16, height = 20,
        pixels = {
            "....RRRRRRRR....",
            "...RRRRRRRRRR...",
            "..RRRRRRRRRRRR..",
            "..RRGRRRRRGRRR..",
            "..RRRRRRRRRRRR..",
            "..RRRRRRRRRRRR..",
            "...RRRRRRRRRR...",
            "..RRRRRRRRRRRR..",
            ".RRRRRRRRRRRRRR.",
            ".RRRWRRRRRWRRRR.",
            ".RRRRRRRRRRRRRR.",
            ".RRRRRRRRRRRRRR.",
            "..RRRRRRRRRRRR..",
            "..RRRRRRRRRRRR..",
            "..RRRR..RRRRRR..",
            "..RRRR..RRRRRR..",
            "..RRRR..RRRRRR..",
            "...RR....RRRR...",
            "...RR....RRRR...",
            "...RR....RRRR...",
        },
        colors = {R = {0.9, 0.1, 0.3}, G = {1, 1, 0.5}, W = {1, 1, 1}}
    },
    boss_final = {
        width = 18, height = 22,
        pixels = {
            "......PPPPPP......",
            ".....PPPPPPPP.....",
            "....PPPPPPPPPP....",
            "...PPPPPPPPPPPP...",
            "..PPPRPPPPPRPPP...",
            "..PPPPPPPPPPPPP...",
            "..PPPPPPPPPPPPP...",
            "...PPPPPPPPPPP....",
            "..PPPPPPPPPPPPPP..",
            ".PPPPPPPPPPPPPPP..",
            ".PPRWPPPPPPPRWPP..",
            ".PPPPPPPPPPPPPPP..",
            ".PPPPPPPPPPPPPPP..",
            "..PPPPPPPPPPPPP...",
            "..PPPPPPPPPPPPP...",
            "..PPPP..PPPPP....",
            "..PPPP..PPPPP....",
            "..PPPP..PPPPP....",
            "...PP....PPP.....",
            "...PP....PPP.....",
            "...PP....PPP.....",
            "...PP....PPP.....",
        },
        colors = {P = {0.7, 0.05, 0.9}, R = {1, 0.2, 0.2}, W = {1, 1, 1}}
    },
}

function PixelArt.drawCharacter(id, x, y, scale, flipX, tint)
    local data = PixelArt.characters[id]
    if not data then return end
    scale = scale or 3
    flipX = flipX or false

    local startX = x
    for rowIdx, row in ipairs(data.pixels) do
        local colIdx = 0
        for pixel in row:gmatch(".") do
            colIdx = colIdx + 1
            if pixel ~= "." then
                local color = data.colors[pixel]
                if color then
                    if tint then
                        love.graphics.setColor(
                            color[1] * tint[1],
                            color[2] * tint[2],
                            color[3] * tint[3],
                            tint[4] or 1
                        )
                    else
                        love.graphics.setColor(color[1], color[2], color[3], 1)
                    end
                    local px = flipX and (startX + (data.width - colIdx) * scale) or (startX + (colIdx - 1) * scale)
                    love.graphics.rectangle("fill", px, y + (rowIdx - 1) * scale, scale, scale)
                end
            end
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function PixelArt.drawEnemy(id, x, y, scale, tint)
    local data = PixelArt.enemies[id]
    if not data then
        love.graphics.setColor(0.8, 0.2, 0.2)
        love.graphics.rectangle("fill", x, y, 48, 48)
        love.graphics.setColor(1, 1, 1)
        return
    end
    scale = scale or 4

    for rowIdx, row in ipairs(data.pixels) do
        local colIdx = 0
        for pixel in row:gmatch(".") do
            colIdx = colIdx + 1
            if pixel ~= "." then
                local color = data.colors[pixel]
                if color then
                    if tint then
                        love.graphics.setColor(color[1] * tint[1], color[2] * tint[2], color[3] * tint[3], tint[4] or 1)
                    else
                        love.graphics.setColor(color[1], color[2], color[3], 1)
                    end
                    love.graphics.rectangle("fill", x + (colIdx - 1) * scale, y + (rowIdx - 1) * scale, scale, scale)
                end
            end
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function PixelArt.drawBackground(scene, width, height)
    if scene == "campus_day" then
        love.graphics.setColor(0.5, 0.75, 0.95)
        love.graphics.rectangle("fill", 0, 0, width, height)
        love.graphics.setColor(0.3, 0.6, 0.3)
        love.graphics.rectangle("fill", 0, height * 0.65, width, height * 0.35)
        love.graphics.setColor(0.7, 0.7, 0.7)
        love.graphics.rectangle("fill", width * 0.2, height * 0.15, width * 0.6, height * 0.5)
        love.graphics.setColor(0.2, 0.2, 0.25)
        for i = 0, 5 do
            local wx = width * 0.22 + i * (width * 0.09)
            love.graphics.rectangle("fill", wx, height * 0.2, width * 0.06, height * 0.15)
            love.graphics.setColor(0.5, 0.8, 1)
            love.graphics.rectangle("fill", wx + 2, height * 0.2 + 2, width * 0.06 - 4, height * 0.15 - 4)
            love.graphics.setColor(0.2, 0.2, 0.25)
        end
        love.graphics.setColor(0.6, 0.6, 0.6)
        love.graphics.rectangle("fill", width * 0.45, height * 0.5, width * 0.1, height * 0.15)
    elseif scene == "campus_night" then
        love.graphics.setColor(0.08, 0.08, 0.2)
        love.graphics.rectangle("fill", 0, 0, width, height)
        love.graphics.setColor(0.15, 0.15, 0.3)
        love.graphics.rectangle("fill", 0, height * 0.65, width, height * 0.35)
        love.graphics.setColor(0.15, 0.15, 0.2)
        love.graphics.rectangle("fill", width * 0.2, height * 0.15, width * 0.6, height * 0.5)
        for i = 0, 5 do
            local wx = width * 0.22 + i * (width * 0.09)
            love.graphics.setColor(0.9, 0.8, 0.3, 0.6)
            love.graphics.rectangle("fill", wx + 2, height * 0.2 + 2, width * 0.06 - 4, height * 0.15 - 4)
        end
        for i = 1, 15 do
            love.graphics.setColor(1, 1, 0.8, math.random() * 0.5 + 0.3)
            love.graphics.circle("fill", math.random(width), math.random(height * 0.5), 1)
        end
    elseif scene == "classroom" then
        love.graphics.setColor(0.85, 0.82, 0.75)
        love.graphics.rectangle("fill", 0, 0, width, height)
        love.graphics.setColor(0.6, 0.55, 0.5)
        love.graphics.rectangle("fill", 0, height * 0.1, width, height * 0.02)
        love.graphics.setColor(0.2, 0.2, 0.3)
        love.graphics.rectangle("fill", width * 0.1, height * 0.12, width * 0.8, height * 0.4)
        love.graphics.setColor(0.3, 0.35, 0.4)
        for i = 0, 3 do
            for j = 0, 2 do
                love.graphics.rectangle("fill",
                    width * 0.15 + i * width * 0.2,
                    height * 0.55 + j * height * 0.14,
                    width * 0.12, height * 0.1
                )
            end
        end
    elseif scene == "combat" then
        love.graphics.setColor(0.1, 0.1, 0.15)
        love.graphics.rectangle("fill", 0, 0, width, height)
        for i = 0, 20 do
            love.graphics.setColor(0.15, 0.15, 0.25, 0.3)
            love.graphics.rectangle("fill", 0, i * height / 20, width, 1)
        end
        love.graphics.setColor(0.05, 0.2, 0.1)
        love.graphics.rectangle("fill", 0, height * 0.7, width, height * 0.3)
    elseif scene == "dark_iai" then
        love.graphics.setColor(0.02, 0.02, 0.08)
        love.graphics.rectangle("fill", 0, 0, width, height)
        for i = 1, 50 do
            local alpha = math.random() * 0.3
            love.graphics.setColor(0, 1, 0.5, alpha)
            love.graphics.rectangle("fill", math.random(width), math.random(height), math.random(20, 80), 1)
        end
        love.graphics.setColor(0, 0.8, 0.3, 0.1)
        love.graphics.circle("fill", width / 2, height / 2, math.min(width, height) * 0.3)
    elseif scene == "labyrinth" then
        love.graphics.setColor(0.05, 0.02, 0.1)
        love.graphics.rectangle("fill", 0, 0, width, height)
        for i = 1, 30 do
            love.graphics.setColor(0.7, 0.1, 0.9, 0.15)
            local px = math.random(width)
            local py = math.random(height)
            love.graphics.rectangle("fill", px, py, math.random(5, 30), math.random(5, 30))
        end
        love.graphics.setColor(0.8, 0.2, 1, 0.2)
        love.graphics.rectangle("fill", width * 0.3, height * 0.3, width * 0.4, height * 0.4)
    elseif scene == "server_room" then
        love.graphics.setColor(0.05, 0.05, 0.1)
        love.graphics.rectangle("fill", 0, 0, width, height)
        for i = 0, 6 do
            local sx = width * 0.05 + i * width * 0.13
            love.graphics.setColor(0.15, 0.15, 0.2)
            love.graphics.rectangle("fill", sx, height * 0.1, width * 0.1, height * 0.7)
            for j = 0, 8 do
                love.graphics.setColor(math.random() > 0.5 and 0 or 0.2, math.random() > 0.3 and 0.8 or 0.1, 0.1, 0.8)
                love.graphics.rectangle("fill", sx + 4, height * 0.15 + j * height * 0.07, 4, 3)
            end
        end
    else
        love.graphics.setColor(0.15, 0.15, 0.2)
        love.graphics.rectangle("fill", 0, 0, width, height)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function PixelArt.getCharacterSize(id, scale)
    local data = PixelArt.characters[id]
    if not data then return 36, 48 end
    scale = scale or 3
    return data.width * scale, data.height * scale
end

function PixelArt.getEnemySize(id, scale)
    local data = PixelArt.enemies[id]
    if not data then return 48, 48 end
    scale = scale or 4
    return data.width * scale, data.height * scale
end

return PixelArt
