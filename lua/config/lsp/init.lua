local catUtils = require('nixCatsUtils')
vim.lsp.set_log_level("debug")

require('lze').load {
  {
    "nvim-lspconfig",
    for_cat = "lsp",
    on_require = { "lspconfig" },
    lsp = function(plugin)
      require('lspconfig')[plugin.name].setup(vim.tbl_extend("force",{
        capabilities = require('config.lsp.caps-on_attach').get_capabilities(plugin.name),
        on_attach = require('config.lsp.caps-on_attach').on_attach,
      }, plugin.lsp or {}))
    end,
  },
  {
    "lazydev.nvim",
    for_cat = "lsp",
    cmd = { "LazyDev" },
    ft = "lua",
    after = function(_)
      require('lazydev').setup({
        library = {
          { words = { "nixCats" }, path = (nixCats.nixCatsPath or "") .. '/lua' },
        },
      })
    end,
  },
  {
    "lua_ls",
    enabled = nixCats("lua") or false,
    lsp = {
      filetypes = { "lua" },
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          formatters = {
            ignoreComments = true,
          },
          signatureHelp = { enabled = true },
          diagnostics = {
            globals = { "nixCats", "vim", },
            disable = { 'missing-fields' },
          },
          telemetry = { enabled = false },
        },
      },
    },
  },
  {
    "nixd",
    enabled = nixCats("nix") or false,
    lsp = {
      filetypes = { "nix" },
      settings = {
        nixd = {
          nixpkgs = {
            expr = [[import (builtins.getFlake "]] .. nixCats.extra("nixdExtras.nixpkgs") .. [[") { }   ]],
          },
          formatting = {
            command = { "nixfmt" }
          },
          options = {
            nixos = {
              expr = nixCats.extra("nixdExtras.nixos_options")
            },
            ["home-manager"] = {
              expr = nixCats.extra("nixdExtras.home_manager_options")
            }
          },
          diagnostic = {
            suppress = {
              "sema-escaping-with"
            }
          }
        }
      }
    }
  },
  -- {
  --   "null-ls.nvim",
  --   enabled = nixCats("lsp") or false,
  --   lazy = false,
  --   after = function()
  --     local null_ls = require("null-ls")
  --     null_ls.setup({
  --       sources = { }
  --     })
  --   end,
  -- },
  {
    "clangd",
    enabled = nixCats("c") or false,
    lsp = {
      filetypes = { "c", "cpp" },
    },
  },
  {
    "bashls",
    enabled = nixCats("bash") or false,
    lsp = {
      filetypes = { "sh", "bash" },
    },
  },
  {
    "yamlls",
    enabled = nixCats("yaml") or false,
    lsp = {
      filetypes = { "yaml", "yml" },
    },
  },
  {
    "jsonls",
    enabled = nixCats("json") or false,
    lsp = {
      filetypes = { "json" },
    },
  },
  {
    "texlab",
    enabled = nixCats("latex") or false,
    lsp = {
      filetypes = { "tex", "bib" },
    },
  },
}
