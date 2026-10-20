Animation = {}
Animation.animations = {}

function Animation.new(name, s, e, delay)
    Animation.animations[name] = {
        delay = delay,
        timer = 0,
        index = s,
        s = s,
        e = e,
    }
    local names = {}
    for i = s, e do
        local image_name = name..i
        Image.new(image_name)
        table.insert(names, image_name)
    end
    return names
end

function Animation.update(name, dt)
    local anim = Animation.animations[name]
    anim.timer = anim.timer+dt
    if anim.timer >= anim.delay then
        anim.timer = 0
        anim.index = anim.index+1
        if anim.index > anim.e then
            anim.index = anim.s
        end
    end
end

function Animation.get_frame(name)
    local anim = Animation.animations[name]
    return Image[name..anim.index]
end
