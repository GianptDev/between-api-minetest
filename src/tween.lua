

--- -----------------------------------------------------------


--- This is a list of all active tween that are processed in the server.
--- @type table<integer, Tween>
BeTweenApi.active_tweens = {}


--- -----------------------------------------------------------
--- Tween methods


--- Start the execution of this tween, it will be added in the active_tweens list until stopped or finished.
--- @param _ Tween
local function start (_)

	if (_:is_running() == true) then
		minetest.log("action", string.format("Tried to start tween '%p' twince.", _))
		return
	end

	table.insert(BeTweenApi.active_tweens, _)
	minetest.log("verbose", string.format("Tween '%d' ~ '%p' is now running.", _:index(), _))

	if (_.on_start ~= nil) then
		_.on_start(_)
	end
end


--- stop the tween to work by removing it from the active list.
--- @param _ Tween
--- @param reset boolean false
local function stop (_, reset)
	local index = _:index()

	if (reset == nil) then
		reset = false
	end
	
	if (index == nil) then
		minetest.log("action", string.format("Tried to stop tween '%p' wich wasn't running.", _))
		return
	end

	if (reset == true) then
		_.timer = 0
	end

	table.remove(BeTweenApi.active_tweens, index)
	minetest.log("verbose", string.format("Tween '%p' has been stopped.", _))

	if (_.on_stop ~= nil) then
		_.on_stop(_)
	end
end


--- check if the tween is currently running.
--- @param _ Tween
--- @return boolean
local function is_running (_)
	for i, tween in pairs(BeTweenApi.active_tweens) do
		if (tween == _) then
			return true
		end
	end

	return false
end


--- get the running index of the tween, if the tween isn't running nil is returned.
--- @param _ Tween
--- @return integer | nil
local function index (_)
	local index = 1
	
	for i, tween in pairs(BeTweenApi.active_tweens) do

		if (tween == _) then
			return index
		end

		index = index + 1
	end

	return nil
end


--- -----------------------------------------------------------
--- Tween constructor


--- create a tween object that will interpolate an intial value to a destination in time, each value calculated in time are created from the function the tween is using, after the tween has been created it has run by calling :start()
---
--- 	--- movement values, they use index NOT names.
--- 	{
--- 		begin: number, destination: number, mirror: boolean
--- 	}
---
--- 	--- callbacks, each of then give the tween.
--- 	on_start(tween)	--- executed on tween start.
--- 	on_stop(tween)	--- executed on tween stop.
--- 	on_step(step, tween)	--- executed on tween interpolation step.
--- 	on_loop(tween)	--- executed every loop the tween complete, only called if loop is used.
--- @class Tween
--- @param interpolation function
--- @param movement table
--- @param time number
--- @param loop boolean | integer false
--- @param callbacks table<function> nil
--- @return Tween | nil
function BeTweenApi.tween (interpolation, movement, time, loop, callbacks)

	-- movement require two values, the initial position and the final position.
	if ((movement[1] == nil) or (movement[2] == nil)) then
		minetest.log("error", "Failed to make tween because movement does not contain enough values.")
		return nil
	end

	--- set default value for mirror interpolation.
	if (movement[3] == nil) then
		movement[3] = false
	end

	-- callbacks are optional.
	if (callbacks == nil) then
		callbacks = {}
	end

	--- make the tween table.
	--- @class Tween
	local tween = {
		interpolation = interpolation,	--- @type function
		movement = movement,	--- @type table
		time = time,	--- @type number
		timer = 0.0,	--- @type number
		loop = loop,	--- @type boolean | integer

		--- @type function | nil
		on_start = callbacks.on_start,

		--- @type function | nil
		on_stop = callbacks.on_stop,

		--- @type function | nil
		on_step = callbacks.on_step,

		--- @type function | nil
		on_loop = callbacks.on_loop,

		--- methods
		start = start,
		stop = stop,
		is_running = is_running,
		index = index,
	}

	minetest.log("verbose", string.format("New tween '%p' created.", tween))
	return tween
end


--- -----------------------------------------------------------

