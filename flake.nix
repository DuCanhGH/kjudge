{
  inputs.nixpkgs.url = github:nixOS/nixpkgs/nixpkgs-unstable;
  inputs.flake-utils.url = github:numtide/flake-utils;

  outputs = { self, nixpkgs, flake-utils, ... }@inputs: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    with pkgs.lib;
    rec {
      packages.kjudge-templates = (import ./nix/frontend.nix {
        inherit pkgs;
      });
      packages.isolate = (import ./nix/isolate.nix { inherit pkgs; });
      packages.kjudge = (import ./nix/backend.nix {
        inherit pkgs;
        templates = packages.kjudge-templates;
      });
      devShell = pkgs.mkShell {
        packages = with pkgs; [
          # For Go
          go_1_18
          gopls
          # For Node.js
          nodejs
          yarn
        ];
      };
    });
}

