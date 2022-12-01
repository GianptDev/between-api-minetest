
Interpolation
===================================


BeTween Api define some default interpolations to play around, these are stored inside the table *BeTweenApi.interpolations*, this table uses a string name as a key and a function as a value.

Each function require 3 inputs like this:


.. note::
	Custom interpolation functions will too use these amount of argouments and value return.

.. py:function:: function (x, y, t)

	:param x: The start position of the interpolation.
	:type x: number
	:param y: The final position of the interpolation.
	:type y: number
	:param t: The position in time of the interpolation, this must be a range from 0.0 to 1.0 .
	:type t: number


Inside the table you will find these values:


.. list-table:: BeTweenApi.interpolation<string, function>
	:header-rows: 1

	* - Name
	  - Description

	* - linear
	  - straight increment from x to y in time.

	* - quadratic_in
	  - movement increment faster from x to y in time.

	* - quadratic_out
	  - movement increment slower from x to y in time.

	* - quadratic_in_out
	  - movement is faster between x to y but slow down on begin and end in time.

	* - cubic_in
	  - movement increment faster from x to y in time.

	* - cubic_out
	  - movement increment slower from x to y in time.

	* - cubic_in_out
	  - movement is faster between x to y but slow down on begin and end in time.

	* - quartic_in
	  - movement increment faster from x to y in time.

	* - quartic_out
	  - movement increment slower from x to y in time.

	* - quartic_in_out
	  - movement is faster between x to y but slow down on begin and end in time.

	* - elastic
	  - movement jump from x to y like an elastic, movement is very fast but slow down in time.

	* - sinusoidal_in
	  - movement increment faster from x to y in time, the movement has the shape of a curve.

	* - sinusoidal_out
	  - movement increment faster from x to y in time, the movement has the shape of a curve.

	* - sinusoidal_in_out
	  - movement is faster between x to y but slow down on begin and end in time, the movement has the shape of a curve.

	* - circular_in
	  - movement increment faster esponentially from x to y in time.

	* - circular_out
	  - movement increment slower esponentially from x to y in time.

	* - circular_in_out
	  - movement increment slower from the start to the end but speed up esponentially in the middle.


Examples
--------

.. code-block:: lua

	--- you can get the list and put it in a variable is you wish.
	local interpolations = BeTweenApi.interpolation

	--- range from 0.0 to 1.0,
	--- the Tween uses (current_time / total_time) to get the range.
	local time = 0.5

	--- same time, different values.
	interpolations.linear(0, 8, time) -- 4
	interpolations.quadratic_in(0, 8, time) -- 2
	interpolations.quadratic_out(0, 8, time) -- 4.5
