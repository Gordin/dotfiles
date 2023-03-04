require'lightspeed'.setup {
  jump_to_unique_chars = false,
  repeat_ft_with_target_char = true,
  ignore_case = false,
  force_beacons_into_match_width = false,
  limit_ft_matches = 8,
  safe_labels = {} -- having no safe labels forces you to press the third key, even on the first match.
                   -- It's more consistens this way
}

local remap = vim.keymap.set
-- lightspeed -- jump anywhere by typing s + 1 or 2 letters of where you want to go + shown letter
remap('n', 's', '<Plug>Lightspeed_omni_s', {noremap = false })
remap('n', 'S', '<Plug>Lightspeed_omni_s', {noremap = false })
