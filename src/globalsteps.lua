

-- register the global step that will handle all running tweens.
minetest.register_globalstep(
	function(dtime)
		for _, tween in pairs(BeTweenApi.active_tweens) do

			-- calculate the position in time from the current to the target,
			-- make sure to clamp the range.
			local t = tween.timer / tween.time

			if (t >= 0.0) then
				if (t > 1.0) then
					t = 1.0
				end
	
				-- calculate the interpolated value.
				local value = tween.method(
					tween.movement[1],
					tween.movement[2],
					t
				)
	
				-- call the step of the tween.
				if (tween.on_step ~= nil) then
					tween.on_step(value, tween)
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
)

