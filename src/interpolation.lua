

--[[
    contain a list of interpolation functions,
    each method require a start value, end value
    and the position in time from start to end of the interpolation (0.0 to 1.0).

        interpolation.linear(0, 8, 0.5) -- 4
        interpolation.ease_in(0, 8, 0.5) -- 2
        interpolation.ease_out(0, 8, 0.5) -- 4.5
]]
BeTweenApi.interpolation = {

    -- straight increment from x to y in time.
    linear = function (x, y, t)
        return x + t * (y - x)
    end,

    -- movement increment faster from x to y in time.
    ease_in = function (x, y, t)
        return x + ((t * t) / 1.0) * (y - x)
    end,

    -- movement increment slower from x to y in time.
    ease_out = function (x, y, t)
        t = 1 - ((1 - t) ^ 2)
        return BeTweenApi.interpolation.ease_in(x, y, t)
    end,

    -- movement is faster between x to y but slow down on begin and end in time.
    ease_in_out = function (x, y, t)
        x = BeTweenApi.interpolation.ease_in(x, y, t)
        y = BeTweenApi.interpolation.ease_out(x, y, t)
        return BeTweenApi.interpolation.linear(x, y , t)
    end,

    -- movement moves like linear, but reach his destination in half the time, the rest of the time is used to come back to the starting point.
    spike_linear = function (x, y, t)
        if (t <= 0.5) then
            return BeTweenApi.interpolation.linear(x, y, t / 0.5)
        end
        return BeTweenApi.interpolation.linear(x, y, (1 - t) / 0.5)
    end,

    -- movement moves like ease in, but reach his destination in half the time, the rest of the time is used to come back to the starting point.
    spike_ease_in = function (x, y, t)
        if (t <= 0.5) then
            return BeTweenApi.interpolation.ease_in(x, y, t / 0.5)
        end
        return BeTweenApi.interpolation.ease_in(x, y, (1 - t) / 0.5)
    end,

    -- movement moves like ease out, but reach his destination in half the time, the rest of the time is used to come back to the starting point.
    spike_ease_out = function (x, y, t)
        if (t <= 0.5) then
            return BeTweenApi.interpolation.ease_out(x, y, t / 0.5)
        end
        return BeTweenApi.interpolation.ease_out(x, y, (1 - t) / 0.5)
    end,

    -- movement moves like ease in out, but reach his destination in half the time, the rest of the time is used to come back to the starting point.
    spike_ease_in_out = function (x, y, t)
        if (t <= 0.5) then
            return BeTweenApi.interpolation.ease_in_out(x, y, t / 0.5)
        end
        return BeTweenApi.interpolation.ease_in_out(x, y, (1 - t) / 0.5)
    end
}

