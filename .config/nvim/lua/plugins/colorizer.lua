require 'colorizer'.setup{
  user_default_options = {
    -- Available modes for `mode`: foreground, background,  virtualtext
    mode = "background", -- Set the display mode.
    -- Available methods are false / true / "normal" / "lsp" / "both"
    -- True is same as normal
    tailwind = "lsp", -- Enable tailwind colors
    -- parsers can contain values used in |user_default_options|
    sass = { enable = true, parsers = { "css" }, }, -- Enable sass colors
    virtualtext = "■",
    -- update color values even if buffer is not focused
    -- example use: cmp_menu, cmp_docs
    always_update = true
  },
}
