local keymap = vim.keymap
local diagnostic = vim.diagnostic

local keymaps = {
  n = {
    ["[d"] = { diagnostic.goto_prev, "Go to previous diagnostic message" },
    ["]d"] = { diagnostic.goto_next, "Go to next diagnostic message" },
    ["<leader>e"] = { diagnostic.open_float, "Show diagnostic error messages" },
    ["<leader>q"] = { diagnostic.setloclist, "Open diagnostic quickfix list" },

    ["<left>"] = { "<Nop>" },
    ["<down>"] = { "<Nop>" },
    ["<up>"] = { "<Nop>" },
    ["<right>"] = { "<Nop>" },

    ["<C-h>"] = { "<C-w>h", "Move focus left" },
    ["<C-j>"] = { "<C-w>j", "Move focus down" },
    ["<C-k>"] = { "<C-w>k", "Move focus up" },
    ["<C-l>"] = { "<C-w>l", "Move focus right" },
  },
  t = {
    ["<Esc><Esc>"] = { "<C-\\><C-n>", "Exit terminal mode" },
  },
}

for mode, maps in pairs(keymaps) do
  for keys, mapping in pairs(maps) do
    local command, desc = mapping[1], mapping[2]
    if desc then
      keymap.set(mode, keys, command, { desc = desc })
    else
      keymap.set(mode, keys, command)
    end
  end
end

