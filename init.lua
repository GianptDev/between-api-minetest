

--- -----------------------------------------------------------


--- @package BeTweenApi
--- @license MIT
--- @author GianptDev (_gianpy_)
--- @release 1.2.1
--- @meta


--- -----------------------------------------------------------


--- the table that contain everything about BeTween Api
--- @class BeTweenApi
BeTweenApi = {}


--- -----------------------------------------------------------


--- get the folder name of the current mod.
--- @type string
local path = minetest.get_modpath(minetest.get_current_modname())


-- import all the content.
dofile(path .. "/src/functions.lua")
dofile(path .. "/src/interpolation.lua")

--- @type table<Tween>[]
local active_tweens = dofile(path .. "/src/tween.lua")

dofile(path .. "/src/debug.lua")


--- -----------------------------------------------------------


--- main loop of the api.
--- @param dtime number
local function A (dtime)

	--- tween working loop.
	--- @param tween Tween
	for _, tween in pairs(active_tweens) do

		-- calculate the position in time from the current to the target,
		-- make sure to clamp the range.
		local t = tween.timer / tween.time
		t = (t < 0.0) and 0.0 or (t > 1.0) and 1.0 or t

		if (t >= 0.0) then

			-- store time to give to the function, it may get modifications.
			local f_t = t

			-- check if mirror is enabled.
			f_t = (tween.movement[3] == true)
				--- if enabled make the movement twince faster and use the left time to turn back.
				and ((f_t >= 0.5) and ((1.0 - f_t) / 0.5) or f_t * 2)
				--- if not enabled use normal timer.
				or f_t

			-- calculate the interpolated value.
			local value = tween.interpolation(
				tween.movement[1], tween.movement[2], f_t
			)

			-- call the step of the tween.
			if (tween.on_step ~= nil) then
				tween.on_step(tween, value)
			end
		end

		-- action to execute when the tween has finished his job.
		if (t == 1.0) then

			-- some extra millisecons may be inside the timer, this will remove them.
			tween.timer = tween.movement[2]

			-- if the tween require to loop, reset the timer.
			if ((tween.loop == true) or ((type(tween.loop) == "number") and (tween.loop > 1))) then
				tween.timer = 0.0

				-- if number is used, count down for the end.
				if (type(tween.loop) == "number") then
					tween.loop = tween.loop - 1
				end

				--- call the loop event.
				if (tween.on_loop ~= nil) then
					tween.on_loop(tween)
				end
			
			-- if the tween need to stop, stop it.
			else
				tween:stop(true)
			end
		
		-- if the job isn't finished, continue to run the timer.
		else
			-- merge the current timer with all the time has passed from the previus step.
			tween.timer = tween.timer + dtime
		end

	end
end


-- register the global step that will handle all running tweens.
minetest.register_globalstep(A)


--- -----------------------------------------------------------

