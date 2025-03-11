{ nixpkgs }: let
#let
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
          lilypond = true;
      };
      extra = {
        nixdExtras = {
          nixpkgs = nixpkgs;
        };
      };
    };
  };
in
  packageDefinitions

