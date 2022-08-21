

--- This is a list of all active tween that are processed in the server.
BeTweenApi.active_tweens = {}


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
--- @param method function
--- @param movement table
--- @param time number
--- @param loop boolean | integer false
--- @param callbacks table nil
--- @return  table | nil
function BeTweenApi.tween (method, movement, time, loop, callbacks)

	-- movement require two values, the initial position and the final position.
	if ((movement[1] == nil) or (movement[2] == nil)) then
		minetest.log("action", "Failed to make tween because movement does not contain enough values.")
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

	-- make the tween table.
	local tween = {

		--- @type function
		method = method,

		--- @type table
		movement = movement,

		--- @type number
		time = time,

		--- @type number
		timer = 0.0,

		--- @type boolean | integer
		loop = loop,

		--- @type function | nil
		on_start = callbacks.on_start,

		--- @type function | nil
		on_stop = callbacks.on_stop,

		--- @type function | nil
		on_step = callbacks.on_step,

		--- @type function | nil
		on_loop = callbacks.on_loop,
	}


	--- -----------------------------------------------------------
	--- tween methods here.


	-- start the tween to work by adding it from the active list.
	function tween.start (_)

		if (_:is_running() == true) then
			minetest.log("action", string.format("Tried to start tween '%p' twince.", _))
			return
		end

		table.insert(BeTweenApi.active_tweens, _)
		minetest.log("action", string.format("Tween '%d' ~ '%p' is now running.", _:index(), _))

		if (_.on_start ~= nil) then
			_.on_start(_)
		end
	end


	--- stop the tween to work by removing it from the active list.
	---
	--- @param reset boolean false
	function tween.stop (_, reset)
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
		minetest.log("action", string.format("Tween '%p' has been stopped.", _))

		if (_.on_stop ~= nil) then
			_.on_stop(_)
		end
	end


	--- check if the tween is currently running.
	--- @return boolean
	function tween.is_running (_)
		for i, tween in pairs(BeTweenApi.active_tweens) do
			if (tween == _) then
				return true
			end
		end

		return false
	end


	--- get the running index of the tween, if the tween isn't running nil is returned.
	--- @return integer | nil
	function tween.index (_)
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


	minetest.log("action", string.format("New tween '%p' created.", tween))
	return tween
end

