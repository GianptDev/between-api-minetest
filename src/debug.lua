

--- -----------------------------------------------------------


--- NOTE
--- The list of running tween create and destroy hud elements every globalstep and this is the cause of flickering.
--- A different and better update logic would fix the problem.


--- -----------------------------------------------------------


--- contain debug related content.
--- @class Debug
BeTweenApi.debug = {

	--- list of all players that are using the debug functions view.
	hud_interpolation = {},

	--- list of all players that are using the debug tween view.
	hud_running_tweens = {},
}


--- -----------------------------------------------------------


local function A (_)
	for plr_name, visual in pairs(BeTweenApi.debug.hud_running_tweens) do
		local player = minetest.get_player_by_name(plr_name)

		for _, id in pairs(visual.update) do
			player:hud_remove(id)
		end

		local index = 0
		local rows = 3
		local show_max = 17
		visual.update = {}

		for _, tween in pairs(BeTweenApi.active_tweens) do

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


minetest.register_globalstep(A)


--- -----------------------------------------------------------


--- show the list of all easing functions to this player.
--- @param _ Debug
--- @param player_name string
function BeTweenApi.debug.show_functions (_, player_name)

	-- hud already enabled.
	if (_.hud_interpolation[player_name] ~= nil) then
		return
	end

	local player = minetest.get_player_by_name(player_name)
	local index = 0
	local start, finish = 32, 256
	local scale = { x = 1, y = 1}

	local visual = {
		tweens = {},	-- contain list of interpolation name and hud items used.
	}

	_.hud_interpolation[player_name] = visual

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

		visual.tweens[_] = BeTweenApi.tween(
			interpolation,
			{ start, finish },
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
--- @param _ Debug
--- @param player_name string
function BeTweenApi.debug.hide_functions (_, player_name)

	-- hud already disabled.
	if (_.hud_interpolation[player_name] == nil) then
		return
	end

	local player = minetest.get_player_by_name(player_name)

	player:hud_remove(_.hud_interpolation[player_name].title)
	for _, tween in pairs(_.hud_interpolation[player_name].tweens) do
		tween:stop()
	end

	_.hud_interpolation[player_name] = nil
end


--- show the list of all active tweens to this player.
--- @param player_name string
function BeTweenApi.debug.show_tweens (_, player_name)

	-- hud already enabled.
	if (_.hud_running_tweens[player_name] ~= nil) then
		return
	end

	local player = minetest.get_player_by_name(player_name)

	_.hud_running_tweens[player_name] = {
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
--- @param _ Debug
--- @param player_name string
function BeTweenApi.debug.hide_tweens (_, player_name)
	local visual = _.hud_running_tweens[player_name]

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

	_.hud_running_tweens[player_name] = nil
end


--- -----------------------------------------------------------

