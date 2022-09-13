
Tween
===================================


.. py:class:: BeTweenApi.Tween(interpolation, movement, time, loop, callbacks)

	:param interpolation: the function to use got the animation behaviour.
	:type interpolation: function
	:param movement: the initial and final number to interpolate.
	:type movement: movement
	:param time: the duration of this interpolation in seconds.
	:type time: number
	:param loop: if *true* the animation will loop forever, if *false* the animation will not loop, if is an integer number the animation will loop only for that specific amount of times.
	:type loop: boolean | integer
	:param callbacks: methods called by the Tween on events.
	:type callbacks: callbacks | nil

.. note::
	the interpolation function can be one defined inside *BeTweenApi.interpolation* or a custom function, see interpolations.


Tables
--------

These are tables with specific content inside of them.

.. note::
	if a attribe starts with [*n*] it mean you can use that attribute by his name **or** the index inside the table.


.. py:class:: movement

	:ivar number [1]start:: initial value wich the Tween will start to interpolate.
	:ivar number [2]finish:: destination value wich the Tween will stop to interpolate.
	:ivar boolean | nil [3]mirror:: special flag that make the interpolation twince faster (will complete in half the time) and repeat the interpolation in reverse with the left time.


.. py:class:: callbacks

	.. py:function:: on_start(tween)

		called when the Tween starts.

		:param tween: the Tween that called this method.
		:type tween: Tween
	
	.. py:function:: on_stop(tween)

		called when the Tween has finished or has been stopped.

		:param tween: the Tween that called this method.
		:type tween: Tween
	
	.. py:function:: on_step(tween, value)

		called when the Tween is working each global step as fast as possible until the animation animation ends.

		:param tween: the Tween that called this method.
		:type tween: Tween
		:param value: the result value of the step.
	
	.. py:function:: on_loop(tween)

		if the Tween is allowed to loop this will be called each time the Tween has finished a loop and will restart again.

		:param tween: the Tween that called this method.
		:type tween: Tween


Methods
--------


These are all methods that can be called from a Tween object, use these to handle the Tween.


.. py:method:: Tween:start ()

	Start the execution of this tween, it will be added in the active_tweens list until stopped or finished.


.. py:method:: Tween:stop ([reset])

	stop the tween to work by removing it from the active list.

	:param reset: if true the tween timer is resetted, default is false.
	:type reset: boolean

	.. note::
		this method can be used to pause the Tween, because :start() will not reset the timer.


.. py:function:: Tween:is_running ()

	check if the tween is currently running his animation.

	:rtype: boolean


.. py:function:: Tween:index ()

	get the running index of the tween, if the tween isn't running nil is returned.

	:rtype: integer | nil


Examples
--------


.. note::
	This example will print the interpolated value, the Tween is started and will not loop.

.. code-block:: lua

	--- store the tween in a variable.
	local tween = BeTweenApi.Tween(
		BeTweenApi.interpolation.linear,
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


.. note::
	This example will show a hud element animated with the Tween.

.. code-block:: lua

	local function example (player, _)
		local start_x = 64

		local icon = player:hud_add({
			hud_elem_type = "image",
			text      = "between_prism.png",
			scale = { x = 1.0, y = 1.0 },
			offset = { x = start_x, y = 64 },
			position = { x = 0, y = 0 },
			alignment = { x = 0, y = 0 },
		})

		--- select a build-in interpolation from the api.
		local interpolation = BeTweenApi.interpolation.quadratic_in_out

		BeTweenApi.Tween(
			interpolation,
			{ start = start_x, finish = 256 },
			3.0,		--- animation duration.
			true,		--- repeat after the time
			{
				--- execute this method each step in time.
				on_step = function (tween, value)

					--- example of hud item animated with the Tween.
					player:hud_change(icon, "offset", { x = value, y = 32 })
				end
			}
		):start()	--- you can also start the tween without creating a variable.
	end

	minetest.register_on_joinplayer(example)

