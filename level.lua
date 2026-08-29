function SetType(Object, type)
    function Object:__tostring()
        return type
    end
end

local json = require("modules.json")

Level = {}

local Decal = require("objects.decal")
local Tiles = require("objects.tiles")

function Level:refresh()
    for _, entity_name in ipairs(self.entity_names) do
        for k, v in pairs(package.loaded) do
            if k:sub(1, #"objects.") == "objects." then
                package.loaded[k] = false
            end
        end
        ENTITIES[entity_name] = require("objects."..entity_name)
        SetType(ENTITIES[entity_name], entity_name)
    end
    Log("objects refreshed")
end

function Level:init()
    self.entity_names = {}
    local files = love.filesystem.getDirectoryItems("objects")
    for _, entity_name in ipairs(files) do
        local info = love.filesystem.getInfo("objects/"..entity_name)
        if info then
            if info.type == "file" then
                table.insert(self.entity_names, entity_name:sub(1, #entity_name-4))
            end
        end
    end
    ENTITIES = {}
    for _, entity_name in ipairs(self.entity_names) do
        ENTITIES[entity_name] = require("objects."..entity_name)
        SetType(ENTITIES[entity_name], entity_name)
    end
    TILE_QUADS = {}
    for _, tile_name in ipairs(TILE_NAMES) do
        Image.new(tile_name)
        TILE_QUADS[tile_name] = {}
        local w, h = Image[tile_name]:getDimensions()
        for y = 0, h-TILE_SIZE, TILE_SIZE do
            for x = 0, w-TILE_SIZE, TILE_SIZE do
                table.insert(TILE_QUADS[tile_name], love.graphics.newQuad(x, y, TILE_SIZE, TILE_SIZE, Image[tile_name]))
            end
        end
    end
    for _, decal_name in ipairs(DECAL_NAMES) do
        Image.new(decal_name)
    end
end

function Level:load_level(level_name)
    local contents, _ = love.filesystem.read("assets/levels/"..level_name..".json")
    if contents then
        local inits = {}
        local level_data = json.decode(contents)
        for _, layer in ipairs(level_data.layers) do
            if layer.tileset then
                local tiles = Tiles.new(layer)
                Game.tiles[layer.name] = tiles
            elseif layer.entities then
                for _, entity in ipairs(layer.entities) do
                    local object = Game:add(ENTITIES[entity.name].new(entity))
                    if object.init then
                        table.insert(inits, function ()
                            object:init()
                        end)
                    end
                end
            elseif layer.decals then
                for _, decal in ipairs(layer.decals) do
                    Game:add(Decal.new(decal))
                end
            end
        end
        for _, init in ipairs(inits) do
            init()
        end
    else
        Log("could not load "..level_name)
    end
end