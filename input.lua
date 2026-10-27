---@class Action
---@field keys table[string]
---@field pressed boolean
---@field released boolean
---@field down boolean
---@field up boolean

Input = {}

---@param keys? table[string]
---@return Action
function Input.new(keys)
    return {
        keys = keys,
        pressed = false,
        released = false,
        down = false,
        up = true,
    }
end

local function update_action(action, is_down)
    local down = is_down(action)
    local up = not down
    action.pressed = down and not action.down
    action.released = up and not action.up
    action.down = down
    action.up = up
end

local function key(action)
    for _, k in ipairs(action.keys) do
        if love.keyboard.isDown(k) then return true end
    end
    return false
end

local function mouse(action)
    return love.mouse.isDown(action.keys[1])
end

function Input:update()
    for _, action in pairs(Input) do
        if type(action) == "table" then
            if action.keys then
                update_action(action, key)
            end
        end
    end

    for i = 1, 3 do
        update_action(Input.mb[i], mouse)
    end
end

function Input:wheelmoved(_, dy)
    Input.wheel.up = dy > 0
    Input.wheel.down = dy < 0
end

function Input:reset_wheel()
    Input.wheel.up = false
    Input.wheel.down = false
end

function Input:get_x()
    return (love.mouse.getX()-Res.shift.x)/Res.zoom
end

function Input:get_y()
    return (love.mouse.getY()-Res.shift.y)/Res.zoom
end

Input.mb = {Input.new({1}), Input.new({2}), Input.new({3})}
Input.wheel = Input.new()
Input.wheel.up = false
