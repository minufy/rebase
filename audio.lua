Audio = {}
Audio.global_volume = 10
Audio.sources = {}

Source = Object:extend()

function Source:new(name, volume, type, cb)
    type = type or "static"
    self.source = love.audio.newSource("assets/audio/"..name..".ogg", type)
    self.volume = volume
    self:update()
    if cb then
        cb(self.source)
    end
end

function Source:play(pitch)
    pitch = pitch or 1
    self:update()
    self.source:setPitch(pitch)
    self.source:stop()
    self.source:play()
end

function Source:update()
    self.source:setVolume(self.volume*Audio.global_volume/10)
end

function NewAudio(name, volume, type, cb)
    local source = Source(name, volume, type, cb)
    if type == "stream" then
        table.insert(Audio.sources, source)
    end
    Audio[name] = source
    return source
end

function Audio:change_global_volume(x)
    Audio.global_volume = Audio.global_volume+x
    if Audio.global_volume > 10 then
        Audio.global_volume = 10
    elseif Audio.global_volume < 0 then
        Audio.global_volume = 0
    end
end

function Audio:set_global_volume(x)
    Audio.global_volume = x
end

function Audio:update()
    for i, source in ipairs(self.sources) do
        source:update()
    end
end