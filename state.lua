State = {}

function State:set(k, v)
    self[k] = v
end

function State:get(k)
    return self[k]
end