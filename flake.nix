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
          lua-language-server
          nixd
          stylua          
        ];
      };
      startupPlugins = {
        gitPlugins = with pkgs.neovimPlugins; [ ];
        general = with pkgs.vimPlugins; [
          #lze
          alpha-nvim

        ];
      };
      optionalPlugins = {
        gitPlugins = with pkgs.neovimPlugins; [ ];
        general = with pkgs.vimPlugins; [ ];
      };
      sharedLibraries = {
        general = with pkgs; [
        ];
      };
    };
    packageDefinitions = {
      nvim = {pkgs , ... }: {
        settings = {
          wrapRc = true;
          aliases = [ "vim" "vi" ];
        };
        categories = {
          general = true;
          startupPlugins.general = true;
        };
      };
    };
    defaultPackageName = "nvim";
    dependencyOverlays = { };
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
