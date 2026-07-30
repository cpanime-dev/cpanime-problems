{
  description = "The problems of CpAnime project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    cplib = {
      url = "github:rindag-devs/cplib/single-header-snapshot";
      flake = false;
    };
    hull = {
      url = "github:rindag-devs/hull";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.cplib.follows = "cplib";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      hull,
      cplib,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSystem = nixpkgs.lib.genAttrs supportedSystems;

    in
    {
      hullProblems = forEachSystem (
        system:
        let
          h = hull.libForSystem system;
          entries = builtins.readDir ./problems;
          problemDirs = builtins.filter (name: builtins.pathExists (./problems + "/${name}/problem.nix")) (
            builtins.attrNames entries
          );
        in
        builtins.listToAttrs (
          map (name: {
            inherit name;
            value = (h.evalProblem (./problems + "/${name}/problem.nix") { });
          }) problemDirs
        )
      );

      devShells = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          hullPackages = hull.packages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = [
              hullPackages.default
            ];

            env = {
              CPLUS_INCLUDE_PATH = toString cplib;
            };
          };
        }
      );
    };
}
