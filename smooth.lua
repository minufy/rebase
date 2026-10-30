function Smooth(object, fields)
    object._smooth_fields = fields
    for k, _ in pairs(fields) do
        object["smooth_"..k] = object[k]
    end
    function object:update_smooth(dt)
        for k, damp in pairs(fields) do
            local current = self["smooth_"..k]
            self["smooth_"..k] = current+(self[k]-current)*Damp(dt, damp)
        end
    end
end
