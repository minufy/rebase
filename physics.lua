Physics = {}

function Physics.dist(self, group_names, cb, radius)
    for _, group_name in ipairs(group_names) do
        local group = Game.objects[group_name]
        if group ~= nil then
            for _, other in ipairs(group) do
                if self ~= other and math.dist(self, other) <= radius then
                    cb(other)
                end
            end
        end
    end
end

function Physics.col(self, group_names, cb)
    for _, group_name in ipairs(group_names) do
        local group = Game.objects[group_name]
        if group ~= nil then
            Physics.col_group(self, group, cb)
        end
    end
end

function Physics.col_group(self, group, cb)
    for _, other in ipairs(group) do
        if self ~= other and AABB(self, other) then
            cb(other)
        end
    end
end

function Physics.solve_x(self, x, col)
    if col then
        if x > 0 then
            self.x = col.x-self.w
        else
            self.x = col.x+col.w
        end
    end
end

function Physics.solve_y(self, y, col)
    if col then
        if y > 0 then
            self.y = col.y-self.h
        else
            self.y = col.y+col.h
        end
    end
end

function Physics.col_tiles(self, cb, layers)
    layers = layers or {1}
    for i, layer in ipairs(layers) do
        local tiles = Game.objects["tiles"][layer]
        local around = tiles:around(math.round(self.x, TILE_SIZE), math.round(self.y, TILE_SIZE))
        Physics.col_group(self, around, cb)
    end
end