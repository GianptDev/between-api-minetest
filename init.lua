

--- -----------------------------------------------------------


--- @package BeTweenApi
--- @author GianptDev
--- @release 1.2


--- -----------------------------------------------------------


--- the table that contain everything about BeTween Api
--- @class BeTweenApi
BeTweenApi = {}


--- @return string
--- return the current version as a string.
function BeTweenApi.version_name ()
	return "1.2a"
end


--- -----------------------------------------------------------


--- get the folder name of the current mod.
--- @type string
local path = minetest.get_modpath(minetest.get_current_modname())


-- import all the content.
dofile(path .. "/src/interpolation.lua")
dofile(path .. "/src/tween.lua")
dofile(path .. "/src/globalsteps.lua")
dofile(path .. "/src/commands.lua")
dofile(path .. "/src/debug.lua")


--- -----------------------------------------------------------

