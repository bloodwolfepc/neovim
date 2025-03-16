return {
  {
    "vimtex",
    for_cat = "latex",
    event = "DeferredUIEnter",
    lazy = false,
    after = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "latexmk"
    end,
  },
}
