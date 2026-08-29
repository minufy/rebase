Timer = {}
Timer.__index = Timer

function Timer.new(time, timer)
    local self = {}
    self.time = time
    self.timer = timer or 0
    return setmetatable(self, Timer)
end

function Timer:run(dt)
    self.timer = self.timer+dt
    if self.timer >= self.time then
        self.timer = 0
        return true
    end
    return false
end