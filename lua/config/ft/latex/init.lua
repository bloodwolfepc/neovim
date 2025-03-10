return {
  {
    "vimtex",
    for_cat = "latex",
    event = "DeferredUIEnter",
    ft = "latex",
    after = function()
      vim.g.vimtext_view_method = "zathura"
      vim.g.vimtext_compiler_method = "latexmk"
    end,
  },
}
