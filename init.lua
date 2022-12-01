

--- -----------------------------------------------------------


--- @package BeTweenApi
--- @license MIT
--- @author GianptDev (_gianpy_)
--- @release 1.0
--- @meta


--- -----------------------------------------------------------


--- This is the container of the api, this api has cool tools to make interpolated animations.
--- @class BeTweenApi
BeTweenApi = {}


--- List of all tweens curretly running.
--- @type table<integer, BeTweenApi.Tween>
local __tween_queue = {}


--- Return the current name and version of the api.
--- @return string
--- @nodiscard
function BeTweenApi.getName () return "BeTween Api 1.0" end


--- Make the input value flow around the given min and max.
--- @param value number
--- @param min number
--- @param max number
--- @return number value
--- @nodiscard
function wrap (value, min, max) return (min == max) and min or ((value - max) % (min - max) + max) end
BeTweenApi.wrap = wrap


--- Round the value to the nearest point of snap.
--- @param value number the value to snap.
--- @param snap number the size of the snap, should be a positive numberm negative numbers will work fine too.
--- @return number value
--- @nodiscard
function snap (value, snap) return (snap == 0.0) and 0.0 or (math.floor((value / snap) + 0.5) * snap) end
BeTweenApi.snap = snap


--- Give the result of interpolation between x and y in time t.
--- @param x number
--- @param y number
--- @param t number
--- @return number value
--- @nodiscard
local function lerp (x, y, t) return (x + (y - x) * t) end
BeTweenApi.lerp = lerp


--- -----------------------------------------------------------


--- @class BeTweenApi.Tween
local Tween = {

	--- Seconds to wait after the tween started to play.
	--- @type number
	timeDelay = 0.0,

	--- Total duration in seconds of the animation.
	--- @type number
	timeDuration = 2.0,

	--- Seconds to wait between each restart of the tween if loop is enabled.
	--- @type number
	timeRestart = 0.0,

	--- Specify of much fast the animation run in seconds, default is normal 1/1 each second.
	--- @type number
	timeScale = 1.0,

	--- Set if the tween should repeat after finished.
	--- @type boolean
	animLoop = false,

	--- If enabled the interpolation will be twince faster and will use the other half to return back.
	--- @type boolean
	animMirror = false,

	--- If enabled the interpolation will start from 1 to 0, basically will play in reverse.
	--- @type boolean
	animReverse = false,

	--- Custom function to make the interpolation, default is linear.
	--- @type fun(t: number) | nil
	interpolation = nil,

	--- Called when the tween has been inserted inside the process queue but hasn't done his first step yet.
	--- @type fun(self: BeTweenApi.Tween) | nil
	eventPlay = nil,

	--- Called each step as many time as possible, will give the current time step position.
	--- @type fun(self: BeTweenApi.Tween, value: number) | nil
	eventStep = nil,

	--- Called when the teen has finished his interpolation or has been stopped or has been paused.
	--- @type fun(self: BeTweenApi.Tween) | nil
	eventStop = nil,

	--- Called each time the tween loop itself.
	--- @type fun(self: BeTweenApi.Tween) | nil
	eventRestart = nil,

	--- Current step of the interpolation used by the process queue.
	--- @type number | nil
	--- @private
	__step = nil,
}


--- @meta
--- Metatable of the tween object.
local _Tween = {
	__index = Tween,
	__name = "Tween",
	__tostring = function (t)
		return ("[Tween:%p]"):format(t)
	end,
}


--- -----------------------------------------------------------


--- Create a new tween object.
--- @return BeTweenApi.Tween
function BeTweenApi.newTween ()
	local t = {}
	setmetatable(t, _Tween)
	return t
end


--- Get how many tweens are currenlty running inside the queue.
--- @return integer count
--- @nodiscard
function BeTweenApi.getTweenQueueCount () return #__tween_queue end


--- Get a copy of the list of all tweens running inside the queue.
--- @return table<integer, BeTweenApi.Tween> tweens
--- @nodiscard
function BeTweenApi.getTweenQueue ()
	local q = {}
	for _, t in ipairs(__tween_queue) do table.insert(q, t) end
	return q
end


--- Check if the tween is currently running inside the queue.
--- @return boolean playing
--- @nodiscard
function Tween:isPlaying ()
	for _, t in ipairs(__tween_queue) do if t == self then return true end end
	return false
end


--- Will get the index position inside the queue list if the tween is running.
--- @return integer | nil index
--- @nodiscard
function Tween:getIndex ()
	for i, t in ipairs(__tween_queue) do if t == self then return i end end
	return nil
end


--- Will start the tween from interpolating by inserting it inside the queue, soon it will start to execute the steps.
--- @param skip_delay? boolean If enabled the first delay is skipped.
--- @return boolean success
function Tween:doPlay (skip_delay)
	
	--- make sure to play only once.
	if self:isPlaying() then
		minetest.log("error", ("BeTweenApi > %s is already playing."):format(tostring(self)))
		return false
	end

	if skip_delay then self.__step = tween.timeDelay end

	--- insert into queue and alert the event.
	table.insert(__tween_queue, self)
	if self.eventPlay then self:eventPlay() end

	minetest.log("action", ("BeTweenApi > %s is playing."):format(tostring(self)))
	return true
