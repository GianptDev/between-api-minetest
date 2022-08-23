

--- -----------------------------------------------------------


--- contain a list of interpolation functions,
--- each method require a start value, end value
--- and the position in time from start to end of the interpolation (0.0 to 1.0).
---
--- 	interpolation.linear(0, 8, 0.5) -- 4
--- 	interpolation.quadratic_in(0, 8, 0.5) -- 2
--- 	interpolation.quadratic_out(0, 8, 0.5) -- 4.5
--- @type table<function>
BeTweenApi.interpolation = {}


--- -----------------------------------------------------------


--- straight increment from x to y in time.
--- @param x number
--- @param y number
--- @param t number
--- @return number
function BeTweenApi.interpolation.linear (x, y, t)
	return x + t * (y - x)
end


--- movement increment faster from x to y in time.
--- @param x number
--- @param y number
--- @param t number
--- @return number
function BeTweenApi.interpolation.quadratic_in (x, y, t)
	return BeTweenApi.interpolation.linear(x, y, t ^ 2)
end


--- movement increment slower from x to y in time.
--- @param x number
--- @param y number
--- @param t number
--- @return number
function BeTweenApi.interpolation.quadratic_out (x, y, t)
	return BeTweenApi.interpolation.linear(x, y, t * (2.0 - t))
end


--- movement is faster between x to y but slow down on begin and end in time.
--- @param x number
--- @param y number
--- @param t number
--- @return number
function BeTweenApi.interpolation.quadratic_in_out (x, y, t)
	x = BeTweenApi.interpolation.quadratic_in(x, y, t)
	y = BeTweenApi.interpolation.quadratic_out(x, y, t)
	return BeTweenApi.interpolation.linear(x, y, t)
end


--- movement increment faster from x to y in time.
--- @param x number
--- @param y number
--- @param t number
--- @return number
function BeTweenApi.interpolation.cubic_in (x, y, t)
	return BeTweenApi.interpolation.linear(x, y, t ^ 3)
end

--- movement increment slower from x to y in time.
--- @param x number
--- @param y number
--- @param t number
--- @return number
function BeTweenApi.interpolation.cubic_out (x, y, t)
	t = t - 1.0
	return BeTweenApi.interpolation.linear(x, y, 1.0 + (t ^ 3))
end


--- movement is faster between x to y but slow down on begin and end in time.
--- @param x number
--- @param y number
--- @param t number
--- @return number
function BeTweenApi.interpolation.cubic_in_out (x, y, t)
	
	t = t * 2
	if (t < 1.0) then
		return BeTweenApi.interpolation.linear(x, y, 0.5 * (t ^ 3))
	end

	t = t - 2.0
	return BeTweenApi.interpolation.linear(x, y, 0.5 * (t ^ 3 + 2.0))
end


--- movement increment faster from x to y in time.
--- @param x number
--- @param y number
--- @param t number
--- @return number
function BeTweenApi.interpolation.quartic_in (x, y, t)
	return BeTweenApi.interpolation.linear(x, y, t ^ 4)
end


--- movement increment slower from x to y in time.
--- @param x number
--- @param y number
--- @param t number
--- @return number
function BeTweenApi.interpolation.quartic_out (x, y, t)
	t = t - 1.0
	return BeTweenApi.interpolation.linear(x, y, 1.0 - (t ^ 4))
end


--- movement is faster between x to y but slow down on begin and end in time.
--- @param x number
--- @param y number
--- @param t number
--- @return number
function BeTweenApi.interpolation.quartic_in_out (x, y, t)
	
	t = t * 2
	if (t < 1.0) then
		return BeTweenApi.interpolation.linear(x, y, 0.5 * (t ^ 4))
	end

	t = t - 2.0
	return BeTweenApi.interpolation.linear(x, y, -0.5 * (t ^ 4 - 2.0))
end


--- movement jump from x to y like an elastic, movement is very fast but slow down in time.
--- @param x number
--- @param y number
--- @param t number
--- @return number
function BeTweenApi.interpolation.elastic (x, y, t)
	t = (2.0 ^ -(10.0 * t) * math.sin((t - 0.1) * (2.0 * math.pi) / 0.4)) + 1.0
	return BeTweenApi.interpolation.linear(x, y, t)
end


--- movement increment faster from x to y in time, the movement has the shape of a curve.
--- @param x number
--- @param y number
--- @param t number
--- @return number
function BeTweenApi.interpolation.sinusoidal_in (x, y, t)
	t = 1.0 - math.cos(t * math.pi / 2.0)
	return BeTweenApi.interpolation.linear(x, y, t)
end


--- movement increment faster from x to y in time, the movement has the shape of a curve.
--- @param x number
--- @param y number
--- @param t number
--- @return number
function BeTweenApi.interpolation.sinusoidal_out (x, y, t)
	t = math.sin(t * math.pi / 2.0)
	return BeTweenApi.interpolation.linear(x, y, t)
end


--- movement is faster between x to y but slow down on begin and end in time, the movement has the shape of a curve.
--- @param x number
--- @param y number
--- @param t number
--- @return number
function BeTweenApi.interpolation.sinusoidal_in_out (x, y, t)
	t = 0.5 * (1.0 - math.cos(math.pi * t))
	return BeTweenApi.interpolation.linear(x, y, t)
end


--- movement increment faster esponentially from x to y in time.
--- @param x number
--- @param y number
--- @param t number
--- @return number
function BeTweenApi.interpolation.circular_in  (x, y, t)
	t = 1.0 - math.sqrt(1.0 - t * t)
	return BeTweenApi.interpolation.linear(x, y, t)
end


--- movement increment slower esponentially from x to y in time.
--- @param x number
--- @param y number
--- @param t number
--- @return number
function BeTweenApi.interpolation.circular_out (x, y, t)
	t = t - 1.0
	return BeTweenApi.interpolation.linear(x, y, math.sqrt(1.0 - (t * t)))
end


--- movement increment slower from the start to the end but speed up esponentially in the middle.
--- @param x number
--- @param y number
--- @param t number
--- @return number
function BeTweenApi.interpolation.circular_in_out (x, y, t)

	t = t * 2
	if (t < 1.0) then
		return BeTweenApi.interpolation.linear(x, y, -0.5 * (math.sqrt(1.0 - t * t) - 1.0))
	end

	t = t - 2.0
	return BeTweenApi.interpolation.linear(x, y, 0.5 * (math.sqrt(1.0 - t * t) + 1.0))
end


--- -----------------------------------------------------------

