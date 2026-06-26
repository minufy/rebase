Timer = Object:extend()

function Timer:new(time, timer)
    self.time = time
    self.timer = timer or 0
end

function Timer:run(dt)
    self.timer = self.timer+dt
    if self.timer >= self.time then
        self.timer = 0
        return true
    end
    return false
end