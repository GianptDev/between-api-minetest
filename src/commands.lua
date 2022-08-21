

-- register simple debug command.
minetest.register_chatcommand(
	"between",
	{
		params = "[ functions | tweens ]",
		description = "Display current version of the api or show a debug hud about a topic, see the parameters for the topics.",
		privs = {
			debug = true,
		},
		func = function (name, param)
			param = string.lower(param)

			if (param == "functions") then
				if (BeTweenApi.debug.hud_interpolation[name] == nil) then
					BeTweenApi.debug:show_functions(name)
				else
					BeTweenApi.debug:hide_functions(name)
				end

				return true
			
			elseif (param == "tweens") then
				if (BeTweenApi.debug.hud_running_tweens[name] == nil) then
					BeTweenApi.debug:show_tweens(name)
				else
					BeTweenApi.debug:hide_tweens(name)
				end

				return true
			end

			return true, "BeTween Api v1.2 (wip)"
		end
	}
)

