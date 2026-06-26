function SetType(Object, type)
    function Object:__tostring()
        return type
    end
end

local json = require("modules.json")

Level = {}

local Tiles = require("objects.tiles")
local Decal = require("objects.decal")

function Level:refresh()
    for _, entity_name in ipairs(ENTITIY_NAMES) do
        for k, v in pairs(package.loaded) do
            if k:sub(1, #"objects.") == "objects." then
                package.loaded[k] = false
            end
        end
        self.entities[entity_name] = require("objects."..entity_name)
    end
    Log("objects refreshed")
end

function Level:init()
    self.entities = {}
    for _, entity_name in ipairs(ENTITIY_NAMES) do
        self.entities[entity_name] = require("objects."..entity_name)
    end
    for _, tile_name in ipairs(TILE_NAMES) do
        NewImage(tile_name)
    end
    for _, decal_name in ipairs(DECAL_NAMES) do
        NewImage(decal_name)
    end
end

function Level:load_level(level_name)
    local contents, _ = love.filesystem.read("assets/levels/"..level_name..".json")
    if contents then
        local level_data = json.decode(contents)
        for _, layer in ipairs(level_data.layers) do
            if layer.tileset then
                Game:add(Tiles, layer)
            elseif layer.entities then
                for _, entity in ipairs(layer.entities) do
                    Game:add(self.entities[entity.name], entity)
                end
            elseif layer.decals then
                for _, decal in ipairs(layer.decals) do
                    Game:add(Decal, decal)
                end
            end
        end
    else
        Log("could not load "..level_name)
    end
end