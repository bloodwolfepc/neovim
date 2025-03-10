/*
  goal: pass a package defined from outputs.customPackages to
  a packagedef
  breakdown

  outputs = {pkgs}@inputs: let
    utils
    luapath
    forEachSystem
    categoryDefinitions
      (packagedef here)
    extraCats
    packageDefinitions
    defaultPackageName
    dependencyOverlays
    extra_pkg_config
  in

  #forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
  #covered in: https://github.com/BirdeeHub/nixCats-nvim/blob/1a25029a1aea23569499575bac02dd1e83a795a7/nixCatsHelp/nixCats_format.txt#L788

  forEachSystem (system: let
    nixCatsBuilder = utils.baseBuilder luaPath {
      inherit nixpkgs system dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions;
    defaultPackage = nixCatsBuilder defaultPackageName;
    pkgs = import nixpkgs { inherit system; };
  in {
    pkgs' = forEachSystem (pkgs: import ./packages { inherit pkgs; });
    packages = utils.mkAllWithDefault defaultPackage;
    devShells = {
      default = pkgs.mkShell {
        name = defaultPackageName;
        packages = [ defaultPackage ];
        inputsFrom = [ ];
        shellHook = ''
        '';
      };
    };
  }) // (let
    nixosModule = utils.mkNixosModules {
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
    homeModule = utils.mkHomeModules {
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
  in {
    overlays = utils.makeOverlays luaPath {
      inherit nixpkgs dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions defaultPackageName;

    nixosModules.default = nixosModule;
    homeModules.default = homeModule;

    inherit utils nixosModule homeModule;
    inherit (utils) templates;
  });
*/

{
  description = "mew";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
  };
  outputs = { self, nixpkgs, nixCats, ... }@inputs: let
    inherit (nixCats) utils;
    luaPath = "${./.}";
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
    categoryDefinitions = { pkgs, settings, categories, extra, name, mkNvimPlugin, ... }@packageDef: {
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
            #gp-nvim
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
      };
    };
    extraCats = {
      debug = [ "debug" "default" ]; #implicit
      markdown = [ "markdown" ];
      rust = [ "rust" ];
      python = [ "debug" ];
      go = [ "debug" ];
    };
    packageDefinitions = {
      nvim = {pkgs , ... }: {
        settings = {
          wrapRc = true;
          configDirName = "nixCats-nvim";
          aliases = [ "vim" "vi" ];
        };
        categories = {
          #default
            general = true;
            telescope = true;
            cmp = true;
            treesitter = true;
            debug = true;
            git = true;
            ai = true;
            lsp = true;
          #ft
            nix = true;
            lua = true;
            markdown = true;
            latex = true;
            yaml = true;
            rust = true;
        };
        extra = {
          nixdExtras = {
            nixpkgs = nixpkgs;
          };
        };
      };
    };
    defaultPackageName = "nvim";
    dependencyOverlays = [ (utils.standardPluginOverlay inputs) ];
    extra_pkg_config = { };
  in
  forEachSystem (system: let
    nixCatsBuilder = utils.baseBuilder luaPath {
      inherit nixpkgs system dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions;
    defaultPackage = nixCatsBuilder defaultPackageName;
    pkgs = import nixpkgs { inherit system; };
  in {
    packages = utils.mkAllWithDefault defaultPackage;
    devShells = {
      default = pkgs.mkShell {
        name = defaultPackageName;
        packages = [ defaultPackage ];
        inputsFrom = [ ];
        shellHook = ''
        '';
      };
    };
  }) // (let
    nixosModule = utils.mkNixosModules {
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
    homeModule = utils.mkHomeModules {
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
  in {
    overlays = utils.makeOverlays luaPath {
      inherit nixpkgs dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions defaultPackageName;

    nixosModules.default = nixosModule;
    homeModules.default = homeModule;

    inherit utils nixosModule homeModule;
    inherit (utils) templates;
  });

}
