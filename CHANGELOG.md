
# 1.0

- Some interpolation methods implemented.
- Tween object implemented.
- /between command registered to display interpolaton debug info.

# 1.1

- Made the interpolation hud use less space on screen.
- split code into multiple files inside the src/ folder, init.lua is now inteded to be used just to start execution.
- changed the argouments of BeTween.tween(), they are documented in the docs.
- /between command now require debug privileges and can display multiple things.
- changed the logo.


# 1.1.1

- added javadocs in code definitions.
- debug function list now show functions count and replaced the icon of the preview from the heart in favor of geometry dash characters.
- - debug heart icon RIP (2022-2022)
- debug running tweens now look nicer and prevent to display too much info (max 20 tweens on screen) because it could lead to lag.
- tweens output a server log message when started or stopped, the message is not visible to the players.
- replacing all 3.14 number in favor of math.pi -_-
- tweens now have a new callback event:
- - on_loop
- added interpolation functions:
- - elastic
- - cubic_in
- - cubic_out
- - cubic_in_out
- - sinusoidal_in
- - sinusoidal_out
- - sinusoidal_in_out
- - circular_in
- - circular_out
- - circular_in_out
- renamed functions:
- - ease_in				➡️ quadratic_in
- - ease_out			➡️ quadratic_out
- - ease_in_out			➡️ quadratic_in_out
- remove all spike_ functions in favor of a new property for the Tween.


# 1.2 (wip)

- creating icons to give the api a cooler look.
- - Inspirations:
- - https://github.com/godotengine/godot/blob/master/editor/icons/Tween.svg
- converted every function declaration in a more friendly way.

