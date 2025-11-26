# Install with `nix profile add ~/.dotfiles/nix/nzxt`
{
  description = "NZXT Flake";
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    doom.url        = "path:../shared/doom";
    nix-scripts.url = "path:../shared/nix-scripts";
  };
  outputs =
    {
      self,
      nixpkgs-unstable,
      doom,
      nix-scripts,
    }:
    let
      system = "x86_64-linux";
      pkgs-defaults = pkgs:
        import pkgs {
          system = system;
          config.allowUnfree = true;
        };
      pkgs = {
        unstable = pkgs-defaults nixpkgs-unstable;
      };
      paths-maker-args = {
        profile-name = "nix/nzxt";
        pkgs = pkgs;
        nixpkgs-inputs = {
          unstable = nixpkgs-unstable;
        };
      };
    in
    {
      defaultPackage."${system}" = pkgs.unstable.buildEnv {
        name = "home";
        paths =
          import ./pkgs.nix pkgs
          ++ nix-scripts.paths-maker paths-maker-args
          ++ doom.paths-maker paths-maker-args
        ;
      };
    };
}
