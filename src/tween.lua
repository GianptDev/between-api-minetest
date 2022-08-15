

-- This is a list of all active tween that are processed in the server.
BeTweenApi.active_tweens = {}


-- create a new tween table that will interpolate from a initial value to a destination value in a specific amount of time.
BeTweenApi.tween = function (method, movement, time, loop, callbacks)

	-- movement require two values, the initial position and the final position.
	if ((movement[1] == nil) or (movement[2] == nil)) then
		minetest.log("action", "Failed to make tween because movement does not contain enough values.")
		return
	end

	if ((type(loop) == "number") and (loop <= 0)) then
		minetest.log("action", string.format("Tried to set tween to loop %d times, the tween will execute at least once.", loop))
	end

	-- callbacks are optional.
	if (callbacks == nil) then
		callbacks = {}
	end

	-- make the tween table.
	local tween = {
		method = method,
		movement = movement,
		time = time,

		timer = 0.0,
		loop = loop,
		on_start = callbacks.on_start,
		on_stop = callbacks.on_stop,
		on_step = callbacks.on_step,

		-- start the tween to work by adding it from the active list.
		start = function (_)

			if (_:is_running() == true) then
				minetest.log("action", "Tried to start tween twince!")
				return
			end

			table.insert(BeTweenApi.active_tweens, _)

			if (_.on_start ~= nil) then
				_.on_start(_)
			end

		end,

		-- stop the tween to work by removing it from the active list.
		--
		-- params:
		--	reset = false, if true it will restart the tween timer.
		stop = function (_, reset)
			local index = _:index()

			if (reset == nil) then
				reset = false
			end
			
			if (index == nil) then
				minetest.log("action", "Tried to stop tween when already stopped.")
				return
			end

			if (reset == true) then
				_.timer = 0
			end

			table.remove(BeTweenApi.active_tweens, index)

			if (_.on_stop ~= nil) then
				_.on_stop(_)
			end
		end,

		-- check if the tween is currently running.
		is_running = function (_)
			for i, tween in pairs(BeTweenApi.active_tweens) do
				if (tween == _) then
					return true
				end
			end

			return false
		end,

		-- get the running index of the tween, if the tween isn't running nil is returned.
		index = function (_)
			local index = 1
			
			for i, tween in pairs(BeTweenApi.active_tweens) do

				if (tween == _) then
					return index
				end

				index = index + 1
			end

			return nil
		end,
	}

	return tween
end

