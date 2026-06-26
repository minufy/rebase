Shadow = {}

function Shadow:init(offset)
    self.shader = love.graphics.newShader("assets/shader/shadow.glsl")
    self.offset = offset or {x = 4, y = 4}
    self.canvas = love.graphics.newCanvas(Res.w, Res.h)
end

function Shadow:start()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
end

function Shadow:stop()
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setCanvas(Res.canvas)
    
    love.graphics.setShader(self.shader)
    love.graphics.draw(self.canvas, self.offset.x, self.offset.y)

    love.graphics.setShader()
    love.graphics.draw(self.canvas)
    
    love.graphics.setBlendMode("alpha")
end

Outline = {}

function Outline:init(offset)
    self.offset = offset or 1
    self.shader = love.graphics.newShader("assets/shader/outline.glsl")
    self.canvas = love.graphics.newCanvas(Res.w, Res.h)
    self.prev_canvas = nil
end

function Outline:start()
    self.prev_canvas = love.graphics.getCanvas()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
end

function Outline:stop()
    love.graphics.setBlendMode("alpha", "premultiplied")
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
    
    love.graphics.setBlendMode("alpha")
end