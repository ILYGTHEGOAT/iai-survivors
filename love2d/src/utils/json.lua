local json = {}

function json.encode(val)
    local t = type(val)
    if t == "nil" then return "null"
    elseif t == "boolean" then return val and "true" or "false"
    elseif t == "number" then return tostring(val)
    elseif t == "string" then
        return '"' .. val:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('\n', '\\n'):gsub('\r', '\\r'):gsub('\t', '\\t') .. '"'
    elseif t == "table" then
        local isArray = #val > 0
        local parts = {}
        if isArray then
            for i, v in ipairs(val) do
                parts[#parts + 1] = json.encode(v)
            end
            return "[" .. table.concat(parts, ",") .. "]"
        else
            for k, v in pairs(val) do
                parts[#parts + 1] = json.encode(tostring(k)) .. ":" .. json.encode(v)
            end
            return "{" .. table.concat(parts, ",") .. "}"
        end
    end
    return "null"
end

function json.decode(str)
    local pos = 1

    local function skipWhitespace()
        pos = str:find("[^ \t\n\r]", pos) or (#str + 1)
    end

    local function peek()
        skipWhitespace()
        return str:sub(pos, pos)
    end

    local function advance()
        pos = pos + 1
    end

    local function parseValue()
        skipWhitespace()
        local c = str:sub(pos, pos)
        if c == '"' then return parseString()
        elseif c == '{' then return parseObject()
        elseif c == '[' then return parseArray()
        elseif c == 't' then pos = pos + 4; return true
        elseif c == 'f' then pos = pos + 5; return false
        elseif c == 'n' then pos = pos + 4; return nil
        else return parseNumber()
        end
    end

    local function parseString()
        advance()
        local start = pos
        local result = {}
        while pos <= #str do
            local c = str:sub(pos, pos)
            if c == '"' then
                pos = pos + 1
                return str:sub(start, pos - 2):gsub('\\n', '\n'):gsub('\\r', '\r'):gsub('\\t', '\t'):gsub('\\"', '"'):gsub('\\\\', '\\')
            elseif c == '\\' then
                pos = pos + 1
                local esc = str:sub(pos, pos)
                if esc == 'n' then result[#result + 1] = '\n'
                elseif esc == 'r' then result[#result + 1] = '\r'
                elseif esc == 't' then result[#result + 1] = '\t'
                else result[#result + 1] = esc
                end
            else
                result[#result + 1] = c
            end
            pos = pos + 1
        end
        return table.concat(result)
    end

    local function parseNumber()
        local start = pos
        if str:sub(pos, pos) == '-' then pos = pos + 1 end
        while pos <= #str and str:sub(pos, pos):match("[%d%.eE%+%-]") do
            pos = pos + 1
        end
        return tonumber(str:sub(start, pos - 1))
    end

    local function parseArray()
        advance()
        local arr = {}
        skipWhitespace()
        if str:sub(pos, pos) == ']' then advance(); return arr end
        while true do
            arr[#arr + 1] = parseValue()
            skipWhitespace()
            if str:sub(pos, pos) == ',' then advance()
            elseif str:sub(pos, pos) == ']' then advance(); return arr
            end
        end
    end

    local function parseObject()
        advance()
        local obj = {}
        skipWhitespace()
        if str:sub(pos, pos) == '}' then advance(); return obj end
        while true do
            skipWhitespace()
            local key = parseString()
            skipWhitespace()
            advance()
            obj[key] = parseValue()
            skipWhitespace()
            if str:sub(pos, pos) == ',' then advance()
            elseif str:sub(pos, pos) == '}' then advance(); return obj
            end
        end
    end

    return parseValue()
end

return json
