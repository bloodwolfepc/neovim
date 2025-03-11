{ outputs }: let
  categoryDefinitions = 
  let
    inherit (outputs) customPackages;
  in
  { pkgs, settings, categories, extra, name, mkNvimPlugin, ... }@packageDef: {
    lspsAndRuntimeDeps = {
      general = with pkgs; [
        universal-ctags
        ripgrep
        fd
        stdenv.cc.cc
        nix-doc
      ];
      lsp = {
        default = with pkgs; [
          bash-language-server
          eslint
          vscode-langservers-extracted #HTML,CSS,JSON,ESlint
        ];
        nix = with pkgs; [ nixd ];
        lua = with pkgs; [ lua-language-server stylua ];
        rust = with pkgs; [ rust-analyzer ];
        c = with pkgs; [ clang-tools ];
        pythoon = with pkgs; [ pyright ];
        css = with pkgs; [ tailwindcss-language-server ];
        go = with pkgs; [ gopls ];
      };
      telescope = {
        default = with pkgs; [ 
          zoxide
          gh
        ];
        nix = with pkgs; [ manix ];
      };
      markdown = with pkgs; [ 
        marksman
      ];
      latex = with pkgs; [ 
        texlab
        texlivePackages.latexmk
        zathura
      ];
      lilypond = with pkgs; [
        lilypond
        mpv
        ffmpeg
        fluidsynth
        soundfont-fluid
        fluidsynth
      ];
      yaml = with pkgs; [ yaml-language-server ];
    };
    startupPlugins = {
      general = with pkgs.vimPlugins; [
        lze
        lzextras
        alpha-nvim
        which-key-nvim
        plenary-nvim
        tmux-navigator
      ];
    };
    optionalPlugins = {
      general = with pkgs.vimPlugins; [
        #persistence-nvim
        #wilder-nvim
        #coc-vimtex
        #trouble-nvim
        yanky-nvim
        indent-blankline-nvim
        undotree
        vim-startuptime
        fidget-nvim
        oil-nvim
        comment-nvim
        lualine-nvim
        nvim-web-devicons
        nvim-colorizer-lua
        vim-illuminate
        marks-nvim
        todo-comments-nvim
        nvim-surround
        diffview-nvim
        eyeliner-nvim
        nvim-lint
        conform-nvim
        bufferline-nvim
      ];
      lsp = {
        default = with pkgs.vimPlugins; [
          #nvim-jdtls
          #none-ls-nvim
          nvim-lspconfig
          lazydev-nvim
          cmp-nvim-lsp
        ];
      };
      telescope = {
        default = with pkgs.vimPlugins; [
          telescope-nvim
          telescope-fzf-native-nvim #zf fzy
          telescope-undo-nvim
          telescope-symbols-nvim
          telescope-emoji-nvim
          telescope-github-nvim
          telescope-git-conflicts-nvim
          telescope-coc-nvim
          telescope-dap-nvim
          telescope-undo-nvim
          telescope-zoxide
          plenary-nvim
          popup-nvim
          project-nvim
          telescope-media-files-nvim
        ];
        nix = with pkgs.vimPlugins; [ telescope-manix ];
      };
      cmp = {
        default = with pkgs.vimPlugins; [
          #recommended
            nvim-cmp
            luasnip
            friendly-snippets
            lspkind-nvim
            cmp-buffer
            cmp-cmdline
            cmp-cmdline-history
            cmp-nvim-lsp
            cmp-nvim-lsp-signature-help
            cmp-nvim-lua
            cmp-path
            cmp_luasnip
          #extra
            cmp-dictionary
            cmp-zsh
            cmp-vimwiki-tags
            cmp-latex-symbols
            cmp-ai
            cmp-dap
            cmp-git
            cmp-calc
            cmp-emoji
            cmp-ctags
        ];
        latex = with pkgs.vimPlugins; [
          luasnip-latex-snippets-nvim
        ];
      };
      treesitter = {
        default = with pkgs.vimPlugins; [
          nvim-treesitter.withAllGrammars
          nvim-treesitter-textobjects
          nvim-ts-autotag #html
          nvim-ts-context-commentstring
          comment-nvim
        ];
      };
      debug = {
        default = with pkgs.vimPlugins; [
          nvim-dap
          nvim-dap-ui
          nvim-dap-virtual-text
        ];
        python = with pkgs.vimPlugins; [ nvim-dap-python ];
        go = with pkgs.vimPlugins; [ nvim-dap-go ];
      };
      git = with pkgs.vimPlugins; [
        gitsigns-nvim
        #neogit
        #lazygit-nvim
      ];
      ai = with pkgs.vimPlugins;
        [
          ChatGPT-nvim
          #copilot-lua
        ] ++ 
        [
          (mkNvimPlugin customPackages.x86_64-linux.gp-nvim "gp.nvim")
        ];
      markdown = with pkgs.vimPlugins; [
        vimwiki
        markdown-preview-nvim
      ];
      rust = with pkgs.vimPlugins; [
        rustaceanvim
      ];
      latex = with pkgs.vimPlugins; [
        vimtex
      ];
      lilypond = with pkgs.vimPlugins; [
        nvim-lilypond-suite
      ];
    };
  };
in
  categoryDefinitions
