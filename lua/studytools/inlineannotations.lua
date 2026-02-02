local M = {}

local ns          = vim.api.nvim_create_namespace("studytools_inlineannotations")
local diag_ns     = vim.api.nvim_create_namespace("studytools_inlineannotations_diag")
local diagnostics = {}

local defaults = {
	icons = {
		important  = " ",
		question   = "?",
		study      = " ",
		definition = " ",
		example    = " ",
		review     = " ",
		memorise   = " ",
	}
}

local config = {}

-- Define annotation patterns
local patterns = {
	important  = "!IMPORTANT!",
	question   = "!QUESTION!",
	study      = "!STUDY!",
	definition = "!DEFINITION!",
	example    = "!EXAMPLE!",
	review     = "!REVIEW!",
	memorise   = "!MEMORISE!",
	custom     = "!CUSTOM%[(.-)%]!"
}

local highlights = {
	important_line  = "StudytoolsImportantLine",
	important_icon  = "StudytoolsImportantIcon",

	question_line   = "StudytoolsQuestionLine",
	question_icon   = "StudytoolsQuestionIcon",

	study_line      = "StudytoolsStudyLine",
	study_icon      = "StudytoolsStudyIcon",

	definition_line = "StudytoolsDefinitionLine",
	definition_icon = "StudytoolsDefinitionIcon",

	example_line    = "StudytoolsExampleLine",
	example_icon    = "StudytoolsExampleIcon",

	review_line     = "StudytoolsReviewLine",
	review_icon     = "StudytoolsReviewIcon",

	memorise_line   = "StudytoolsMemoriseLine",
	memorise_icon   = "StudytoolsMemoriseIcon",

	custom_line     = "StudytoolsCustomLine",
	custom_text     = "StudytoolsCustomIcon",
}

-- Define highlights
local defineHighlights = function()
	local hl = vim.api.nvim_set_hl

	hl(0, highlights.important_line,  { bg = "#e64553" })
	hl(0, highlights.important_icon,  { fg = "#d20f39" })

	hl(0, highlights.question_line,   { bg = "#df8e1d" })
	hl(0, highlights.question_icon,   { fg = "#fe640b" })

	hl(0, highlights.study_line,      { bg = "#209fb5" })
	hl(0, highlights.study_icon,      { fg = "#04a5e5" })

	hl(0, highlights.definition_line, { bg = "#8839ef" })
	hl(0, highlights.definition_icon, { fg = "#ea76cb" })

	hl(0, highlights.example_line,    { bg = "#40a02b" })
	hl(0, highlights.example_icon,    { fg = "#50b03c" })

	hl(0, highlights.review_line,     { bg = "#e5c890" })
	hl(0, highlights.review_icon,     { fg = "#ef9f76" })

	hl(0, highlights.memorise_line,   { bg = "#dd7878" })
	hl(0, highlights.memorise_icon,   { fg = "#dc8a78" })

	hl(0, highlights.custom_line,     { bg = "#626880" })
	hl(0, highlights.custom_text,     { fg = "#a5adce" })
end

local clear = function(bufnr)
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
	vim.diagnostic.reset(diag_ns, bufnr)
end

local resetDiagnostics = function(bufnr)
  diagnostics[bufnr] = {}
end

local addDiagnostic = function(bufnr, lnum, kind)
  diagnostics[bufnr] = diagnostics[bufnr] or {}

  local severity_map = {
    important  = vim.diagnostic.severity.ERROR,
    question   = vim.diagnostic.severity.WARN,
    study      = vim.diagnostic.severity.INFO,
    definition = vim.diagnostic.severity.INFO,
    example    = vim.diagnostic.severity.INFO,
    review     = vim.diagnostic.severity.HINT,
    memorise   = vim.diagnostic.severity.HINT,
    custom     = vim.diagnostic.severity.HINT,
  }

  table.insert(diagnostics[bufnr], {
    lnum     = lnum,
    col      = 0,
    end_col  = 0,
    severity = severity_map[kind] or vim.diagnostic.severity.INFO,
    message  = kind,
    source   = "studytools",
  })
end


local annotateLine = function(bufnr, lnum, line)
	for kind, pattern in pairs(patterns) do
		local s, e, customText = line:find(pattern)
		e = e + 1

		if s then
			if kind == "important" then
				vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, 0, {
					line_hl_group = highlights.important_line,
					virt_text = {
						{ config.icons.important, highlights.important_icon }
					},
					virt_text_pos = "eol",
				})
			elseif kind == "question" then
				vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, 0, {
					line_hl_group = highlights.question_line,
					virt_text = {
						{ config.icons.question, highlights.question_icon }
					},
					virt_text_pos = "eol",
				})
			elseif kind == "study" then
				vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, 0, {
					line_hl_group = highlights.study_line,
					virt_text = {
						{ config.icons.study, highlights.study_icon }
					},
					virt_text_pos = "eol",
				})
			elseif kind == "definition" then
				vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, 0, {
					line_hl_group = highlights.definition_line,
					virt_text = {
						{ config.icons.definition, highlights.definition_icon }
					},
					virt_text_pos = "eol",
				})
			elseif kind == "example" then
				vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, 0, {
					line_hl_group = highlights.example_line,
					virt_text = {
						{ config.icons.example, highlights.example_icon }
					},
					virt_text_pos = "eol",
				})
			elseif kind == "review" then
				vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, 0, {
					line_hl_group = highlights.review_line,
					virt_text = {
						{ config.icons.review, highlights.review_icon }
					},
					virt_text_pos = "eol",
				})
			elseif kind == "memorise" then
				vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, 0, {
					line_hl_group = highlights.memorise_line,
					virt_text = {
						{ config.icons.memorise, highlights.memorise_icon }
					},
					virt_text_pos = "eol",
				})
			elseif kind == "custom" then
				vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, 0, {
				  line_hl_group = highlights.custom_line,
				  virt_text = {
					{ "  " .. customText, highlights.custom_text },
				  },
				  virt_text_pos = "eol",
				})
			end

			addDiagnostic(bufnr, lnum, kind)

			return
		end
	end
end

local render = function(bufnr)
	clear(bufnr)

	vim.diagnostic.reset(diag_ns, bufnr)
	resetDiagnostics(bufnr)

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	for i, line in ipairs(lines) do
		annotateLine(bufnr, i - 1, line)
	end

	vim.diagnostic.set(diag_ns, bufnr, diagnostics[bufnr], {
		virtual_text = false,
		underline = false,
	})
end

M.setup = function(opts)
	config = vim.tbl_deep_extend("force", defaults, opts or {})

	defineHighlights()

	vim.api.nvim_create_autocmd(
		{ "BufEnter", "TextChanged", "TextChangedI", "CursorMoved" },
		{
			callback = function(args)
				render(args.buf)
			end
		}
	)
end

return M
