
Api
===


This is everything directly defined under the **BeTweenApi** namespace.


Functions
---------


.. py:function:: BeTweenApi.getName ()

	Return the name and version of the api, such as "BeTweenApi 1.0".

	:rtype: string


.. py:function:: BeTweenApi.lerp (x, y, t)

	Get the interpolated number between two values at a point.

	:param x: The first point.
	:type x: number
	:param y: The second point.
	:type y: number
	:param t: The position in range 0.0 to 1.0
	:type t: number
	:rtype: number


.. py:function:: BeTweenApi.wrap (value, min, max)

	Make the value flow around the range of min and max.

	:param value: the value to wrap.
	:type value: number
	:param min: start point when the value wrap after being over max.
	:type min: number
	:param max: final point before the value wrap and start to min again.
	:type max: number
	:rtype: number


.. py:function:: BeTweenApi.snap (value, snap)

	Round the value to the nearest point of snap.

	:param value: the value to snap.
	:type value: number
	:param snap: the size of the snap, should be positive and more than 0 .
	:type snap: number
	:rtype: number


.. py:function:: BeTweenApi.getTweenQueueCount ()

	Get the count of how many tweens are running in the server.

	:rtype: integer


.. py:function:: BeTweenApi.getTweenQueue ()

	Get a *copy* of the list that holds all currently running tweens.

	:rtype: table<integer, `Tween <#Tween>`_>


.. py:function:: BeTweenApi.newTween()

	Construct a new tween object.

	:rtype: `Tween <#Tween>`_


Classes
-------


.. py:class:: Tween

	The tween object itself, it contain all informations to perform an interpolation.

	:param timeDelay: Time in seconds to wait before the animation start after calling doPlay().
	:type timeDelay: number (0.0)
	:param timeDuration: Total duration of the animation in seconds.
	:type timeDuration: number (2.0)
	:param timeRestart: Time in seconds to wait before the animation restarts, only used when looping.
	:type timeRestart: number (0.0)
	:param timeScale: Multiplier speed of the animation.
	:type timeScale: number (1.0)
	:param animLoop: Set if the animation should loop when it finish.
	:type animLoop: boolean (false)
	:param animMirror: If enabled the interpolation will be twince faster and will use the other half to return back.
	:type animMirror: boolean (false)
	:param animReverse: If enabled the interpolation will start from 1 to 0, basically will play in reverse.
	:type animReverse: boolean (false)
	:param interpolationFunction: The interpolation function to use for the animation, if unset linear is used.
	:type interpolationFunction: fun(t: number) (nil)
	:param eventPlay: Called when the doPlay() method is called, the tween will start to animate the next tick.
	:type eventPlay: fun(self: BeTweenApi.Tween) (nil)
	:param eventStep: Called each interpolation step, the interpolated value is given.
	:type eventStep: fun(self: BeTweenApi.Tween, value: number) (nil)
	:param eventStop: Called when the tween is stopped by the doStop() method or because it finished his job.
	:type eventStop: fun(self: BeTweenApi.Tween) (nil)
	:param eventRestart: Called when the tween is looping the animation and it will restart the next step.task
	:type eventRestart: fun(self: BeTweenApi.Tween) (nil)

	.. note::
		When a Tween is running it will be put inside a list and processed in the server-side each globalstep, be aware of what or how much you update in eventStep()..


	.. py:function:: Tween:doPlay ([skip_delay])

		Insert the tween in the queue and soon it will start to animate, will return true on success.

		:param skip_delay: If enabled the delay time will be skipped.
		:type skip_delay: boolean (false)

		:rtype: boolean


	.. py:function:: Tween:doStop ([reset])

		Remove the tween from the queue and it will stop to animate, will return true on success.

		:param reset: If enabled the tween current step is resetted, if disabled this method will work as a pause.
		:type reset: boolean (false)

		:rtype: boolean


	.. py:function:: Tween:isPlaying ()

		Check if the tween is inside the queue and is currently interpolating an animation.

		:rtype: boolean


	.. py:function:: Tween:getIndex ()

		If the tween is running it will give his position inside the queue list.

		:rtype: integer | nil


	.. py:function:: Tween:setTime (time)

		Will change the current interpolation position of the tween, it will skip the begin delay.

		:param time: The time position to set in a range between 0.0 and 1.0, the begin of the interpolation and his end.
		:type time: number
	

	.. py:function:: Tween:getTime ()

		Get the current time position of the tween interpolation.

		:rtype: number
	

	.. py:function:: Tween:getStep ([time])

		Get the interpolated value of the interpolation, the result is calculated by the time and interpolation function in use.

		:param time: Custom time position of the interpolation, if unused the current tween time is used.
		:type time: number

		:rtype: number


Constants
---------


.. py:attribute:: BeTweenApi.Interpolations

	This is a collection of easing functions build in the library by default, you can open the script and see how many are defined.

	:type: table<string, function>



.. note::
	This example will create a tween and make him print each step.

.. code-block:: lua

	--- create a new tween.
	local t = BeTweenApi.newTween()

	--- configure his properties.
	t.timeDelay = 1.0
	t.timeDuration = 4.0

	--- override his events.

	function t:eventPlay()
		minetest.log("error", "Starting the tween!")
	end

	function t:eventStep (step)
		minetest.log("error", tostring(step))
	end

	--- start the tween.
	tween:doPlay()

.. note::
	This example will show to each player that join an animated hud with the list of all build-in interpolation methods.

.. code-block:: lua

	local playerHuds = {}

	minetest.register_on_joinplayer(
		function(ObjectRef, last_login)
			local i = 1
			for name, interpolation in pairs(BeTweenApi.Interpolations) do
				local tag = ObjectRef:hud_add({
					hud_elem_type = "text",
					text      = name,
					position = { x = 0, y = 0 },
					offset = { x = 32, y = 24 * i },
					alignment = { x = 1, y = 0 },
					number    = 0xFFFFFF,
					style     = 1,
				})

				local icon = ObjectRef:hud_add(
					{
						hud_elem_type = "image",
						text      = "heart.png",
						scale = { x = 1, y = 1 },
						offset = { x = 16, y = 24 * i },
						position = { x = 0, y = 0 },
						alignment = { x = 0, y = 0 },
					}
				)

				local t = BeTweenApi.newTween()
				t.timeDelay = 1.0
				t.timeDuration = 4.0
				t.animLoop = true
				t.animMirror = true
				t.interpolation = interpolation

				function t:eventStep (step)
					local item = ObjectRef:hud_get(icon)
					ObjectRef:hud_change(icon, "offset", { x =  BeTweenApi.lerp(16, 300, step), y = item.offset.y })
				end

				t:doPlay()
				playerHuds[ObjectRef:get_player_name()] = {
					icon = icon,
					tag = tag,
					tween = t
				}

				i = i + 1
			end
		end
	)

	minetest.register_on_leaveplayer(
		function(ObjectRef, timed_out)

			local name = ObjectRef:get_player_name()

			if playerHuds[name] then
				playerHuds[name].tween:doStop()
				ObjectRef:hud_remove(playerHuds[name].tag)
				ObjectRef:hud_remove(playerHuds[name].icon)
				playerHuds[name] = nil 
			end
		end
	)

