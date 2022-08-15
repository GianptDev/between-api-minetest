

-- contain debug related content.
BeTweenApi.debug = {

	-- list of all players that are using the debug functions view.
	hud_interpolation = {},

	-- list of all players that are using the debug tween view.
	hud_running_tweens = {},

	-- show the list of all easing functions to this player.
	show_functions = function (_, player_name)

		-- hud already enabled.
		if (_.hud_interpolation[player_name] ~= nil) then
			return
		end

		local player = minetest.get_player_by_name(player_name)
		local index = 0
		local start, finish = 32, 256
		local scale = { x = 2, y = 2}

		local visual = {
			tweens = {},
		}

		_.hud_interpolation[player_name] = visual

		visual.title = player:hud_add({
			hud_elem_type = "text",
			text      = "BeTween Api Debug : Easing functions",
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

		for _, tween in pairs(visual.tweens) do
			tween:start()
		end
	end,

	-- hide the list of all defined easing functions from this player.
	hide_functions = function (_, player_name)

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
	end,

	-- show the list of all active tweens to this player.
	show_tweens = function (_, player_name)

		-- hud already enabled.
		if (_.hud_running_tweens[player_name] ~= nil) then
			return
		end

		local player = minetest.get_player_by_name(player_name)

		_.hud_running_tweens[player_name] = {
			title = {
				player:hud_add({
					hud_elem_type = "text",
					text      = "BeTween Api Debug : Running tweens",
					position = { x = 0.5, y = 0 },
					offset = { x = 0, y = 32 },
					alignment = { x = 1, y = 0 },
					number    = 0xFFFFFF,
					style     = 1,
				}),
				player:hud_add({
					hud_elem_type = "text",
					text      = "tween",
					position = { x = 0.5, y = 0 },
					offset = { x = 0, y = 64 },
					alignment = { x = 1, y = 0 },
					number    = 0xFFFFFF,
					style     = 1,
				}),
				player:hud_add({
					hud_elem_type = "text",
					text      = "method",
					position = { x = 0.5, y = 0 },
					offset = { x = 128, y = 64 },
					alignment = { x = 1, y = 0 },
					number    = 0xFFFFFF,
					style     = 1,
				}),
				player:hud_add({
					hud_elem_type = "text",
					text      = "timer",
					position = { x = 0.5, y = 0 },
					offset = { x = 240, y = 64 },
					alignment = { x = 1, y = 0 },
					number    = 0xFFFFFF,
					style     = 1,
				})
			},
			update = {},
		}
	end,

	-- hide the list of all active tweens from this player.
	hide_tweens = function (_, player_name)

		-- hud already disabled.
		if (_.hud_running_tweens[player_name] == nil) then
			return
		end

		local player = minetest.get_player_by_name(player_name)

		for _, id in pairs(_.hud_running_tweens[player_name].title) do
			player:hud_remove(id)
		end

		for _, id in pairs(_.hud_running_tweens[player_name].update) do
			player:hud_remove(id)
		end

		_.hud_running_tweens[player_name] = nil
	end
}


minetest.register_globalstep(
	function (_)
		for plr_name, visual in pairs(BeTweenApi.debug.hud_running_tweens) do
			local player = minetest.get_player_by_name(plr_name)

			for _, id in pairs(visual.update) do
				player:hud_remove(id)
			end

			local index = 1
			visual.update = {}

			for _, tween in pairs(BeTweenApi.active_tweens) do

				table.insert_all(visual.update,
					{
						player:hud_add({
							hud_elem_type = "text",
							text      = string.format("%d ~ %p",_ , tween),
							position = { x = 0.5, y = 0 },
							offset = { x = 0, y = 64 + (24 * index) },
							alignment = { x = 1, y = 0 },
							number    = 0xFFFFFF,
							style     = 2,
						}),
						player:hud_add({
							hud_elem_type = "text",
							text      = string.format("%p", tween.method),
							position = { x = 0.5, y = 0 },
							offset = { x = 128, y = 64 + (24 * index) },
							alignment = { x = 1, y = 0 },
							number    = 0xFFFFFF,
							style     = 2,
						}),
						player:hud_add({
							hud_elem_type = "text",
							text      = string.format("%.2f ~ %.2f", tween.timer, tween.time),
							position = { x = 0.5, y = 0 },
							offset = { x = 292, y = 64 + (24 * index) },
							alignment = { x = 1, y = 0 },
							number    = 0xFFFFFF,
							style     = 1,
						}),
					}
				)

				if (tween.loop == true) then
					table.insert(visual.update,
						player:hud_add({
							hud_elem_type = "text",
							text      = "∞",
							position = { x = 0.5, y = 0 },
							offset = { x = 240, y = 64 + (24 * index) },
							alignment = { x = 1, y = 0 },
							number    = 0xFFFFFF,
							style     = 1,
						})
					)
				elseif (type(tween.loop) == "number") then
					table.insert(visual.update,
						player:hud_add({
							hud_elem_type = "text",
							text      = tostring(tween.loop),
							position = { x = 0.5, y = 0 },
							offset = { x = 240, y = 64 + (24 * index) },
							alignment = { x = 1, y = 0 },
							number    = 0xFFFFFF,
							style     = 1,
						})
					)
				end

				index = index + 1
			end
		end
	end
)

