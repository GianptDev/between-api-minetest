

--- -----------------------------------------------------------


--- @meta
--- this module implement general math functions for the api.


--- -----------------------------------------------------------


--- return the current version as a string.
--- @return string version
--- @nodiscard
function BeTweenApi.version_name ()
	return "1.2.1"
end


--- -----------------------------------------------------------


--- keep a number value in between of min and max, if the value is already in between is directly returned.
--- @param value number the value to clamp.
--- @param min number the minimal output value.
--- @param max number tha maximal output value.
--- @return number clamped
--- @nodiscard
function BeTweenApi.clamp (value, min, max)
	return value < min and min or value > max and max or value
end


--- make the value flow around the range of min and max.
--- @param value number the value to wrap.
--- @param min number the initial value of each wrap, output will be at least this.
--- @param max number how much is required to wrap, output wil be at max this.
--- @return number wrapped
--- @nodiscard
function BeTweenApi.wrap (value, min, max)

	--- if min and max are the same, NaN is returned, this will make sure to return the minimun.
	if (min == max) then
		return min
	end

	return (value - max) % (min - max) + max
end


--- round the value to the nearest point of snap.
--- @param value number the value to snap.
--- @param snap number the size of the snap, should be a positive numberm negative numbers will work fine too.
--- @return number snapped
--- @nodiscard
function BeTweenApi.snap (value, snap)

	--- just to make sure division by zero does not happen.
	if (snap == 0.0) then
		return 0.0
	end

	return math.floor((value / snap) + 0.5) * snap
end


--- -----------------------------------------------------------

