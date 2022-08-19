
# Interpolation Functions

**BeTweenApi.interpolation** is a table that contain interpolation functions, here are listed all of the and what their porpuse is for.

Each function require a start and end movement to interpolate and the position in time, or something like this:

	function (start: number, end: number, time: float) : number

Currently interpolation can be done only with numbers (float and integer).

| Function | Description |
| -------- | ----------- |
| linear   | straight increment from x to y in time. |
| quadratic_in  | straight increment from x to y in time. |
| quadratic_out | movement increment slower from x to y in time. |
| quadratic_in_out | movement is faster between x to y but slow down on begin and end in time. |
| cubic_in | movement increment faster from x to y in time. |
| cubic_out | movement increment slower from x to y in time. |
| cubic_in_out | movement is faster between x to y but slow down on begin and end in time. |
| quartic_in | movement increment faster from x to y in time. |
| quartic_out | movement increment slower from x to y in time. |
| quartic_in_out | movement is faster between x to y but slow down on begin and end in time. |
| elastic | movement jump from x to y like an elastic, movement is very fast but slow down in time. |
| sinusoidal_in | movement increment faster from x to y in time, the movement has the shape of a curve. |
| sinusoidal_out | movement increment faster from x to y in time, the movement has the shape of a curve. |
| sinusoidal_in_out | movement is faster between x to y but slow down on begin and end in time, the movement has the shape of a curve. |
| circular_in | movement increment faster esponentially from x to y in time. |
| circular_out | movement increment slower esponentially from x to y in time. |
| circular_in_out | movement increment slower from the start to the end but speed up esponentially in the middle. |

______

Usage example:

	BeTweenApi.interpolation.linear(0, 4, 0.5) -- 2
	BeTweenApi.interpolation.quadratic_in(0, 8, 0.5) -- 2
	BeTweenApi.interpolation.quadratic_out(0, 8, 0.5) -- 4.5
