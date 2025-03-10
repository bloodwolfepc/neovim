local kb = function()
  local incremental_selection = require('nvim-treesitter.incremental_selection')
  local kb1 = {
    n = {
      ["<leader>"] = {
        s = {
          s = { incremental_selection.init_selection, "init_selection" },
        }
      }
    },
    v = {
      ["<leader>"] = {
        s = {
          i = { incremental_selection.node_incremental, "node_incremental" },
          d = { incremental_selection.node_decremental, "node_decremental" },
          c = { incremental_selection.scope_incremental, "scope_incremental" },
        }
      }
    }
  }
  return require('utils.mapKeys').vim(kb1)
end

require('lze').load {
  {
    "nvim-treesitter",
    for_cat = { cat = 'treesitter', default = false },
    event = "DeferredUIEnter",
    load = function(name)
      require('utils.extraUtils').addPacks (
      name,
      {
        "nvim-treesitter-textobjects",
        "nvim-ts-autotag",
        "nvim-ts-context-commentstring",
        "comment.nvim"
      }
    ) end,
    after = function ()
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true
        },
        indent = {
          enable = true
        },
        incremental_selection = {
          enable = true
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            selection_modes = {
              ['@parameter.outer'] = 'v',
              ['@function.outer'] = 'V',
              ['@class.outer'] = '<c-v>',
            },
            keymaps = {
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>A'] = '@parameter.inner',
            },
          },
          lsp_interop = {
            enable = true,
            border = 'none',
            floating_preview_opts = {},
            peek_definition_code = {
              ["<leader>df"] = "@function.outer",
              ["<leader>dF"] = "@class.outer",
            }
          }
        }
      }

      local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
      kb()
      require('nvim-ts-autotag').setup()
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
      }
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end
  }
}
