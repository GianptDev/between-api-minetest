

--- -----------------------------------------------------------


--- @meta


--- -----------------------------------------------------------


--- This is a list of all active tween that are processed in the server.
--- @type table<Tween>[]
BeTweenApi.active_tweens = {}


--- -----------------------------------------------------------
--- Tween methods


--- Start the execution of this tween, it will be added in the active_tweens list until stopped or finished.
--- @param _ Tween
local function start (_)

	--- do not run the tween twince.
	if (_:is_running() == true) then
		minetest.log("action", string.format("Tried to start tween '%p' twince.", _))
		return
	end

	--- tween will start soon, add inside the tween loop.
	table.insert(BeTweenApi.active_tweens, _)
	minetest.log("verbose", string.format("Tween '%d' ~ '%p' is now running.", _:index(), _))

	--- call the virtual.
	if (_.on_start ~= nil) then
		_.on_start(_)
	end
end


--- stop the tween to work by removing it from the active list.
--- @param _ Tween
--- @param reset boolean false
local function stop (_, reset)
	local index = _:index()

	--- set default reset value.
	if (reset == nil) then
		reset = (reset == nil)
	end
	
	--- index does not exist because the tween is not running.
	if (index == nil) then
		minetest.log("action", string.format("Tried to stop tween '%p' wich wasn't running.", _))
		return
	end

	--- reset the timer.
	if (reset == true) then
		_.timer = 0
	end

	--- tween is stopped now, remove from tween loop.
	table.remove(BeTweenApi.active_tweens, index)
	minetest.log("verbose", string.format("Tween '%p' has been stopped.", _))

	--- call the virtual.
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
--- 	on_step(tween, step: number)	--- executed on tween interpolation step.
--- 	on_loop(tween)	--- executed every loop the tween complete, only called if loop is used.
--- @param interpolation fun(x: number, y:number, t: number)
--- @param movement { [1]: number, [2]: number, [3]: boolean } | { start: number, finish: number, mirror: boolean }
--- @param time number
--- @param loop boolean | integer false
--- @param callbacks { on_start: fun(tween: Tween), on_stop: fun(tween: Tween), on_step: fun(tween: Tween, step: number), on_loop: fun(tween: Tween) } nil
--- @return Tween | nil
--- @nodiscard
function BeTweenApi.tween (interpolation, movement, time, loop, callbacks)

	--- if the user does not like indexes, allow to use keys.
	--- this will check if the user used indexes or names as argouments.
	for i, a in pairs({ [1] = "start", [2] = "finish", [3] = "mirror", }) do
		movement[i] =
			(movement[i] ~= nil) and movement[i] or
			(movement[a] ~= nil) and movement[a] or nil
		
		--- if a required argoument is missing stop the creation of the tween.
		if ((i <= 2) and (movement[i] == nil)) then
			minetest.log("error", "Failed to make tween because movement contain incorrect argouments.")
			return nil
		end
	end

	if (time == nil) then
		minetest.log("error", "Tween does not set his duration time.")
		return nil
	end
	
	-- callbacks are optional but make sure is a table.
	if (callbacks == nil) then
		callbacks = {}
	end

	--- make the tween table.
	--- @class Tween
	--- @field interpolation fun(x: number, y: number, t: number)
	--- @field movement { [1]: number, [2]: number, [3]: boolean }
	--- @field time number
	--- @field timer number this timer is used internally by the tween when running.
	--- @field loop boolean | integer
	--- @field on_start fun(tween: Tween) | nil
	--- @field on_stop fun(tween: Tween) | nil
	--- @field on_step fun(tween: Tween, step: number) | nil
	--- @field on_loop fun(tween: Tween) | nil
	local tween = {
		interpolation = interpolation,
		movement = {
			movement[1], movement[2],
			(movement[3] ~= nil) and movement[3] or false
		},
		time = time,
		timer = 0.0,
		loop = (loop ~= nil) and loop or false,
		on_start = callbacks.on_start,
		on_stop = callbacks.on_stop,
		on_step = callbacks.on_step,
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

