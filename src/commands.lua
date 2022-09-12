

--- -----------------------------------------------------------


--- @meta
--- this module implements debug commands, that's it.


--- -----------------------------------------------------------


--- @param name string
--- @param param string
local function between (name, param)
	local player = minetest.get_player_by_name(name)
	
	--- check if the command is called from a player or from the server.
	--- only players can have the debug hud.
	if (player ~= nil) then
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
	end

	--- Give the details of the current version.
	return true, "BeTween Api " .. BeTweenApi.version_name()
end


--- -----------------------------------------------------------


-- register simple debug command.
minetest.register_chatcommand(
	"between",
	{
		params = "[ functions | tweens ]",
		description = "Display current version of the api or show a debug hud about a topic, see the parameters for the topics.",
		privs = {
			debug = true,
		},
		func = between
	}
)


--- -----------------------------------------------------------

