
# BeTween Api

This api implements a simple table called *BeTweenApi*, this table contains everything implemented in this library.

[![ContentDB](https://content.minetest.net/packages/_gianpy_/api_between/shields/downloads/)](https://content.minetest.net/packages/_gianpy_/api_between/)

![](https://img.shields.io/github/license/GianptDev/between-api-minetest)

| Property      | Description |
| ------------- | ----------- |
| *active_tweens* | This is a list of all running tweens, when a tween has started is inserted in this list until is stopped. |
| [interpolation](interpolation.md) | This is a table that contain a set of interpolation functions that can be used by tweens or directly. |
| [debug](debug.md) | This is a table that contain debug related stuff.

## Objects

| Name | Description |
| ---- | ----------- |
| [Tween](tween.md) | This is the tween itself, contain all the stuff you need for time interpolation. |


## Commands

| Name | Description |
| ---- | ----------- |
| /between | Show a debug hud to display all defined tween animations, require no privileges and the hud is displayed only from the calling player. |

