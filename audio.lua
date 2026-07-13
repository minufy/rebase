Audio = {}
Audio.global_volume = 10
Audio.volumes = {}
Audio.init_volumes = {}
Audio.sources = {}

function NewAudio(name, volume, type)
    type = type or "static"
    local source = love.audio.newSource("assets/audio/"..name..".ogg", type)
    Audio.volumes[name] = volume
    Audio.init_volumes[name] = volume
    Audio.sources[name] = source
    return source
end

function PlayAudio(name, pitch)
    local source = Audio.sources[name]
    pitch = pitch or 1
    source:setPitch(pitch)
    source:stop()
    source:play()
end

function ChangeGlobalVolume(x)
    Audio.global_volume = Audio.global_volume+x
    if Audio.global_volume > 10 then
        Audio.global_volume = 10
    elseif Audio.global_volume < 0 then
        Audio.global_volume = 0
    end
end

function SetGlobalVolume(x)
    Audio.global_volume = x
end

function UpdateAudio()
    for name, source in pairs(Audio.sources) do
        source:setVolume(Audio.volumes[name]*Audio.global_volume*0.1)
    end
end