--This code was made to explain how you can implement timers from "scratch"
--usage: same as createTimer() but with addTimer()
--doesn't support one-shot timers
--if you leave the sleep(1) commented 1 cpu will run at 100%
timerArray = {}
function addTimer()
	local timerObject = {Interval=0,Enabled=0,OnTimer=0,  LastTick=0, selfIndex = #timerArray+1}
	timerArray[timerObject.selfIndex] = timerObject
	timerObject.destroy = function()
		for i=timerObject.selfIndex, #timerArray do
			timerArray[i] = timerArray[i+1]
			if timerArray[i] then timerArray[i].selfIndex = i end
		end
	end
	return timerObject
end


timerThread = createThread(function(t)--make sure to nil the var when you do timerThread.terminate()
while not t.Terminated do
	local tick = getTickCount()
	for i=1,#timerArray do
		local timer = timerArray[i]
		if tick - timer.LastTick >= timer.Interval then
			if timer.Enabled and type(timer.OnTimer) == "function" then timer.OnTimer() end
			timer.LastTick = tick
		end
	end
--sleep(1)--thread will go to 100%
end
end)
