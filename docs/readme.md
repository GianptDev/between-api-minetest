
# BeTween Api 1.2.1


______


## Commands

	/between <functions | tweens>

Show a debug hud to display a topic of the api, require debug privileges to be executed.


______


# Api

Every feature of this api is defined under the namespace *BeTweenApi*.


## Api : Functions

	version_name(): string

return the current version of the api as a string.

## Api : Functions : Math

	clamp(value: number, min: number, max: number): number

make the input value is in between of min and max only.

	wrap(value: number, min: number, max: number): number

make the value flow around the range of min and max.

	snap(value: number, snap: number): number

round the value to the nearest point of snap.

## Features

- [interpolation](interpolation.md)
- - here are stored all build-in functions.
- [Tween](tween.md)
- - This is an object able to get a configuration and run it to animate any movement automatically.
- - If you want to make animations see this feature.

