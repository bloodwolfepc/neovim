vim.g.loaded_netrwPlugin = 1
local kb = function()
  local oil = require("oil")
  local kb1 = {
    n = {
      ["<leader>"] = {
        oo = { function() return oil.open('./') end, "oil.open('./')" }, --TODO: if o then if is in oil biffer then register o else, oil.open
        O = {
          h = { function() return oil.open('~/') end, "oil.open('~/')" },
          n = { function() return oil.open('~/notebook') end, "oil.open('~/notebook')" },
          s = { function() return oil.open('~/src') end, "oil.open('~/src')" },
        }
      }
    }
  }
  return require("utils.mapKeys").vim(kb1)
end

if nixCats('general') then
  vim.cmd.packadd('oil.nvim')
  local detail = false
  require("oil").setup({
    default_file_explorer = true,
    columns = {
      "icon",
    },
    view_options = {
      show_hidden = true
    },
    win_options = {
      wrap = false,
      signcolumn = "number",
      cursorcolumn = true,
    },
    keymaps = {
      ["<leader>o?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<leader>ov"] = "actions.select_vsplit",
      ["<leader>oh"] = "actions.select_split",
      ["<leader>ot"] = "actions.select_tab",
      ["<leader>op"] = "actions.preview",
      ["<leader>ox"] = "actions.close",
      ["<leader>or"] = "actions.refresh",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["<leader>oc"] = "actions.change_sort",
      ["<leader>oe"] = "actions.open_external",
      ["<leader>o."] = "actions.toggle_hidden",
      ["<leader>og"] = "actions.toggle_trash",
      ["<leader>od"] = {
        desc = "Toggle file detail view",
        callback = function()
          detail = not detail
          if detail then
            require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
          else
            require("oil").set_columns({ "icon" })
          end
        end,
      },
    },
  })
  kb()
end
