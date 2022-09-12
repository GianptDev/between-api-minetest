
# Tween

The tween object is a table that contain informations and callbacks about an interpolation animation that can be started or stopped with the tween itself.

	BeTweenApi.Tween(interpolation: function, movement: Movement, time: float, loop: bool, callbacks: TweenEvents) : Tween

This method will create a new Tween object.

- *interpolation* is the interpolation function to use, see [BeTweenApi.interpolation](interpolation.md) for functions to use.
You can define a custom function here too, make sure it ask for 3 argouments.

- *movement* movement data from the initial position to the end, see [Movement](#Movement)

- *time* is the time in seconds of how much this tween must run.

- *loop* set if the tween should loop his interpolation when he finish it, if is true the tween will loop forever, if is a number the tween will loop for the specified amount.

- *callbacks* contain all functions to execute on specific events of the tween, see [TweenEvents](#TweenEvents)


# Movement

This data contain initial and final position of the interpolation, every property with a default value does not require to be set.

| Property | Default | Description |
| -------- | ----------- | ------- |
| start: number | | is the initial position of the interpolation. |
| finish: number | | is the final position of the interpolation. |
| mirror: boolean | false | if enabled will make the interpolation move twince faster and use half of the time to repeat the animation in reverse. |


```lua
	{ start = 0, finish = 64 }	--- from 0 to 64 in time.
	{ start = 0, finish = 64, mirror = true }  --- same as before but also repeat in reverse.
	{ 0, 64 }  --- you can write it like this too.
	{ 0, 64, true }  --- same as second line.
```


# TweenEvents

These are all functions called on specific events, you give this table to a tween to make it execute your own code.

Each function receive the tween itself as first argoument, you can call any tween method from there.

| Callback | Description |
| - | - |
| on_start(tween: Tween) | Called when the Tween:start() is executed and the Tween will soon start to run his steps. |
| on_end(tween: Tween) | Called when the Tween:stop() is executed or when the tween has finished to run. |
| on_loop(tween: Tween) | Called every time the tween is looping, only called if loop is used.. |
| on_step(tween: Tween, value: number) | Called each step of the interpolation in the defined time, value is the result value. | 

```lua
	{
		on_start = function (tween)
			minetest.log("Hello Tween!")
		end,
		on_end = function (tween)
			minetest.log("Goodbye Tween!")
		end,
		on_loop = function (tween)
			minetest.log("Boom, 360 loop!")
		end,
		on_step = function (tween, value)
			--- do something with value.
		end,
	}
```

______


# Functions and methods


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


# Examples


```lua

	--- store the tween in a variable.
	local tween = InterpolationApi.tween(
		InterpolationApi.interpolation.quadratic_in,
		{ 0, 64, false },
		8.0, false,
		{
			on_start = function (tween)
				minetest.log("Interpolation start!")
			end,
			on_step = function (tween, value)
				minetest.log(tostring(value))
			end
		}
	)

	--- start the tween.
	tween:start()
```


```lua
	InterpolationApi.tween(
		InterpolationApi.interpolation.linear,	--- linear movement
		{ start = 0, finish = 64 },	--- from 0 to 64, don't mirror
		4.0,		--- in 4 seconds
		true,		--- repeat after the time
		{
			--- execute this method each step in time.
			on_step = function (tween, value)
				local item = player:hud_get(icon)
				player:hud_change(icon, "offset", { x = value, y = 32 })
			end
		}
	):start()	--- you can also start the tween without creating a variable.
```


______


# Extra

Extra informations about the Tween.

>## Tween loop
>
>The tween execute his loop using the server global steps, so his execution is synced to each player, but that's mean it will slow down when the server is lagging.

>## Tween list
>
>When a tween is running, by executing his :start() method) will insert itself in the *active_tweens* list inside the api.
>
>When the tween is stopped, paused, or has finished his interpolation job he will remove itself from the list.
>
>Tween in the list are only tween that **are** running.

