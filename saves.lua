local lume = require("modules.lume")

Saves = {}

function Saves:save_to_file(filename, t)
    local data = "return "..lume.serialize(t)
    love.filesystem.write(filename, data)
end

function Saves:load_from_file(filename)
    local data = {}
    if love.filesystem.getInfo(filename) then
        local loaded = love.filesystem.load(filename)
        if loaded then
            data = loaded()
        end
    end
    return data
end

function Saves:set_value_and_save(filename, k, v)
    local data = Saves:load_from_file(filename)
    if data then
        data[k] = v
        Saves:save_to_file(filename, data)
    else
        Saves:save_to_file(filename, {
            k = v
        })
    end
end