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

Input.swap_mode = NewInput({"tab"})
Input.toggle_editor = NewInput({"`"})
Input.ctrl = NewInput({"lctrl"})
Input.save = NewInput({"s"})
Input.shift = NewInput({"lshift"})
Input.delete = NewInput({"delete", "x"})
Input.deselect = NewInput({"escape"})
Input.undo = NewInput({"z"})
Input.copy_key = NewInput({"c"})
Input.reset_zoom = NewInput({"rshift"})
Input.next_level = NewInput({"]"})
Input.prev_level = NewInput({"["})
Input.cycle = NewInput({"lalt"})
Input.alt = NewInput({"lalt"})
Input.space = NewInput({"space"})
Input.unlock = NewInput({"q"})
Input.reload = NewInput({"r"})

Input.mb_emu_1 = NewInput({"1"})
Input.mb_emu_2 = NewInput({"3"})
Input.mb_emu_3 = NewInput({"2"})

Input.mb_emu = {
    Input.mb_emu_1,
    Input.mb_emu_2,
    Input.mb_emu_3,
}