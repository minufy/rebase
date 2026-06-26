Image = {}

local error = love.graphics.newImage("assets/imgs/error.png")
setmetatable(Image, {
    __index = function(table, key)
        -- Log("Image not found: "..key)
        return error
    end
})

function NewImage(name, key)
    key = key or name
    local path = "assets/imgs/"..name..".png"
    if love.filesystem.getInfo(path) then
        Image[key] = love.graphics.newImage(path)
    else
        Log("Image not found: "..path)
    end
end