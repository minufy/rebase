Image = {}
Image.images = {}

local error = love.graphics.newImage("assets/imgs/error.png")
setmetatable(Image, {
    __index = function(table, key)
        if Image.images[key] == nil then
            return error
        end
        return Image.images[key]
    end
})

function Image.new(name, key)
    key = key or name
    local path = "assets/imgs/"..name..".png"
    if love.filesystem.getInfo(path) then
        local img = love.graphics.newImage(path)
        Image.images[key] = img
        return img
    else
        Log("Image not found: "..path)
        return error
    end
end