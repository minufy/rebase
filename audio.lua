---@alias AudioChannel "master" | "sfx" | "music"
---@alias AudioSourceType "static" | "stream"

---@class AudioOptions
---@field type? AudioSourceType
---@field channel? AudioChannel
---@field loop? boolean

---@class AudioSound
---@field source love.Source
---@field volume number
---@field init_volume number
---@field channel AudioChannel

Audio = {}
---@type table<AudioChannel, number>
Audio.channels = {
    master = 10,
    sfx = 10,
    music = 10
}
---@type table<string, AudioSound>
Audio.sounds = {}

---@param sound AudioSound
local function updateVolume(sound)
    local channel_volume = Audio.channels[sound.channel]*0.1
    local master_volume = Audio.channels.master*0.1
    sound.source:setVolume(channel_volume*master_volume*sound.volume)
end

---@param name string
---@param volume? number
---@param options? AudioOptions
function Audio.new(name, volume, options)
    options = options or {}
    options.type = options.type or "stream"
    options.channel = options.channel or "sfx"
    options.loop = options.loop or false
    volume = volume or 0.5
    local path = "assets/audio/"..name..".ogg"
    if FileExists(path) then
        local source = love.audio.newSource(path, options.type)
        if options.loop then
            source:setLooping(true)
        end
        ---@type AudioSound
        local sound = {
            source = source,
            volume = volume,
            init_volume = volume,
            channel = options.channel
        }
        updateVolume(sound)
        Audio.sounds[name] = sound
    end
end

---@param name string
---@return boolean
function Audio.exists(name)
	if Audio.sounds[name] == nil then
		Log("audio '"..name.."' does not exist.")
		return false
	else
    	return true
	end
end

---@param name string
---@param pitch? number
function Audio.play(name, pitch)
    if Audio.exists(name) then
        local source = Audio.sounds[name].source
        pitch = pitch or 1
        source:setPitch(pitch)
        source:stop()
        source:play()
    end
end

---@param name string
function Audio.stop(name)
    if Audio.exists(name) then
        local source = Audio.sounds[name].source
        source:stop()
    end
end

---@param name string
function Audio.pause(name)
    if Audio.exists(name) then
        local source = Audio.sounds[name].source
        source:pause()
    end
end

---@param name string
function Audio.resume(name)
    if Audio.exists(name) then
        local source = Audio.sounds[name].source
        source:play()
    end
end

---@param x number
---@param channel AudioChannel
function Audio.change_channel_volume(x, channel)
    Audio.channels[channel] = math.clamp(Audio.channels[channel]+x, 0, 10)
    Audio.update_volumes()
end

---@param x number
---@param channel AudioChannel
function Audio.set_channel_volume(x, channel)
    Audio.channels[channel] = x
    Audio.update_volumes()
end

function Audio.update_volumes()
    for _, sound in pairs(Audio.sounds) do
        updateVolume(sound)
    end
end
