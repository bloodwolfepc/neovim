return {
  {
    "nvim-lilypond-suite",
    for_cat = "lilypond",
    event = "DeferredUIEnter",
    lazy = false;
    after = function()
      require("nvls").setup({
        lilypond = {
          mappings = {
            compile = "<leader>sc",
            player = "<leader>sp",
            open_pdf = "<leader>sm",
          },
          options = {
            pitches_language = "default",
            hyphenation_language = "en_DEFAULT",
            output = "pdf",
            backend = nil,
            main_file = "main.ly",
            main_folder = "%:p:h",
            include_dir = nil,
            diagnostics = false,
            pdf_viewer = "zathura",
          }
        },
        player = {
          options = {
            fluidsynth_flags = {
              --"~/sfz/piano/model-b/The Experience NY S&S Model B AB Omni V1.0.sfz"
              --"/home/bloodwolfe/src/lilytest/result/share/soundfonts/FluidR3_GM2-2.sf2"
              "/home/bloodwolfe/sfz/Roland_SC-55.sf2"
            },
            midi_synth = "fluidsynth",
            audio_format = "mp3",
          }
        },
      })
    end,
  }
}
