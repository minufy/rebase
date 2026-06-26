local MAX_LOGS = 100

Log = {}
Log.logs = {}
Log.time = 240
Log.prev = ""

setmetatable(Log, {
    __call = function (self, ...)
        local text = os.date().." : "
        for i, t in ipairs({...}) do
            text = text..tostring(t).." "
        end
        if #self.logs >= MAX_LOGS then
            table.remove(self.logs, 1)
        end
        if text ~= Log.prev then
            table.insert(self.logs, {text = text, timer = 0})
            print(text)
            Log.prev = text
        end
    end
})

function Log:draw()
    love.graphics.setFont(LogFont)
    for i, log in ipairs(self.logs) do
        love.graphics.setColor(1, 1, 1, 1-log.timer/Log.time)
        love.graphics.print(log.text, 0, (#self.logs-i)*LogFont:getHeight())
    end
    Color.reset()
end

function Log:update(dt)
    for i = #self.logs, 1, -1 do
        self.logs[i].timer = self.logs[i].timer+dt
        if self.logs[i].timer > Log.time then
            table.remove(self.logs, i)
        end
    end
end