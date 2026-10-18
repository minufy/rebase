local shadow = {}

function shadow:init(offset, alpha)
    self.shader = love.graphics.newShader("assets/shaders/shadow.glsl")
    self.offset = offset or {x = 4, y = 4}
    self.canvas = love.graphics.newCanvas(Res.w, Res.h)
    self.prev_canvas = nil
    self.prev_shader = nil
    self.shader:send("alpha", alpha or 0.2)
end

function shadow:start()
    self.prev_shader = love.graphics.getShader()
    self.prev_canvas = love.graphics.getCanvas()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
end

function shadow:stop()
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setCanvas(self.prev_canvas)
    
    love.graphics.setShader(self.shader)
    love.graphics.draw(self.canvas, self.offset.x, self.offset.y)

    love.graphics.setShader(self.prev_shader)
    love.graphics.draw(self.canvas)
    love.graphics.setBlendMode("alpha")
end

local outline = {}

function outline:init(offset, color)
    self.offset = offset or 1
    self.shader = love.graphics.newShader("assets/shaders/outline.glsl")
    self.canvas = love.graphics.newCanvas(Res.w, Res.h)
    self.prev_canvas = nil
    self.shader:sendColor("Color", color or {0, 0, 0, 1})
end

function outline:start()
    self.prev_shader = love.graphics.getShader()
    self.prev_canvas = love.graphics.getCanvas()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
end

function outline:stop()
    love.graphics.setCanvas(self.prev_canvas)
    
    love.graphics.setShader(self.shader)
    for x = -self.offset, self.offset do
        for y = -self.offset, self.offset do
            if not (x == 0 and y == 0) then
                love.graphics.draw(self.canvas, x, y)
            end
        end
    end

    love.graphics.setShader(self.prev_shader)
    love.graphics.draw(self.canvas)
end

local cleanedge = {}

function cleanedge:init()
    self.shader = love.graphics.newShader("assets/shaders/cleanedge.glsl")
end

function cleanedge:start(w, h)
    self.shader:send("texSize", {w, h})
    self.prev_shader = love.graphics.getShader()
    love.graphics.setShader(self.shader)
end

function cleanedge:stop()
    love.graphics.setShader(self.prev_shader)
end

local glitch = {}

function glitch:init()
    self.shader = love.graphics.newShader("assets/shaders/glitch.glsl")
end

function glitch:start(time_offset)
    self.prev_shader = love.graphics.getShader()
    self.shader:send("time", love.timer.getTime()+time_offset)
    love.graphics.setShader(self.shader)
end

function glitch:stop()
    love.graphics.setShader(self.prev_shader)
end

Shaders = {}
Shaders.outline = outline
Shaders.shadow = shadow
Shaders.cleanedge = cleanedge
Shaders.glitch = glitch