end


--- Will stop the tween and remove it from the queue.
--- @param reset? boolean # If enabled will reset the tween timer, by default is false and this method will work as a pause.
--- @return boolean success
function Tween:doStop (reset)
	
	if not self:isPlaying() then
		minetest.log("error", ("BeTweenApi > %s is already stopped."):format(tostring(self)))
		return false
	end

	--- reset the timer.
	if reset then self.__step = nil end

	--- remove from queue and event.
	table.remove(__tween_queue, self:getIndex())
	if self.eventStop then self:eventStop() end

	minetest.log("action", ("BeTweenApi > %s is stopped."):format(tostring(self)))
	return true
end


--- Will change the current interpolation position of the tween, it will skip the begin delay.
--- @param time number # The time position to set in a range between 0.0 and 1.0, the begin of the interpolation and his end.
function Tween:setTime (time)
	self.__step = self.timeDelay + (self.timeDuration * time)
end


--- Get the current time position of the tween interpolation.
--- @return number time
--- @nodiscard
function Tween:getTime ()
	return (self.__step - self.timeDelay) / self.timeDuration
end


--- Get the interpolated value of the interpolation, the result is calculated by the time and interpolation function in use.
--- @param time? number # Custom time position of the interpolation, if unused the current tween time is used.
--- @return number step
--- @nodiscard
function Tween:getStep (time)
	if not time then time = self:getTime() end

	--- reverse on half and double the step.
	if self.animMirror then
		time = (time >= 0.5 and 1.0 - time or time) * 2.0
	end

	--- reverse the time.
	if self.animReverse then time = 1.0 - time end

	--- user function or linear by default.
	return self.interpolation and self.interpolation(time) or time
end


--- -----------------------------------------------------------


--- This is a build-in collection of varius interpolation function that can be used for tweens.
--- @class BeTweenApi.Interpolations
BeTweenApi.Interpolations = {}

local I = BeTweenApi.Interpolations

function BeTweenApi.Interpolations.easeIn(t)
	return t ^ 2.0
end

function BeTweenApi.Interpolations.easeOut(t)
	return 1.0 - math.sqrt(1.0 - t)
end

function BeTweenApi.Interpolations.easeInOut(t)
	return lerp(I.easeIn(t), I.easeOut(t), t)
end

function BeTweenApi.Interpolations.quadraticIn(t)
	return t ^ 2
end

function BeTweenApi.Interpolations.quadraticOut(t)
	return t * (2.0 - t)
end

function BeTweenApi.Interpolations.quadraticInOut(t)
	return lerp(I.quadraticIn(t), I.quadraticOut(t), t)
end

function BeTweenApi.Interpolations.cubicIn(t)
	return t ^ 3
end

function BeTweenApi.Interpolations.cubicOut(t)
	t = t - 1.0
	return 1.0 + (t ^ 3)
end

function BeTweenApi.Interpolations.cubicInOut(t)
	t = t * 2; if t < 1.0 then return 0.5 * (t ^ 3) end;
	t = t - 2.0; return 0.5 * (t ^ 3 + 2.0);
end

function BeTweenApi.Interpolations.quarticIn(t)
	return t ^ 4
end

function BeTweenApi.Interpolations.quarticOut(t)
	t = t - 1.0
	return 1.0 - (t ^ 4)
end

function BeTweenApi.Interpolations.quarticInOut(t)
	t = t * 2
	if t < 1.0 then return 0.5 * (t ^ 4) end
	t = t - 2.0
	return -0.5 * (t ^ 4 - 2.0)
end

function BeTweenApi.Interpolations.sinusoidalIn(t)
	return 1.0 - math.cos(t * math.pi / 2.0)
end

function BeTweenApi.Interpolations.sinusoidalOut(t)
	return math.sin(t * math.pi / 2.0)
end

function BeTweenApi.Interpolations.sinusoidalInOut(t)
	return 0.5 * (1.0 - math.cos(math.pi * t))
end

function BeTweenApi.Interpolations.circularIn(t)
	return 1.0 - math.sqrt(1.0 - t * t)
end

function BeTweenApi.Interpolations.circularOut(t)
	t = t - 1.0; return math.sqrt(1.0 - (t * t));
end

function BeTweenApi.Interpolations.circularInOut(t)
	t = t * 2
	if t < 1.0 then return -0.5 * (math.sqrt(1.0 - t * t) - 1.0) end
	t = t - 2.0
	return 0.5 * (math.sqrt(1.0 - t * t) + 1.0)
end

function BeTweenApi.Interpolations.elastic(t)
	return (2.0 ^ -(10.0 * t) * math.sin((t - 0.1) * (2.0 * math.pi) / 0.4)) + 1.0
