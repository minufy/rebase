Timer = {}
Timer.__index = Timer

function Timer.new(time, timer)
    local self = setmetatable({}, Timer)
    self.time = time
    self.timer = timer or 0
    return self
end

function Timer:run(dt)
    self.timer = self.timer+dt
    if self.timer >= self.time then
        self.timer = 0
        return true
    end
    return false
end