local utils = require "telescope.utils"
local telescope = require("telescope")
telescope.setup{
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    file_ignore_patterns = { "tmp/", "undodir/" },
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "bottom",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    -- prompt_prefix = "λ -> ",
    prompt_prefix = "   ",
    selection_caret = "|> ",
    winblend = 0,
    border = {},
    borderchars = {
      prompt = {"━", "┃", "━", "┃", "┏", "┓", "┛", "┗"},
      -- preview = {"━", "┃", "━", "┃", "┏", "┓", "┛", "┗"},
      -- results = {"━", "┃", "━", "┃", "┏", "┓", "┛", "┗"},
      -- prompt = {" ", " ", " ", " ", " ", " ", " ", " "},
      preview = {"─", "│", "─", "│", "┌", "┐", "┘", "└"},
      results = {"─", "│", "─", "│", "┌", "┐", "┘", "└"},
    },
    path_display = { "truncate" },
    set_env = { ["COLORTERM"] = "truecolor" },
    mappings = {
      -- i = { ["<c-T>"] = trouble.open_with_trouble },
      -- n = { ["<c-T>"] = trouble.open_with_trouble },
    },
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    }
  }
}

-- Extensions

-- telescope.load_extension('octo')
telescope.load_extension('fzy_native')
telescope.load_extension('repo')
telescope.load_extension('neoclip')
telescope.load_extension('notify')
telescope.load_extension('dap')
telescope.load_extension("yadm_files")
telescope.load_extension("git_or_yadm_files")
telescope.load_extension('projects') -- project.nvim

local builtin = require('telescope.builtin')
local M = {}

local check_for_git_repo = function(opts)
  -- Find root of git directory and remove trailing newline characters
  local git_root, ret = utils.get_os_command_output({ "git", "rev-parse", "--show-toplevel" }, opts.cwd)
  local use_git_root = vim.F.if_nil(opts.use_git_root, true)

  if ret ~= 0 then
    local in_worktree = utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" }, opts.cwd)
    local in_bare = utils.get_os_command_output({ "git", "rev-parse", "--is-bare-repository" }, opts.cwd)

    if in_worktree[1] ~= "true" and in_bare[1] ~= "true" then
      return false
    elseif in_worktree[1] ~= "true" and in_bare[1] == "true" then
      opts.is_bare = true
    end
  else
    if use_git_root then
      opts.cwd = git_root[1]
    end
  end

  return true
end

M.project_files = function()
  local opts = {} -- define here if you want to define something

  if check_for_git_repo(opts) then
    opts.show_untracked = true
    return builtin.git_files(opts)
  end

  return builtin.find_files(opts)
end

return M