end


--- -----------------------------------------------------------


--- The process loop called each server tick.
--- @param step number
local function __server_tick (step)
	for _, tween in ipairs(__tween_queue) do
		
		--- create or advance to next step.
		local advance = step * tween.timeScale
		tween.__step = tween.__step and tween.__step + advance or advance

		--- the tween has finished his delay time.
		if tween.__step >= tween.timeDelay then
			local finish = tween.timeDelay + tween.timeDuration

			--- first tick of interpolation, send to event rounded to begin.
			if tween.eventStep and (tween.__step - advance) <= tween.timeDelay then tween:eventStep(tween:getStep(0.0))
			
			--- the time portion we want to interpolate, calculate step and send to event.
			elseif tween.__step <= finish then
				if tween.eventStep then tween:eventStep(tween:getStep()) end
			
			--- outside the time portion, we may wait for an extra delay and choose to loop or stop the tween.
			else

				--- steps just exited the time duration, send to event rounded to finish.
				if tween.eventStep and (tween.__step - advance) < finish then tween:eventStep(tween:getStep(1.0)) end

				--- the tween does not want to loop, just stop it.
				if not tween.animLoop then tween:doStop(true)

				--- the tween want to loop, check if the extra time as passed first.
				elseif tween.__step >= (finish + tween.timeRestart) then
					tween.__step = tween.timeDelay
					if tween.eventRestart then tween:eventRestart() end
				end
			end
		end
	end
end


--- Called when the server shutdown.
local function __server_shutdown ()

	--- simply stop any tween.
	for _, tween in ipairs(__tween_queue) do
		tween:doStop(true)
	end

end


--- Called by a player or the server.
--- @param name string
--- @param param string
local function __c_between (name, param)
	param = (param):lower()

	if param == "queue" then
		local text = "[.] Tweens queue list\n"
		local MAX_LIST = 25
		
		for i, tween in ipairs(__tween_queue) do
			if i > MAX_LIST then
				text = text .. ("[+%d more]"):format(#__tween_queue - MAX_LIST)
				break
			end
			text = text .. ("% 3d # %p, %.2f | %.2f | %.2f | %.4f | %.2f \n"):format(i, tween, tween.timeDelay, tween.timeDuration, tween.timeRestart, tween.timeScale, tween:getStep())
		end

		text = text .. ("\n[?] %d running tweens"):format(#__tween_queue)

		minetest.chat_send_player(name, text)
		minetest.log("action", text)
		return true
	end

	return true, BeTweenApi.getName()
end


minetest.register_globalstep(__server_tick)
minetest.register_on_shutdown(__server_shutdown)
minetest.register_chatcommand("between",
	{
		params = "[ queue ]",
		description = "Display the current version of the api and show some debug informations.\n" ..
		"- queue, will show the list of all runnin tweens.",
		privs = {
			debug = true,
		},
		func = __c_between
	}
)


--- -----------------------------------------------------------


--- main loop of the api.
--- @param dtime number
local function A (dtime)

	--- tween working loop.
	--- @param tween Tween
	for _, tween in pairs(active_tweens) do

		-- calculate the position in time from the current to the target,
		-- make sure to clamp the range.
		local t = tween.timer / tween.time
		t = (t < 0.0) and 0.0 or (t > 1.0) and 1.0 or t

		if (t >= 0.0) then

			-- store time to give to the function, it may get modifications.
			local f_t = t

			-- check if mirror is enabled.
			f_t = (tween.movement[3] == true)
				--- if enabled make the movement twince faster and use the left time to turn back.
				and ((f_t >= 0.5) and ((1.0 - f_t) / 0.5) or f_t * 2)
				--- if not enabled use normal timer.
				or f_t

			-- calculate the interpolated value.
			local value = tween.interpolation(
				tween.movement[1], tween.movement[2], f_t
			)

			-- call the step of the tween.
			if (tween.on_step ~= nil) then
				tween.on_step(tween, value)
			end
		end

		-- action to execute when the tween has finished his job.
		if (t == 1.0) then

			-- some extra millisecons may be inside the timer, this will remove them.
			tween.timer = tween.movement[2]

			-- if the tween require to loop, reset the timer.
			if ((tween.loop == true) or ((type(tween.loop) == "number") and (tween.loop > 1))) then
				tween.timer = 0.0

				-- if number is used, count down for the end.
				if (type(tween.loop) == "number") then
					tween.loop = tween.loop - 1
				end

				--- call the loop event.
				if (tween.on_loop ~= nil) then
					tween.on_loop(tween)
				end
			
			-- if the tween need to stop, stop it.
			else
				tween:stop(true)
			end
		
		-- if the job isn't finished, continue to run the timer.
		else
			-- merge the current timer with all the time has passed from the previus step.
			tween.timer = tween.timer + dtime
		end

	end
end


-- register the global step that will handle all running tweens.
minetest.register_globalstep(A)


--- -----------------------------------------------------------

