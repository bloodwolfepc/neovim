{ nixpkgs, outputs }: 
let
  categoryDefinitions = import ./categoryDefinitions.nix { inherit outputs; };
  packageDefinitions = import ./packageDefinitions.nix { inherit nixpkgs; };
in {
  inherit categoryDefinitions packageDefinitions;
}
