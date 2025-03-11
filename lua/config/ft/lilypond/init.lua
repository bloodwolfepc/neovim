return {
  {
    "nvim-lilypond-suite",
    for_cat = "lilypond",
    event = "DeferredUIEnter",
    lazy = false;
    after = function(plugin)
      require("nvls").setup({
        player = {
          options = {
            fluidsynth_flags = {
              "~/sfz/piano/model-b/The Experience NY S&S Model B AB Omni V1.0.sfz"
            }
          }
        },
        mappings = {
          compile = "<C-s>",
          player = "<leader>sp",
        },
      })
    end,
  }
}
