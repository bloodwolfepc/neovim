require("lze").load {
  {
    "conform.nvim",
    for_cat = "format",
    lazy = false,
    after = function()
      local conform = require("conform")
      conform.setup({
        formatters_by_ft = {
          rust = { "rustfmt", lsp_format = "fallback" },
        },
      })
    end,
  },
}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})

--lze spec for format
