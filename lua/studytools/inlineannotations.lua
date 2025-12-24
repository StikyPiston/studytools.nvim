local M = {}

local ns = vim.api.nvim_create_namespace("studytools_inlineannotations")

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
	hl(0, highligths.definition_icon, { fg = "#ea76cb" })

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
end

return M
