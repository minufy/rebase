function rgb(r, g, b)
    return {r/255, g/255, b/255}
end

function rgba(r, g, b, a)
    return {r/255, g/255, b/255, a}
end

Color = {}

function Color.alpha(rgb, a)
    return {rgb[1], rgb[2], rgb[3], a}
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

function EaseOut(x)
    return 1-(1-x)^2
end

function EaseOutElastic(x)
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

function SetType(Object, type)
    function Object:__tostring()
        return type
    end
end

Align = {}

function Align.Bottom(self, dir, no_flip)
    self.draw_x, self.draw_y = 0, 0
    dir = dir or 0
    if no_flip == nil and dir%2 == 1 then
        self.w, self.h = self.h, self.w
    end
    if dir == 0 then
        self.y = self.y+TILE_SIZE*math.ceil(self.h/TILE_SIZE)-self.h
        self.x = self.x+TILE_SIZE/2-self.w/2
    elseif dir == 1 then
        self.draw_x = self.w
        self.y = self.y+TILE_SIZE/2-self.h/2
    elseif dir == 2 then
        self.draw_y = self.h
        self.draw_x = self.w
        self.x = self.x+TILE_SIZE/2-self.w/2
    elseif dir == 3 then
        self.x = self.x+TILE_SIZE*math.ceil(self.w/TILE_SIZE)-self.w
        self.draw_y = self.h
        self.y = self.y+TILE_SIZE/2-self.h/2
    end
    return self
end

function Align.Center(self, _, _)
    self.draw_x, self.draw_y = 0, 0
    self.x = self.x+TILE_SIZE/2-self.w/2
    self.y = self.y+TILE_SIZE/2-self.h/2
    return self
end

function Align.None(self, _, _)
    self.draw_x, self.draw_y = 0, 0
    return self
end

function Copy(a, b)
    for k, v in pairs(a) do
        b[k] = v
    end
end

function ToDict(t)
    local d = {}
    for i, v in ipairs(t) do
        d[v] = true
    end
    return d
end