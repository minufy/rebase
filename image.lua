---@class Image
---@field [string] love.Image

---@type Image
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

---@param name string
---@param key? string
---@return love.Image
function Image.new(name, key)
    key = key or name
    local path = "assets/imgs/"..name..".png"
    if FileExists(path) then
        local img = love.graphics.newImage(path)
        Image.images[key] = img
        return img
    else
        return error
    end
end
