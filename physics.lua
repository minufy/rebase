Physics = {}

---@param object table
---@param group table[string]
---@param cb function
---@param radius number
---@return boolean
function Physics.dist(object, group, cb, radius)
    local ret = false
    for _, other in ipairs(group) do
        if object ~= other and math.dist(object, other) <= radius then
            if cb then
                cb(object, other)
            end
            ret = true
        end
    end
    return ret
end

---@param object table
---@param group table[string]
---@param cb function
---@return boolean
function Physics.col(object, group, cb)
    local ret = false
    for _, other in ipairs(group) do
        if object ~= other and AABB(object, other) then
            if cb then
                cb(object, other)
            end
            ret = true
        end
    end
    return ret
end

---@param object table
---@param x number
---@param col table
function Physics.solve_x(object, x, col)
    if col then
        if x > 0 then
            object.x = col.x-object.w
        else
            object.x = col.x+col.w
        end
    end
end

---@param object table
---@param y number
---@param col table
function Physics.solve_y(object, y, col)
    if col then
        if y > 0 then
            object.y = col.y-object.h
        else
            object.y = col.y+col.h
        end
    end
end
