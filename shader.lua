Shadow = {}

function Shadow:init(offset, alpha)
    self.shader = love.graphics.newShader("assets/shader/shadow.glsl")
    self.offset = offset or {x = 4, y = 4}
    self.canvas = love.graphics.newCanvas(Res.w, Res.h)
    self.prev_canvas = nil
    self.shader:send("alpha", alpha or 0.2)
end

function Shadow:start()
    self.prev_canvas = love.graphics.getCanvas()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
end

function Shadow:stop()
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setCanvas(self.prev_canvas)
    
    love.graphics.setShader(self.shader)
    love.graphics.draw(self.canvas, self.offset.x, self.offset.y)

    love.graphics.setShader()
    love.graphics.draw(self.canvas)
    love.graphics.setBlendMode("alpha")
end

Outline = {}

function Outline:init(offset, color)
    self.offset = offset or 1
    self.shader = love.graphics.newShader("assets/shader/outline.glsl")
    self.canvas = love.graphics.newCanvas(Res.w, Res.h)
    self.prev_canvas = nil
    self.shader:sendColor("Color", color or {0, 0, 0, 1})
end

function Outline:start()
    self.prev_canvas = love.graphics.getCanvas()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
end

function Outline:stop()
    love.graphics.setCanvas(self.prev_canvas)
    
    love.graphics.setShader(self.shader)
    for x = -self.offset, self.offset do
        for y = -self.offset, self.offset do
            if not (x == 0 and y == 0) then
                love.graphics.draw(self.canvas, x, y)
            end
        end
    end

    love.graphics.setShader()
    love.graphics.draw(self.canvas)
end

Scanline = {}

function Scanline:init(scanline_strength, glow_strength)
    self.shader = love.graphics.newShader("assets/shader/scanline.glsl")
    self.canvas = love.graphics.newCanvas(Res.w, Res.h)
    self.prev_canvas = nil
    self.shader:send("texture_size", {Res.w, Res.h})
    self.shader:send("scanline_strength", scanline_strength or 0.1)
    self.shader:send("glow_strength", glow_strength or 0.4)
end

function Scanline:start()
    self.prev_canvas = love.graphics.getCanvas()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
end

function Scanline:stop()
    love.graphics.setCanvas(self.prev_canvas)
    love.graphics.setShader(self.shader)
    love.graphics.draw(self.canvas, 0, 0)
    love.graphics.setShader()
end