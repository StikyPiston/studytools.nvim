local M = {}

local ns = vim.api.nvim_create_namespace("studytools_blurt")

-- Create a scratch buffer with given lines
local scratch_buf = function(lines, filetype, readonly)
    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].filetype = filetype or "markdown"
    vim.bo[buf].modifiable = not readonly
    vim.bo[buf].readonly = readonly or false

    return buf
end

-- Open diff view between original and blurt
local open_diff = function(original_lines, blurt_lines)
    vim.cmd("tabnew")

    -- Left: original
    local orig_buf = scratch_buf(original_lines, "markdown", true)
    vim.api.nvim_win_set_buf(0, orig_buf)
    vim.cmd("diffthis")

    -- Right: blurt
    vim.cmd("vsplit")
    local blurt_buf = scratch_buf(blurt_lines, "markdown", true)
    vim.api.nvim_win_set_buf(0, blurt_buf)
    vim.cmd("diffthis")
end

M.start = function()
    local src_buf = vim.api.nvim_get_current_buf()
    local src_lines = vim.api.nvim_buf_get_lines(src_buf, 0, -1, false)

    vim.cmd("tabnew")

    local blurt_buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_name(blurt_buf, "studytools://blurt")

    -- Configure blurt buffer
    vim.bo.buftype = "acwrite"
    vim.bo.bufhidden = "wipe"
    vim.bo.swapfile = false
    vim.bo.filetype = "markdown"
    vim.bo.modifiable = true
    vim.bo.readonly = false

    -- Store original content buffer-locally
    vim.b.studytools_blurt_original = src_lines

    -- Optional starter text
    vim.api.nvim_buf_set_lines(blurt_buf, 0, -1, false, {
        "# Blurt",
        "",
        "> Write everything you remember. Save to review.",
		"> This blurt file allows you review by seeing the diff between the two files",
		"> Also make sure to remove this starter text before you begin"
    })

    -- Intercept :w
    vim.api.nvim_create_autocmd("BufWriteCmd", {
        buffer = blurt_buf,
        once = true,
        callback = function()
            local blurt_lines = vim.api.nvim_buf_get_lines(blurt_buf, 0, -1, false)
            local original_lines = vim.b.studytools_blurt_original or {}

            open_diff(original_lines, blurt_lines)

			vim.api.nvim_buf_delete(blurt_buf, { force = true })
        end,
    })
end

return M
