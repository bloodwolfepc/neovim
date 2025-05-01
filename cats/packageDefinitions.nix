{ nixpkgs }:
let
  packageDefinitions =
    let
      settings = {
        wrapRc = true;
        configDirName = "nixCats-nvim";
        aliases = [
          "vim"
          "vi"
        ];
      };
      extra = {
        nixdExtras = {
          nixpkgs = nixpkgs;
        };
      };
      essential = {
        general = true;
        telescope = true;
        cmp = true;
        treesitter = true;
        debug = true;
        format = true;
        git = true;
        ai = true;
        lsp = true;
        bash = true;
        nix = true;
        lua = true;
        yaml = true;
        json = true;
        scheme = true;
      };
    in
    {
      nvim =
        { pkgs, ... }:
        {
          inherit settings extra;
          categories = {
            c = true;
            python = true;
            rust = true;
            markdown = true;
            latex = true;
            lilypond = true;
            html = true;
            css = true;
          } // essential;
        };
      minimal =
        { pkgs, ... }:
        {
          inherit settings extra;
          categories = { } // essential;
        };
    };
in
packageDefinitions

#extraExtensiveLangs
#extensiveLangs
#plaintextLangs
#essentialLangs,bash,lua
