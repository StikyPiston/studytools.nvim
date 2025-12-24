local M = {}

local timer = nil
local state = nil

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

local startPhase = function(durationMinutes, nextState, nextDuration)
	stopTimer()

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
			startPhase(nextDuration, state == "work" and "break" or "work", durationMinutes)
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
	startPhase(workMinutes, "break", breakMinutes)
end

M.stop = function()
	stopTimer()
	state = nil
	notify("Pomodoro stopped")
end

M.setup = function()
	vim.api.nvim_create_user_command(
		"StudytoolsPomodoro",
		function(opts)
			M.start(opts.fargs[1], opts.fargs[2])
		end
	)

	vim.api.nvim_create_user_command(
		"StudytoolsPomodoroStop",
		M.stop,
		{}
	)
end

return M
