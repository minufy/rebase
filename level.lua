local json = require("modules.json")

Level = {}

local Tiles = require("objects.tiles")
local Decal = require("objects.decal")

function Level:init()
    for i, tile_name in ipairs(TILE_NAMES) do
        NewImage(tile_name)
    end
end

function Level:load_level(level_name)
    local contents, size = love.filesystem.read("assets/levels/"..level_name..".json")
    if contents then
        local level_data = json.decode(contents)
        for i, layer in ipairs(level_data.layers) do
            if layer.tileset then
                Game:add(Tiles, layer)
            elseif layer.entities then
            elseif layer.decals then
            end
        end
    else
        Log("could not load "..level_name)
    end
end