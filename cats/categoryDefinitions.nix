{ outputs, inputs }:
let
  categoryDefinitions =
    let
      inherit (outputs) customPackages;
      system = "x86_64-linux";
    in
    {
      pkgs,
      settings,
      categories,
      extra,
      name,
      mkNvimPlugin,
      ...
    }@packageDef:
    {

      environmentVariables = {
        lilypond = {
          default = {
            LILYDICTPATH = "${pkgs.vimPlugins.nvim-lilypond-suite}/lilywords";
          };
        };
      };

      lspsAndRuntimeDeps = {
        general = with pkgs; [
          universal-ctags
          ripgrep
          fd
          stdenv.cc.cc
          nix-doc

          pandoc # for feed
          eslint

          taskwarrior3
        ];
        telescope = {
          default = with pkgs; [
            zoxide
            gh
          ];
          nix = with pkgs; [ manix ];
        };
        nix = with pkgs; [
          nixd
          nixfmt-rfc-style
        ];
        lua = with pkgs; [
          lua-language-server
          stylua
        ];
        rust = with pkgs; [
          cargo
          rustc
          rust-analyzer
          rustfmt
        ];
        c = with pkgs; [ clang-tools ];
        bash = with pkgs; [ bash-language-server ];
        python = with pkgs; [ pyright ];
        go = with pkgs; [ gopls ];
        yaml = with pkgs; [ yaml-language-server ];
        json = with pkgs; [ vscode-langservers-extracted ];
        html = with pkgs; [ vscode-langservers-extracted ];
        css = with pkgs; [
          vscode-langservers-extracted
          tailwindcss-language-server
        ];
        markdown = with pkgs; [
          marksman
          python313Packages.pylatexenc
        ];
        scheme = with pkgs; [
          #mitscheme
          chez
          scheme-manpages
          akkuPackages.akku
          akkuPackages.scheme-langserver
        ];
        latex = with pkgs; [
          texlab
          texliveFull
          texlivePackages.latexmk
          zathura
        ];
        lilypond =
          with pkgs;
          [
            lilypond
            python312Packages.python-ly
            mpv
            ffmpeg
            timidity
            fluidsynth
            soundfont-fluid
            soundfont-ydp-grand
            zathura
          ]
          ++ [
            inputs.lilypond-midi-input.defaultPackage.${system}
          ];
      };

      startupPlugins = {
        general = with pkgs.vimPlugins; [
          lze
          lzextras
          alpha-nvim
          which-key-nvim
          plenary-nvim
          tmux-navigator
          tmux-nvim
        ];
      };
      optionalPlugins = {
        general =
          with pkgs.vimPlugins;
          [
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

            #null-ls-nvim

            taskwarrior3
            taskwiki

          ]
          ++ [
            (mkNvimPlugin customPackages.${system}.feed-nvim "feed.nvim")
            (mkNvimPlugin customPackages.${system}.coop-nvim "coop.nvim")
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
            telescope-fzf-native-nvim # zf fzy
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
            nvim-ts-autotag # html
            nvim-ts-context-commentstring
            comment-nvim
            render-markdown-nvim
            nvim-treesitter-parsers.markdown
            nvim-treesitter-parsers.markdown_inline
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
        ai =
          with pkgs.vimPlugins;
          [
            ChatGPT-nvim
            avante-nvim
            codecompanion-nvim
            #copilot-lua
          ]
          ++ [
            (mkNvimPlugin customPackages.${system}.gp-nvim "gp.nvim")
          ];
        markdown = with pkgs.vimPlugins; [
          vimwiki
          markdown-preview-nvim
          #treesitter
          nvim-treesitter-parsers.markdown
          nvim-treesitter-parsers.markdown_inline
          render-markdown-nvim
        ];
        rust = with pkgs.vimPlugins; [ rustaceanvim ];
        latex = with pkgs.vimPlugins; [ vimtex ];
        lilypond =
          with pkgs.vimPlugins;
          [ nvim-lilypond-suite ]
          ++ [
            (mkNvimPlugin customPackages.${system}.midi-input-nvim "midi-input.nvim")
          ];
      };
    };
in
categoryDefinitions
