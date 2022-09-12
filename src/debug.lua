

--- -----------------------------------------------------------


--- @meta
--- debug features for the clients, only if they have the debug privileges.


--- -----------------------------------------------------------


--- list of all players that are using the debug functions view.
--- @type { [string]: any }
local hud_interpolation = {}


--- list of all players that are using the debug tween view.
--- @type { [string]: any }
local hud_running_tweens = {}


--- -----------------------------------------------------------


--- main loop of debug updates.
local function global_step (time)
	for plr_name, visual in pairs(hud_running_tweens) do
		local player = minetest.get_player_by_name(plr_name)

		for _, id in pairs(visual.update) do
			player:hud_remove(id)
		end

		local index = 0
		local rows = 3
		local show_max = 17
		visual.update = {}

		--- @param tween Tween
		for _, tween in ipairs(BeTweenApi.get_active_tweens()) do

			if (index < show_max) then
				table.insert_all(visual.update,
					{
						player:hud_add({
							hud_elem_type = "text",
							text      = string.format("[%2d] ~ %p",_ , tween),
							position = { x = 0.5, y = 0 },
							offset = {
								x = (186 * (index % rows)),
								y = 88 + (48 * math.floor(index / rows))
							},
							alignment = { x = 1, y = 0 },
							number    = 0xFFFFFF,
							style     = 1,
						}),
						player:hud_add({
							hud_elem_type = "text",
							text      = string.format("%.2f ~ %.2f", tween.timer, tween.time),
							position = { x = 0.5, y = 0 },
							offset = {
								x = (186 * (index % rows)),
								y = 112 + (48 * math.floor(index / rows))
							},
							alignment = { x = 1, y = 0 },
							number    = 0xFFFFFF,
						}),
					}
				)
			end

			index = index + 1
		end

		if (index > show_max) then
			table.insert(
				visual.update,
				player:hud_add({
					hud_elem_type = "text",
					text      = string.format("+%d more...", index - show_max),
					position = { x = 0.5, y = 0 },
					offset = {
						x = (186 * (show_max % rows)),
						y = 88 + (48 * math.floor(show_max / rows))
					},
					alignment = { x = 1, y = 0 },
					number    = 0xFFFFFF,
					style     = 1,
				})
			)
		end

		player:hud_change(visual.tween_title, "text", string.format("Running tweens [%d]", index))
	end
end


--- this functions is to make sure all debug stuff is cleared when a player exit.
local function player_leave (player, time_out)
	local plr_name = player:get_player_name()
	local hud_interpolation = hud_interpolation[plr_name]

	hud_interpolation[plr_name] = nil
	hud_running_tweens[plr_name] = nil

	if (hud_interpolation ~= nil) then
		for _, tween in pairs(hud_interpolation.tweens) do
			tween:stop()
		end
	end
end


minetest.register_globalstep(global_step)
minetest.register_on_leaveplayer(player_leave)


--- -----------------------------------------------------------


--- show the list of all easing functions to this player.
--- @param player_name string
local function show_functions (player_name)

	-- hud already enabled.
	if (hud_interpolation[player_name] ~= nil) then
		return
	end

	local player = minetest.get_player_by_name(player_name)
	local index = 0
	local start, finish = 32, 256
	local scale = { x = 1, y = 1}

	local visual = {
		tweens = {},	-- contain list of interpolation name and hud items used.
	}

	hud_interpolation[player_name] = visual

	for _, interpolation in pairs(BeTweenApi.interpolation) do
		local y = 64 + (24 * index)

		local start_icon = player:hud_add({
			hud_elem_type = "image",
			text      = "between_ball.png^[multiply:#0000ff",
			scale = scale,
			offset = { x = start, y = y },
			position = { x = 0, y = 0 },
			alignment = { x = 0, y = 0 },
		})

		local stop_icon = player:hud_add({
			hud_elem_type = "image",
			text      = "between_ball.png^[multiply:#0000ff",
			scale = scale,
			offset = { x = finish, y = y },
			position = { x = 0, y = 0 },
			alignment = { x = 0, y = 0 },
		})

		local icon = player:hud_add({
			hud_elem_type = "image",
			text      = "between_prism.png^[multiply:#ff0000",
			scale = scale,
			offset = { x = 32, y = y },
			position = { x = 0, y = 0 },
			alignment = { x = 0, y = 0 },
		})

		local title = player:hud_add({
			hud_elem_type = "text",
			text      = tostring(_),
			position = { x = 0, y = 0 },
			offset = { x = finish + 32, y = y },
			alignment = { x = 1, y = 0 },
			number    = 0xFFFFFF,
			style     = 1,
		})

		--- make the loop animation for each function.
		visual.tweens[_] = BeTweenApi.Tween(
			interpolation,
			{ start, finish },
			4.0, true,
			{
				on_step = function (tween, step)
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

	--- make the cool title
	visual.title = player:hud_add({
		hud_elem_type = "text",
		text      = string.format("BeTween Api Debug : Easing functions : %d", index + 1),
		position = { x = 0, y = 0 },
		offset = { x = start, y = 32 },
		alignment = { x = 1, y = 0 },
		number    = 0xFFFFFF,
		style     = 1,
	})

	--- start all tweens
	for _, tween in pairs(visual.tweens) do
		tween:start()
	end
end


--- hide the list of all defined easing functions from this player.
--- @param player_name string
local function hide_functions (player_name)

	-- hud already disabled.
	if (hud_interpolation[player_name] == nil) then
		return
	end

	local player = minetest.get_player_by_name(player_name)

	player:hud_remove(hud_interpolation[player_name].title)
	for _, tween in pairs(hud_interpolation[player_name].tweens) do
		tween:stop()
	end

	hud_interpolation[player_name] = nil
end


--- show the list of all active tweens to this player.
--- @param player_name string
local function show_tweens (player_name)

	-- hud already enabled.
	if (hud_running_tweens[player_name] ~= nil) then
		return
	end

	local player = minetest.get_player_by_name(player_name)

	hud_running_tweens[player_name] = {
		title = player:hud_add({
			hud_elem_type = "text",
			text      = "BeTween Api Debug : Tweens",
			position = { x = 0.5, y = 0 },
			offset = { x = 0, y = 32 },
			alignment = { x = 1, y = 0 },
			number    = 0xFFFFFF,
			style     = 1,
		}),
		tween_title = player:hud_add({
			hud_elem_type = "text",
			position = { x = 0.5, y = 0 },
			offset = { x = 0, y = 64 },
			alignment = { x = 1, y = 0 },
			number    = 0xFFFFFF,
			style     = 1,
		}),
		update = {},
	}	
end


--- hide the list of all active tweens from this player.
--- @param player_name string
local function hide_tweens (player_name)
	local visual = hud_running_tweens[player_name]

	-- hud already disabled.
	if (visual == nil) then
		return
	end

	local player = minetest.get_player_by_name(player_name)

	player:hud_remove(visual.title)
	player:hud_remove(visual.tween_title)

	for _, id in pairs(visual.update) do
		player:hud_remove(id)
	end

	hud_running_tweens[player_name] = nil
end


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
			if (hud_interpolation[name] == nil) then
				show_functions(name)
			else
				hide_functions(name)
			end

			return true
		
		elseif (param == "tweens") then
			if (hud_running_tweens[name] == nil) then
				show_tweens(name)
			else
				hide_tweens(name)
			end

			return true
		end
	end

	--- Give the details of the current version.
	return true, "BeTween Api " .. BeTweenApi.version_name()
end


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

