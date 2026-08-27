Audio = {}
Audio.channels = {
    master = 10,
    sfx = 10,
    music = 10
}
Audio.sounds = {}

local function updateVolume(sound)
    local channel_volume = Audio.channels[sound.channel]*0.1
    local master_volume = Audio.channels.master*0.1
    sound.source:setVolume(channel_volume*master_volume*sound.volume)
end

function Audio.new(name, volume, options)
    options = options or {}
    options.type = options.type or "stream"
    options.channel = options.channel or "sfx"
    options.loop = options.loop or false
    volume = volume or 0.5
    local source = love.audio.newSource("assets/audio/"..name..".ogg", options.type)
    if options.loop then
        source:setLooping(true)
    end
    local sound = {
        source = source,
        volume = volume,
        init_volume = volume,
        channel = options.channel
    }
    updateVolume(sound)
    Audio.sounds[name] = sound
end

function Audio.play(name, pitch)
    local source = Audio.sounds[name].source
    pitch = pitch or 1
    source:setPitch(pitch)
    source:stop()
    source:play()
end

function Audio.stop(name)
    local source = Audio.sounds[name].source
    source:stop()
end

function Audio.change_channel_volume(x, channel)
    Audio.channels[channel] = math.clamp(Audio.channels[channel]+x, 0, 10)
    Audio.update_volumes()
end

function Audio.set_channel_volume(x, channel)
    Audio.channels[channel] = x
    Audio.update_volumes()
end

function Audio.update_volumes()
    for name, _ in pairs(Audio.sounds) do
        updateVolume(name)
    end
end