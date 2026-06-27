Camera = {}

Camera.offset_x = 0
Camera.offset_y = 0
Camera.target_x = 0
Camera.target_y = 0
Camera.x = 0
Camera.y = 0

Camera.x_damp = nil
Camera.y_damp = nil

Camera.shake_damp = nil
Camera.shake_x = 0
Camera.shake_y = 0
Camera.shake_duration = 0

Camera.on = false
local shake_thresh = 0.1

function Camera:add(x, y)
    self.target_x = self.target_x+x
    self.target_y = self.target_y+y
end

function Camera:set(x, y)
    self.target_x = x
    self.target_y = y
end

function Camera:offset(x, y)
    self.offset_x = x
    self.offset_y = y
end

function Camera:snap_back()
    self.x = self.target_x-self.offset_x
    self.y = self.target_y-self.offset_y
end

function Camera:shake(dur)
    self.shake_duration = dur
end

function Camera:start()
    love.graphics.push()
    if self.shake_duration > shake_thresh then
        love.graphics.translate(self.shake_x, self.shake_y)
    end
    love.graphics.translate(-self.x, -self.y)
    self.on = true
end

function Camera:stop()
    love.graphics.pop()
    self.on = false
end

function Camera:update(dt)
    if self.shake_duration > shake_thresh then
        self.shake_x = math.random(-self.shake_duration, self.shake_duration)
        self.shake_y = math.random(-self.shake_duration, self.shake_duration)
    end
    self.shake_duration = self.shake_duration+(0-self.shake_duration)*self.shake_damp*dt
    
    self.x = self.x+(self.target_x-self.offset_x-self.x)*self.x_damp*dt
    self.y = self.y+(self.target_y-self.offset_y-self.y)*self.y_damp*dt
end

function Camera:check_vis(x, y, w, h)
    x, y = x-self.x+self.shake_x, y-self.y+self.shake_y
    return x > -w and y > -h and x < Res.w and y < Res.h
end