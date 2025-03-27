local kb = function()
  local mapKeys = require("utils.mapKeys")
  local cmd = function(cmd1)
    return {
      "<cmd>CodeCompanion" .. cmd1 .. "<cr>",
      cmd1
    }
  end
  local kb2 = {
    ["<leader>"] = {
      a = {
        a = cmd("Actions"),
        v = cmd("Chat Toggle"),
        e = cmd(" /explain"),
        f = cmd(" /fix"),
        l = cmd(" /lsp"),
        t = cmd(" /tests"),
        m = cmd(" /commit"),
        M = cmd(" /staged-commit"),
        d = cmd(" /inline-doc"),
        D = cmd(" /doc"),
        r = cmd(" /refactor"),
        R = cmd(" /review"),
        n = cmd(" /naming"),
        q = {
          function()
            local input = vim.fn.input("Quick Chat: ")
            if input ~= "" then
              vim.cmd("CodeCompanion " .. input)
            end
          end,
          "Quick Chat"
        }
      }
    }
  }
  local kb1 = {
    n = kb2,
    v = kb2
  }
  return mapKeys.lze(kb1)
end
return {
  {
    "codecompanion.nvim",
    for_cat = "ai",
    event = "DeferredUIEnter",
    keys = (kb)(),
    after = function()
      local prompt = require("config.ai.prompt")
      require("codecompanion").setup({
        adapters = {
          openai = function()
            return require("codecompanion.adapters").extend("openai", {
              schema = {
                model = {
                  desc = "",
                  default = "gpt-4o",
                  choices = {
                    "gpt-4o",
                    "gpt-4o-mini",
                    "gpt-3.5-turbo",
                  },
                },
              },
            })
          end,
        },
        strategies = {
          chat = {
            adapter = "openai",
            roles = { llm = " Copilot Chat", user = "user" },
            slash_commands = {
              ["file"] = {
                description = "",
                opts = {
                  provider = "telescope",
                },
              },
              ["buffer"] = {
                description = "",
                opts = {
                  provider = "telescope",
                },
              },
            },
            keymaps = {
              send = {
                description = "Send",
              },
              close = {
                description = "Close Chat",
              },
              stop = {
                description = "Stop Request",
              },
            },
          },
          inline = { adapter = "openai" },
          agent = { adapter = "openai" },
        },
        inline = {
          layout = "buffer",
        },
        display = {
          chat = {
            show_settings = true,
            window = {
              layout = "vertical",
            },
          },
        },
        opts = {
          log_level = "DEBUG",
          system_prompt = prompt.SYSTEM_PROMPT,
        },

        prompt_library = {
          ["Generate a Commit Message"] = {
            prompts = {
              {
                role = "user",
                content = function()
                  return "Write commit message with commitizen convention. Write clear, informative commit messages that explain the 'what' and 'why' behind changes, not just the 'how'."
                    .. "\n\n```\n"
                    .. vim.fn.system("git diff")
                    .. "\n```"
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ["Explain"] = {
            strategy = "chat",
            description = "Explain how code in a buffer works",
            opts = {
              index = 4,
              default_prompt = true,
              modes = { "v" },
              short_name = "explain",
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = "system",
                content = prompt.COPILOT_EXPLAIN,
                opts = {
                  visible = false,
                },
              },
              {
                role = "user",
                content = function(context)
                  local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                  return "Please explain how the following code works:\n\n```"
                    .. context.filetype
                    .. "\n"
                    .. code
                    .. "\n```\n\n"
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          -- Add custom prompts
          ["Generate a Commit Message for Staged"] = {
            strategy = "chat",
            description = "Generate a commit message for staged change",
            opts = {
              index = 9,
              short_name = "staged-commit",
              auto_submit = true,
            },
            prompts = {
              {
                role = "user",
                content = function()
                  return "Write commit message for the change with commitizen convention. Write clear, informative commit messages that explain the 'what' and 'why' behind changes, not just the 'how'."
                    .. "\n\n```\n"
                    .. vim.fn.system("git diff --staged")
                    .. "\n```"
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ["Inline-Document"] = {
            strategy = "inline",
            description = "Add documentation for code.",
            opts = {
              modes = { "v" },
              short_name = "inline-doc",
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = "user",
                content = function(context)
                  local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                  return "Please provide documentation in comment code for the following code and suggest to have better naming to improve readability.\n\n```"
                    .. context.filetype
                    .. "\n"
                    .. code
                    .. "\n```\n\n"
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ["Document"] = {
            strategy = "chat",
            description = "Write documentation for code.",
            opts = {
              modes = { "v" },
              short_name = "doc",
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = "user",
                content = function(context)
                  local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                  return "Please brief how it works and provide documentation in comment code for the following code. Also suggest to have better naming to improve readability.\n\n```"
                    .. context.filetype
                    .. "\n"
                    .. code
                    .. "\n```\n\n"
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ["Review"] = {
            strategy = "chat",
            description = "Review the provided code snippet.",
            opts = {
              index = 11,
              modes = { "v" },
              short_name = "review",
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = "system",
                content = COPILOT_REVIEW,
                opts = {
                  visible = false,
                },
              },
              {
                role = "user",
                content = function(context)
                  local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                  return "Please review the following code and provide suggestions for improvement then refactor the following code to improve its clarity and readability:\n\n```"
                    .. context.filetype
                    .. "\n"
                    .. code
                    .. "\n```\n\n"
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ["Refactor"] = {
            strategy = "inline",
            description = "Refactor the provided code snippet.",
            opts = {
              index = 11,
              modes = { "v" },
              short_name = "refactor",
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = "system",
                content = COPILOT_REFACTOR,
                opts = {
                  visible = false,
                },
              },
              {
                role = "user",
                content = function(context)
                  local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                  return "Please refactor the following code to improve its clarity and readability:\n\n```"
                    .. context.filetype
                    .. "\n"
                    .. code
                    .. "\n```\n\n"
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ["Naming"] = {
            strategy = "inline",
            description = "Give betting naming for the provided code snippet.",
            opts = {
              index = 12,
              modes = { "v" },
              short_name = "naming",
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = "user",
                content = function(context)
                  local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                  return "Please provide better names for the following variables and functions:\n\n```"
                    .. context.filetype
                    .. "\n"
                    .. code
                    .. "\n```\n\n"
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
        },
      })
    end,
  }
}
-- display = {
--   action_palette = {
--     provider = "telescope",
--   },
-- },
-- strategies = {
--   chat = {
--     adapter = "openai",
--   },
--   inline = {
--     adapter = "openai",
--   },
-- },
-- adapters = {
--   openai = function()
--     return require("codecompanion.adapters").extend("openai", {
--       env = {
--         api_key = os.getenv("OPENAI_API_KEY")
--         --api_key = "cmd: gpg -q --decrypt ~/src/config/secrets/key.txt",
--       },
--       schema = {
--         model = {
--           default = "gpt-4o",
--         },
--       },
--     })
--   end,
-- },
