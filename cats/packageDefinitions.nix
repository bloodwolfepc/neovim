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
          c = true;
          bash = true;
          rust = true;
          markdown = true;
          latex = true;
          lilypond = true;
          yaml = true;
          json = true;
          html = true;
          css = true;
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

