local Tiles = require("objects.tiles")

return function (Game)
    function Game:add(Object, ...)
        local o = Object(...)
        local group_name = tostring(o)
        if self.objects[group_name] == nil then
            self.objects[group_name] = {}
        end
        table.insert(self.objects[group_name], o)
        return o
    end

    function Game:add_tiles(layer)
        local o = Tiles(layer)
        self.tiles[layer.name] = o
        return o
    end
end