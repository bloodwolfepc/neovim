{ nixpkgs, outputs, inputs }: 
let
  categoryDefinitions = import ./categoryDefinitions.nix { inherit outputs inputs; };
  packageDefinitions = import ./packageDefinitions.nix { inherit nixpkgs; };
in {
  inherit categoryDefinitions packageDefinitions;
}
