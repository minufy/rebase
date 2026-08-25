Image = {}

local error = love.graphics.newImage("assets/imgs/error.png")
setmetatable(Image, {
    __index = function(table, key)
        return error
    end
})

function NewImage(name, key)
    key = key or name
    local path = "assets/imgs/"..name..".png"
    if love.filesystem.getInfo(path) then
        local img = love.graphics.newImage(path)
        Image[key] = img
        return img
    else
        Log("Image not found: "..path)
        return error
    end
end