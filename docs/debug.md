
# Debug tools

This is a table that contain debug visual stuff.

| Property | Description |
| -------- | ----------- |
| player_huds | List of all players that uses debug visuals, each item uses as a key the player name and as a value the title id of the hud and the tweens used for debug.

## debug:show(player_name: string)

Display all defined interpolations functions on screen with some animated images and the interpolation name.

*player_name* is the player wich will see the hud.

If the player has already the hud visible a log message will be printed instead.

## debug:hid(player_name: string)

Do the opposite of **debug:show**, will hide the hud visual.

*player_name* is the player wich the hud will be removed.

If the player has already the hud disabled a log message will be printed instead.
