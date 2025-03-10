{ pkgs ? import <nixpkgs> } : rec {
  gp-nvim = pkgs.callPackage ./gp-nvim.nix { };
}
