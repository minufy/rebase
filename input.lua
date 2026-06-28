Input = {}

function NewInput(keys)
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

function Input:wheelmoved(dx, dy)
    Input.wheel.up = dy > 0
    Input.wheel.down = dy < 0
end

function Input:reset_wheel()
    Input.wheel.up = false
    Input.wheel.down = false
end

Input.mb = {NewInput({1}), NewInput({2}), NewInput({3})}
Input.wheel = NewInput()
Input.wheel.up = false