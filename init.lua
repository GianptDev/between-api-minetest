
-- BeTween Api 1.0
-- made by GianptDev (_gianpy_)


-- this table contain interpolation methods and the logic to make tween works.
BeTweenApi = {

	-- This is a list of all active tween that are processed in the server.
	active_tweens = {},


	-- contain debug related content.
	debug = {

		-- list of all players that are using the debug hud.
		player_huds = {},

		-- show the debug hud to this specific player.
		show_functions = function (_, player_name)

			if (_.player_huds[player_name] ~= nil) then
				minetest.log("action", string.format("BeTween: The player '%s' has already the debug hud enabled.", player_name))
				return
			end

			local player = minetest.get_player_by_name(player_name)
			local index = 0
			local start, finish = 32, 400
			local scale = { x = 2, y = 2}

			local visual = {
				tweens = {},
			}

			_.player_huds[player_name] = visual
	
			visual.title = player:hud_add({
				hud_elem_type = "text",
				text      = "BeTween Api Debug : interpolation list",
				position = { x = 0, y = 0 },
				offset = { x = start, y = 32 },
				alignment = { x = 1, y = 0 },
				number    = 0xFFFFFF,
				style     = 1,
			})

			for _, interpolation in pairs(BeTweenApi.interpolation) do
				local y = 64 + (24 * index)

				local start_icon = player:hud_add({
					hud_elem_type = "image",
					text      = "heart.png^[colorize:#0000FF",
					scale = scale,
					offset = { x = start, y = y },
					position = { x = 0, y = 0 },
					alignment = { x = 0, y = 0 },
				})
	
				local stop_icon = player:hud_add({
					hud_elem_type = "image",
					text      = "heart.png^[colorize:#0000FF",
					scale = scale,
					offset = { x = finish, y = y },
					position = { x = 0, y = 0 },
					alignment = { x = 0, y = 0 },
				})
	
				local icon = player:hud_add({
					hud_elem_type = "image",
					text      = "heart.png",
					scale = scale,
					offset = { x = 32, y = y },
					position = { x = 0, y = 0 },
					alignment = { x = 0, y = 0 },
				})
	
				local title = player:hud_add({
					hud_elem_type = "text",
					text      = tostring(_),
					position = { x = 0, y = 0 },
					offset = { x = 460, y = y },
					alignment = { x = 1, y = 0 },
					number    = 0xFFFFFF,
					style     = 1,
				})
		
				visual.tweens[_] = BeTweenApi.tween(
					interpolation,
					start,
					finish,
					4.0,
					true,
					{
						on_step = function (step, tween)
							local item = player:hud_get(icon)
							player:hud_change(icon, "offset", { x = step, y = item.offset.y })
						end,

						on_stop = function (tween)
							player:hud_remove(start_icon)
							player:hud_remove(stop_icon)
							player:hud_remove(icon)
							player:hud_remove(title)
						end,
					}
				)
	
				index = index + 1
			end

			for _, tween in pairs(visual.tweens) do
				tween:start()
			end
		end,

		-- hide the debug hud from this specific player.
		hide_functions = function (_, player_name)

			if (_.player_huds[player_name] == nil) then
				minetest.log("action", string.format("BeTween: The player '%s' has already the debug hud disabled.", player_name))
				return
			end

			local player = minetest.get_player_by_name(player_name)

			player:hud_remove(_.player_huds[player_name].title)
			for _, tween in pairs(_.player_huds[player_name].tweens) do
				tween:stop()
			end

			_.player_huds[player_name] = nil
		end,

	},


	--[[
		contain a list of interpolation functions,
		each method require a start value, end value
		and the position in time from start to end of the interpolation (0.0 to 1.0).

			interpolation.linear(0, 8, 0.5) -- 4
			interpolation.ease_in(0, 8, 0.5) -- 2
			interpolation.ease_out(0, 8, 0.5) -- 4.5
	]]
	interpolation = {

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
	},


	--[[
		create a new tween and retturn it, you can choose the interpolation method to use, 
		the initial and final value, the time it require to reach the end, if it must loop 
		(by default false) and callbacks on 3 events, each event give as an argoument the tween.

			on_start(tween)	-- executed the start method.
			on_end(tween)	-- executed the stop method or the tween has ended.
			on_step(value, tween) -- called every time step of the function.
	]]
	tween = function (method, from, to, time, loop, callbacks)

		if (callbacks == nil) then
			callbacks = {}
		end

		local tween = {
			method = method,
			value_start = from,
			value_end = to,
			time_end = time,

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
}


-- register the global step that will handle all running tweens.
minetest.register_globalstep(
	function(dtime)
		for _, tween in pairs(BeTweenApi.active_tweens) do

			-- calculate the position in time from the current to the target,
			-- make sure to clamp the range.
			local t = tween.timer / tween.time_end

			if (t > 1.0) then
				t = 1.0
			end

			-- calculate the interpolated value.
			local value = tween.method(
				tween.value_start,
				tween.value_end,
				t
			)

			-- call the step of the tween.
			if (tween.on_step ~= nil) then
				tween.on_step(value, tween)
			end

			-- action to execute when the tween has finished his job.
			if (t == 1.0) then

				-- some extra millisecons may be inside the timer, this will remove them.
				tween.timer = tween.time_end

				-- if loop is disabled, stop the timer and reset it,
				-- if enabled, simply restart the timer.
				if (tween.loop == false) then
					tween:stop(true)
				else
					tween.timer = 0
				end
			
			-- if the job isn't finished, continue to run the timer.
			else
				-- merge the current timer with all the time has passed from the previus step.
				tween.timer = tween.timer + dtime
			end

		end
	end
)


-- register simple debug command.
minetest.register_chatcommand(
	"between",
	{
		description = "Toggle the debug hud of this api to the calling player.",
		func = function (name, _)
			
			if (BeTweenApi.debug.player_huds[name] == nil) then
				BeTweenApi.debug:show_functions(name)
			else
				BeTweenApi.debug:hide_functions(name)
			end

			return true
		end
	}
)

