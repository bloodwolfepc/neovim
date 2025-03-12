require("lze").register_handlers(require('nixCatsUtils.lzUtils').for_cat)
require("lze").register_handlers(require('lzextras').lsp)
vim.cmd.packadd("nvim-web-devicons")
require'nvim-web-devicons'.setup({})
for _, cat in ipairs({
  "opts",
  "keys",
  "alpha",
  "oil",
  "yanky",
  "gitsigns",
}) do
  if nixCats('general') then
    require('config.' .. cat)
  end
end

for _, cat in ipairs({
  'debug',
  'telescope',
  'lint',
  'format',
  'treesitter',
  'cmp',
  'lsp',
  'ai',
}) do
  if nixCats(cat) then
    require('config.' .. cat)
  end
end

require('lze').load {
  {
    "indent-blankline.nvim",
    for_cat = 'general',
    event = "DeferredUIEnter",
    after = function()
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }
      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#df0076" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#d700d7" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#af00ff" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#8700ff" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#7d00ec" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#6700c3" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#5757ea" })
      end)
      require("ibl").setup { indent = { highlight = highlight } }
    end,
  },
  {
    "undotree",
    for_cat = "general",
    cmd = { "UndotreeToggle", "UndotreeHide", "UndotreeShow", "UndotreeFocus", "UndotreePersistUndo", },
    keys = { { "<leader>U", "<cmd>UndotreeToggle<CR>", mode = { "n" }, desc = "Undo Tree" }, },
    before = function(_)
      vim.g.undotree_WindowLayout = 1
      vim.g.undotree_SplitWidth = 40
    end,
  },
  {
    "vim-startuptime",
    for_cat = 'general.extra',
    cmd = { "StartupTime" },
    before = function(_)
      vim.g.startuptime_event_width = 0
      vim.g.startuptime_tries = 10
      vim.g.startuptime_exe_path = nixCats.packageBinPath
    end,
  },
  {
    "fidget.nvim",
    for_cat = 'general',
    event = "DeferredUIEnter",
    after = function()
      require('fidget').setup({})
    end,
  },
  {
    "eyeliner.nvim",
    for_cat = 'general',
    event = "DeferredUIEnter",
    after = function()
      require('eyeliner').setup({})
    end,
  },
  {
    "lualine.nvim", --TODO: galaxyline
    for_cat = 'general',
    event = "DeferredUIEnter",
    after = function ()
      require('lualine').setup({
        options = {
          icons_enabled = true,
          theme = nil,
        }
      })
    end,
  },
  {
    "marks.nvim",
    for_cat = 'general',
    event = "DeferredUIEnter",
    after = function ()
      require("marks").setup()
    end,
  },
  {
    "todo-comments.nvim",
    for_cat = 'general',
    event = "DeferredUIEnter",
    after = function ()
      require("todo-comments").setup()
      --TODO: add jumping
    end,
  },
  {
    "nvim-surround",
    for_cat = "general",
    event = "DeferredUIEnter",
    after = function()
      require("nvim-surround").setup()
    end,
  },
  { import = "config.ft.markdown" },
  { import = "config.ft.latex" },
  { import = "config.ft.lilypond" },
}

--unlazy
vim.cmd.packadd("nvim-colorizer.lua")
require("colorizer").setup({
  always_update = true,
  RGB = true,
  RGBA = true,
  RRGGBB = true,
  RRGGBBAA = true,
  AARRGGBB = true,
  rgb_fn = true,
  hsl_fn = true,
  css = true;
  css_fn = true,
  tailwind = true,
  tailwind_opts  ={
    update_names = true,
  },
})

vim.cmd.packadd("vim-illuminate")
require('illuminate').configure({
  delay = 0,
  under_cursor = false
})
