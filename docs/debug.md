
# Debug tools

This is a table that contain debug visual stuff.

| Property | Description |
| -------- | ----------- |
| hud_interpolation | List of all players that use the function list hud. |
| hud_running_tweens | List of all players that use the tween list hud. |

	debug:show_functions(player_name: string)

Display all defined interpolations functions on screen with some animated images and the interpolation name.

*player_name* is the player wich will see the hud.

	debug:hide_functions(player_name: string)

Do the opposite of **debug:show_functions**, will hide the hud visual.

*player_name* is the player wich the hud will be removed.

	debug:show_tweens(player_name: string)

Display all running tweens in the game as a table, is coded a max amount of tweens that are displayed on screen (currently 20) to prevent too much stuff to be rendered on screen.

The first row is about the tween and his process index, the second row is about what interpolation method is used and the last row is about if the tween is looping and his current timer.

*player_name* is the player wich will see the hud.

	debug:hide_tweens(player_name: string)

Do the opposite of **debug:show_tweens**, will hide the hud visual.

*player_name* is the player wich the hud will be removed.
