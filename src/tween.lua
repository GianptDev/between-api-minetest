

--- -----------------------------------------------------------


--- @meta


--- -----------------------------------------------------------


--- This is a list of all active tween that are processed in the server.
--- @type table<Tween>[]
BeTweenApi.active_tweens = {}


--- -----------------------------------------------------------


--- @class Tween
--- @field interpolation fun(x: number, y: number, t: number)
--- @field movement { [1]: number, [2]: number, [3]: boolean }
--- @field time number
--- @field timer number
--- @field loop boolean|integer
--- @field on_start fun(tween: Tween)
--- @field on_stop fun(tween: Tween)
--- @field on_step fun(tween: Tween, step: number)
--- @field on_loop fun(tween: Tween)
local Tween = {}


--- create a tween object that will interpolate an intial value to a destination in time, each value calculated in time are created from the function the tween is using, after the tween has been created it has run by calling :start()
--- 
--- 	--- callbacks, each of then give the tween.
--- 	on_start(tween)	--- executed on tween start.
--- 	on_stop(tween)	--- executed on tween stop.
--- 	on_step(tween, step: number)	--- executed on tween interpolation step.
--- 	on_loop(tween)	--- executed every loop the tween complete, only called if loop is used.
--- @param interpolation fun(x: number, y:number, t: number)
--- @param movement { [1]: number, [2]: number, [3]: boolean } | { start: number, finish: number, mirror: boolean }
--- @param time number
--- @param loop boolean | integer false
--- @param callbacks { on_start: fun(tween: Tween), on_stop: fun(tween: Tween), on_step: fun(tween: Tween, step: number), on_loop: fun(tween: Tween) } nil
--- @return Tween | nil
--- @nodiscard
function BeTweenApi.tween (interpolation, movement, time, loop, callbacks)

	--- if the user does not like indexes, allow to use keys.
	--- this will check if the user used indexes or names as argouments.
	for i, a in pairs({ [1] = "start", [2] = "finish", [3] = "mirror", }) do
		movement[i] =
			(movement[i] ~= nil) and movement[i] or
			(movement[a] ~= nil) and movement[a] or nil
		
		--- if a required argoument is missing stop the creation of the tween.
		if ((i <= 2) and (movement[i] == nil)) then
			minetest.log("error", "Failed to make tween because movement contain incorrect argouments.")
			return nil
		end
	end

	if (time == nil) then
		minetest.log("error", "Tween does not set his duration time.")
		return nil
	end
	
	--- create the Tween object and set all his values.
	--- @type Tween
	local tween = {}

	--- yeah, basically it just copy everything defined on Tween.
	for x, y in pairs(Tween) do
		tween[x] = y
	end

	--- set input or default values for everything.
	tween.timer = 0.0
	tween.time = time
	tween.loop = (loop ~= nil) and loop or false

	tween.interpolation = interpolation

	if (callbacks ~= nil) then
		tween.on_start = callbacks.on_start
		tween.on_stop = callbacks.on_stop
		tween.on_step = callbacks.on_step
		tween.on_loop = callbacks.on_loop
	end

	tween.movement = {
		movement[1], movement[2],
		(movement[3] ~= nil) and movement[3] or false
	}

	minetest.log("action", ("New tween '%p' created."):format(tween))
	return tween
end


--- -----------------------------------------------------------


--- Start the execution of this tween, it will be added in the active_tweens list until stopped or finished.
function Tween:start ()

	--- do not run the tween twince.
	if (self:is_running() == true) then
		minetest.log("warning", ("Tried to start tween '%p' twince."):format(self))
		return
	end

	--- tween will start soon, add inside the tween loop.
	table.insert(BeTweenApi.active_tweens, self)
	minetest.log("action", ("Tween '%d' ~ '%p' is now running."):format(self:index(), self))

	--- call the virtual.
	if (self.on_start ~= nil) then
		self.on_start(self)
	end
end


--- stop the tween to work by removing it from the active list.
--- @param reset boolean false
function Tween:stop (reset)
	local index = self:index()

	--- set default reset value.
	if (reset == nil) then
		reset = (reset == nil)
	end
	
	--- index does not exist because the tween is not running.
	if (index == nil) then
		minetest.log("warning", ("Tried to stop tween '%p' wich wasn't running."):format(self))
		return
	end

	--- reset the timer.
	if (reset == true) then
		self.timer = 0
	end

	--- tween is stopped now, remove from tween loop.
	table.remove(BeTweenApi.active_tweens, index)
	minetest.log("action", ("Tween '%p' has been stopped."):format(self))

	--- call the virtual.
	if (self.on_stop ~= nil) then
		self.on_stop(self)
	end
end


--- check if the tween is currently running.
--- @return boolean
function Tween:is_running ()

	for i, tween in pairs(BeTweenApi.active_tweens) do
		if (tween == self) then
			return true
		end
	end

	return false
end


--- get the running index of the tween, if the tween isn't running nil is returned.
--- @return integer | nil
function Tween:index ()
	local index = 1
	
	for i, tween in pairs(BeTweenApi.active_tweens) do

		if (tween == self) then
			return index
		end

		index = index + 1
	end

	return nil
end


--- -----------------------------------------------------------

