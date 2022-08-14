
# Interpolation Functions

**BeTweenApi.interpolation** is a table that contain interpolation functions, here are listed all of the and what their porpuse is for.

| Function | Description |
| -------- | ----------- |
| linear   | straight increment from x to y in time. |
| ease_in  | straight increment from x to y in time. |
| ease_out | movement increment slower from x to y in time. |
| ease_in_out | movement is faster between x to y but slow down on begin and end in time. |
| spike_linear | movement moves like linear, but reach his destination in half the time, the rest of the time is used to come back to the starting point. |
| spike_ease_in | movement moves like ease in, but reach his destination in half the time, the rest of the time is used to come back to the starting point. |
| spike_ease_out | movement moves like ease out, but reach his destination in half the time, the rest of the time is used to come back to the starting point. |
| spike_ease_in_out | movement moves like ease in out, but reach his destination in half the time, the rest of the time is used to come back to the starting point. |

______

Usage example:

	BeTweenApi.interpolation.linear(0, 4, 0.5) -- 2
	BeTweenApi.interpolation.ease_in(0, 8, 0.5) -- 2
	BeTweenApi.interpolation.ease_out(0, 8, 0.5) -- 4.5
