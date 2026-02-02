local M = {}

local timer        = nil
local state        = nil
local phaseEndTime = nil

local ringBell = function()
	vim.api.nvim_echo({ { "\a", "" } }, false, {})
end

local notify = function(msg)
	vim.notify(msg, vim.log.levels.WARN, { title = "Studytools Pomodoro" })
	ringBell()
end

local stopTimer = function()
	if timer then
		timer:stop()
		timer:close()
		timer = nil
	end
end

StartPhase = function(durationMinutes, nextState, nextDuration)
	stopTimer()

	local durationSeconds = durationMinutes * 60
	phaseEndTime = os.time() + durationSeconds

	timer = vim.loop.new_timer()
	timer:start(
		durationMinutes * 60 * 1000,
		0,
		vim.schedule_wrap(function()
			state = nextState
			if state == "work" then
				notify("Work session started (" .. nextDuration .. " mins)")
			else
				notify("Break time! (" .. nextDuration .. " mins)")
			end
			StartPhase(nextDuration, state == "work" and "break" or "work", durationMinutes)
		end)
	)
end

M.start = function(workMinutes, breakMinutes)
	workMinutes  = tonumber(workMinutes)
	breakMinutes = tonumber(breakMinutes)

	if not workMinutes or not breakMinutes then
		vim.notify(
			"Usage: :StudytoolsPomodoro <workMinutes> <breakMinutes>",
			vim.log.levels.ERROR
		)
		return
	end

	stopTimer()

	state = "work"
	notify("Work session started: (" .. workMinutes .. " mins)")
	StartPhase(workMinutes, "break", breakMinutes)
end

M.stop = function()
	stopTimer()
	state = nil
	notify("Pomodoro stopped")
end

M.status = function()
	if not timer or not state or not phaseEndTime then
		notify("No active Pomodoro session")
		return
	end

	local secondsLeft = phaseEndTime - os.time()
	if secondsLeft < 0 then secondsLeft = 0 end

	local minutes = math.floor(secondsLeft / 60)
	local seconds = secondsLeft % 60

	local msg = string.format(
		"Current session: %s | Time remaining: %02d:%02d",
		state == "work" and "Work" or "Break",
		minutes,
		seconds
	)

	notify(msg)
end

M.setup = function()
	vim.api.nvim_create_user_command(
		"StudytoolsPomodoro",
		function(opts)
			M.start(opts.fargs[1], opts.fargs[2])
		end,
		{ nargs = "*" }
	)

	vim.api.nvim_create_user_command(
		"StudytoolsPomodoroStop",
		M.stop,
		{}
	)
	
	vim.api.nvim_create_user_command(
		"StudytoolsPomodoroStatus",
		M.status,
		{}
	)
end

return M
