{
  description = "Work Flake";
  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = system;
        config.allowUnfree = true;
      };
    in
    {
      defaultPackage."${system}" = pkgs.buildEnv {
        name = "work";
        paths = import ./nix-scripts.nix pkgs ++ import ./nvim.nix pkgs ++ import ./pkgs.nix pkgs;
      };
    };
}
