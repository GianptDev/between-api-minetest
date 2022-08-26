
# BeTween Api 1.1.1

This api implements a simple table called *BeTweenApi*, this table contains everything implemented in this library.

| Property      | Description |
| ------------- | ----------- |
| *active_tweens* | This is a list of all running tweens, when a tween has started is inserted in this list until is stopped. |
| [interpolation](interpolation.md) | This is a table that contain a set of interpolation functions that can be used by tweens or directly. |
| [debug](debug.md) | This is a table that contain debug related stuff.


## Functions


| Name | Description |
| ---- | ----------- |
| version_name() : string | This method return the current version of the api. |


## Objects

| Name | Description |
| ---- | ----------- |
| [Tween](tween.md) | This is the tween itself, contain all the stuff you need for time interpolation. |


## Commands

| Name | Description |
| ---- | ----------- |
| /between | Show a debug hud to display a topic of the api, require debug privileges to be executed. |

