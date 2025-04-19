{ pkgs ? import <nixpkgs> } : rec {
  gp-nvim = pkgs.callPackage ./gp-nvim.nix { };
  feed-nvim = pkgs.callPackage ./feed-nvim.nix { };
  coop-nvim = pkgs.callPackage ./coop-nvim.nix { };
}
