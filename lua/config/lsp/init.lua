vim.cmd.packadd("nvim-lspconfig")
vim.cmd.packadd("lazydev.nvim")

local catUtils = require('nixCatsUtils')

require('lze').load {
  {
    "nvim-lspconfig",
    for_cat = "general",
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
    for_cat = "general",
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
    enabled = nixCats("lua"),
    lsp = {
      filetypes = { 'lua' },
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
    enabled = catUtils.isNixCats,
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
  }
}
