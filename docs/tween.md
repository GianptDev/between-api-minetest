
# Tween

The tween object is a table that contain informations and callbacks about an interpolation animation that can be started or stopped with the tween itself.

	BeTweenApi.tween(
		interpolation: function,
		movement: {
			number,		-- start value
			number,		-- final value
			boolean = false	-- mirror mode
			},
		time: float,
		loop: bool | int,
		callbacks: table
		) : Tween

This method will create a new Tween object.

- *interpolation* is the interpolation function to use, see [BeTweenApi.interpolation](interpolation.md) for functions to use.
You can define a custom function here too, make sure it ask for 3 argouments.

- *movement* a list that contain the start position and the destination of the interpolation, the third argoument is a boolean and specify if the interpolation should mirror.

- - When mirror is enabled the interpolation will become twince faster and reach the destination in half of the time, the other half is used to repeat the interpolation but reversed (from end to start).

- *time* is the time in seconds of how much this tween must run.

- *loop* set if the tween should loop his interpolation when he finish it, if is true the tween will loop forever, if is a number the tween will loop for the specified amount.

- *callbacks* is a list of methods called on Tween events, each callback give the tween itself.

| Callback | Description |
| - | - |
| on_start(tween: Tween) | Called when the Tween:start() is executed and the Tween will soon start to run his steps. |
| on_end(tween: Tween) | Called when the Tween:stop() is executed or when the tween has finished to run. |
| on_loop(tween: Tween) | Called every time the tween is looping, only called if loop is used.. |
| on_step(value: number, tween: Tween) | Called each step of the interpolation in the defined time, value is the result value. | 

	Tween:start()

This method will start the tween by adding it in the *active_tweens* list, the global step will handle the process of time in the tween.

To make sure the Tween use the 100% of the assigned interpolation function it will make sure to process step 0.0 and 1.0 (the absolute end and start of the animation).

Everything in between of the interpolation time is handled by the server time using global steps.

After adding in the list the Tween is seen as "running", if the Tween is started while is already running a message log will be printed instead.

After adding to the list the **Tween:on_start()** callback is called.

	Tween:stop(reset: bool = false)

This method will stop the tween by removing it from the *active_tweens* list.

If *reset* is true the current position in time of the Tween is resetted to 0, if is false the Tween is just paused.

	Tween:is_running(): bool

Check if the current Tween is running inside the list, return true if it is or false if not.

	Tween:index(): int | nil

Get the index position of the Tween inside the list, if the Tween isn't running *nil* is returned.

______

Usage example:

	local tween = InterpolationApi.tween(
		InterpolationApi.interpolation.linear,	-- linear movement
		{ 0, 64, false },	-- from 0 to 64, don't mirror
		4.0,		-- in 4 seconds
		true,		-- repeat after the time
		{
			-- execute this method each step in time.
			on_step = function (step, tween)
				local item = player:hud_get(icon)
				player:hud_change(icon, "offset", { x = step, y = 32 })
			end
		}
	)

	tween:start()	-- make sure to start the tween.
