local max_logs = 100
local anim_damp = 0.3
local w = 250
local h = 200

Log = {}
Log.logs = {}
Log.time = 240
Log.anim = 0
-- Log.col = {x = 0, y = 0, w = 250, h = 200}
Log.x = 0
Log.y = 0
Log.w = w
Log.h = h
Log.scroll = 0
Log.alpha = 0
Log.smooth_w = w
Log.smooth_h = h
Log.smooth_scroll = 0
local font
local font_small
local mouse_col = {x = 0, y = 0, w = 0, h = 0}

setmetatable(Log, {
    __call = function (_, ...)
        Log:log(...)
    end
})

function Log:log(...)
    local text = ""
    for _, t in ipairs({...}) do
        text = text..tostring(t).." "
    end
    if #self.logs >= max_logs then
        table.remove(self.logs, 1)
    end
    local prev_log = self.logs[#self.logs]
    if prev_log and text == prev_log.text then
        prev_log.duplicates = prev_log.duplicates+1
    else
        local date = os.date("%H:%M:%S")
        table.insert(self.logs, {date = date, text = text, duplicates = 0})
        print(date..": "..text)
        self.anim = 1
    end
end

function Log:init()
    font = love.graphics.newFont(20)
    font_small = love.graphics.newFont(15)
end

function Log:draw()
    if CONSOLE then
        love.graphics.setColor(1, 1, 1, 0.2+self.alpha)
        love.graphics.rectangle("fill", 0, 0, self.smooth_w, self.smooth_h)
        love.graphics.setScissor(0, 0, self.smooth_w, self.smooth_h)
        Color.reset()
        for i, log in ipairs(self.logs) do
            local y = (#self.logs-i-self.anim+self.smooth_scroll)*font:getHeight()
            -- love.graphics.setColor(1, 1, 1, 1-log.timer/self.time)
            love.graphics.setFont(font_small)
            local date_text = log.date..": "
            love.graphics.print(date_text, 0, y)
            love.graphics.setFont(font)
            love.graphics.print(log.text.." ("..log.duplicates..")", font_small:getWidth(date_text), y)
        end
        love.graphics.setScissor()
    end
end

function Log:update(dt)
    if CONSOLE then
        self.anim = self.anim-self.anim*anim_damp*dt
        local prev_mouse_x = mouse_col.x
        local prev_mouse_y = mouse_col.y
        mouse_col.x = love.mouse.getX()
        mouse_col.y = love.mouse.getY()
        if Input.mb[1].down then
            self.w = math.max(0, self.w+mouse_col.x-prev_mouse_x)
            self.h = math.max(0, self.h+mouse_col.y-prev_mouse_y)
            if Input.wheel.up then
                self.scroll = self.scroll+4
            elseif Input.wheel.down then
                self.scroll = self.scroll-4
            end
        else
            self.scroll = 0
        end
        if Input.mb[2].released then
            if AABB(self, mouse_col) then
                self.w = w
                self.h = h
                self.alpha = 0.2
            end
        end
        self.smooth_w = self.smooth_w+(self.w-self.smooth_w)*anim_damp*dt
        self.smooth_h = self.smooth_h+(self.h-self.smooth_h)*anim_damp*dt
        self.smooth_scroll = self.smooth_scroll+(self.scroll-self.smooth_scroll)*anim_damp*dt
        self.alpha = self.alpha-self.alpha*anim_damp*dt
    end
end
