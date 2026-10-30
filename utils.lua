Color = {}

local function hex(x)
    return tonumber("0x"..x)
end

function Color.hex(x)
    x = x:gsub("#", "")
    return {hex(x:sub(1, 2))/255, hex(x:sub(3, 4))/255, hex(x:sub(5, 6))/255}
end

function Color.alpha(rgb, a)
    return {rgb[1], rgb[2], rgb[3], a}
end

function Color.hex_alpha(x, a)
    return Color.alpha(Color.hex(x), a)
end

function Color.reset()
    love.graphics.setColor(1, 1, 1, 1)
end

function math.dist(a, b)
    local ax = a.x+a.w/2
    local ay = a.y+a.h/2
    local bx = b.x+b.w/2
    local by = b.y+b.h/2
    return math.sqrt((ax-bx)^2+(ay-by)^2)
end

function math.sign(x)
    if x > 0 then
        return 1
    elseif x < 0 then
        return -1
    end
    return 0
end

function math.round_s(x, r, ofs)
    return math.round(x, r, ofs)*r
end

function math.round(x, r, ofs)
    r = r or 1
    ofs = ofs or 0.5
    return math.floor(x/r+ofs)
end

function math.clamp(x, min, max)
    return math.max(min, math.min(max, x))
end

function AABB(a, b)
    return a.x < b.x+b.w and
           b.x < a.x+a.w and
           a.y < b.y+b.h and
           b.y < a.y+a.h
end

function SinEffect(t)
    t = t or 4
    return math.sin(love.timer.getTime()*t)
end

function Damp(dt, damp)
    return 1-math.exp(-damp * dt)
end

Ease = {}

function Ease.out(x, p)
    p = p or 2
    return 1-(1-x)^p
end

function Ease.out_elastic(x)
    local c4 = (2*math.pi)/3
    if x == 0 then
        return 0
    elseif x == 1 then
        return 1
    else
        return math.pow(2, -10*x)*math.sin((x*10-0.75)*c4)+1
    end
end

function RandomPitch()
    return math.random(8, 12)/10
end

function RandomRange(t)
    return math.random(unpack(t))
end

function Copy(a, b)
    for k, v in pairs(a) do
        b[k] = v
    end
end

function ToDict(t)
    local d = {}
    for _, v in ipairs(t) do
        d[v] = true
    end
    return d
end

function FileExists(path)
    local info = love.filesystem.getInfo(path)
    if info == nil then
        Log(path.." does not exist")
    end
    return info
end
