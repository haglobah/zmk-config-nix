{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    zmk-nix = {
      url = "github:lilyinstarlight/zmk-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      flake-parts,
      nixpkgs,
      zmk-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.attrNames zmk-nix.packages;

      perSystem =
        { pkgs, inputs', ... }:
        {
          packages = rec {
            default = firmware;

            firmware = inputs'.zmk-nix.legacyPackages.buildSplitKeyboard {
              name = "firmware";

              src = nixpkgs.lib.sourceFilesBySuffices inputs.self [
                ".board"
                ".cmake"
                ".conf"
                ".defconfig"
                ".dts"
                ".h"
                ".dtsi"
                ".json"
                ".keymap"
                ".overlay"
                ".shield"
                ".yml"
                "_defconfig"
              ];

              board = "nice_nano@2.0.0";
              shield = "rae_dux_%PART%";

              zephyrDepsHash = "sha256-mUJpGWlU+rGbcWtKs/SuombCJ3RcIDMTiuMicwLX1D4=";

              meta = {
                description = "ZMK firmware";
                license = nixpkgs.lib.licenses.mit;
                platforms = nixpkgs.lib.platforms.all;
              };
            };

            flash = inputs'.zmk-nix.packages.flash.override { inherit firmware; };
            update = inputs'.zmk-nix.packages.update;
          };

          devShells.default = pkgs.mkShell {
            inputsFrom = [ inputs'.zmk-nix.devShells.default ];
            packages = [ pkgs.just ];
          };
        };
    };
}
