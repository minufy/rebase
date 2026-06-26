Res = {}

function Res:pass(cb)
    local x = Camera.x
    local y = Camera.y
    if not Camera.on then
        x = 0
        y = 0
    end
    table.insert(self.q, {cb = cb, x = x, y = y})
end

function Res:init(settings, shader)
    self.w = WINDOW_W
    self.h = WINDOW_H
    self.shift = {x = 0, y = 0}
    local w, h = love.graphics.getDimensions()
    self:resize(w, h)
    self.canvas = love.graphics.newCanvas(self.w, self.h, settings)
    self.q = {}
    self.shader = shader
end

function Res:before()
    if self.shader then
        love.graphics.setShader(self.shader)
    end
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
    self.q = {}
end

function Res:after()
    love.graphics.setCanvas()
    love.graphics.draw(self.canvas, self.shift.x, self.shift.y, 0, self.zoom, self.zoom)

    love.graphics.push()
    love.graphics.translate(self.shift.x, self.shift.y)
    love.graphics.scale(self.zoom, self.zoom)
    for _, o in ipairs(self.q) do
        love.graphics.push()
        love.graphics.translate(-o.x, -o.y)
        o.cb()
        love.graphics.pop()
    end
    love.graphics.pop()

    if self.shader then
        love.graphics.setShader()
    end
end

function Res:get_x()
    return (love.mouse.getX()-self.shift.x)/self.zoom/Camera.zoom
end

function Res:get_y()
    return (love.mouse.getY()-self.shift.y)/self.zoom/Camera.zoom
end

function Res:resize(w, h)
    if self.w-w > self.h-h then
        self.zoom = w/self.w
        self.shift.x = 0
        self.shift.y = h/2-Res.h*Res.zoom/2
    else
        self.zoom = h/self.h
        self.shift.x = w/2-Res.w*Res.zoom/2
        self.shift.y = 0
    end
end
