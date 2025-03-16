local kb = function()
  local mapKeys = require("utils.mapKeys")
  local kb2 = {
    ["<leader>"] = {
      C = {
        c = { "<cmd>ChatGPT<CR>", "ChatGPT" },
        e = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction" },
        g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction" },
        t = { "<cmd>ChatGPTRun translate<CR>", "Translate" },
        k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords" },
        d = { "<cmd>ChatGPTRun docstring<CR>", "Docstring" },
        a = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests" },
        o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code" },
        s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize" },
        f = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs" },
        x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code" },
        r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit" },
        l = { "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis" },
      }
    }
  }
  local kb1 = {
    n = kb2,
    v = kb2
  }
  return mapKeys.lze(kb1)
end

require("lze").load {
  {
    "ChatGPT.nvim",
    for_cat = "ai",
    event = "DeferredUIEnter",
    cmd = "ChatGPT",
    keys = (kb)(),
    after = function()
      local border = { style = { " ", " ", " ", " ", " ", " ", " ", " " }, highlight = "PickerBorder" }
      local win_options = { winhighlight = "Normal:NormalFloat,FloatBorder:None", }
      require("chatgpt").setup({
        api_key_cmd = "gpg -q --decrypt ~/src/config/secrets/key.txt",
        chat = {
          welcome_message = [[ nil ]],
          sessions_window = { border = border, win_options = win_options },
        },
        popup_layout = {
          center = {
            width = "100%",
            height = "100%",
          },
        },
        popup_window = { border = border, win_options = win_options },
        settings_window = { border = border, win_options = win_options },
        popup_input = { border = border, win_options = win_options },
      })
      kb()
    end
  },
  -- {
  --   "gp.nvim",
  --   for_cat = "ai",
  --   event = "DeferredUIEnter",
  --   after = function()
  --     require('gp').setup({
  --       openai = {
  --         endpoint = "https://api.openai.com/v1/chat/completions",
  -- 	      secret = os.getenv("OPENAI_API_KEY"),
  --       }
  --     })
  --   end,
  -- },
  {
    "avante.nvim",
    for_cat = "ai",
    event = "DeferredUIEnter",
    after = function()
      require("avante").setup({
        provider = "openai",
        openai = {
          --api_key_name = "cmd:gpg -q --decrypt ~/src/config/secrets/key.txt"
        },
      })
    end,
  }

}
