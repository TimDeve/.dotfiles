# Install with `nix profile add ~/.dotfiles/nix/work`
{
  description = "Work Flake";
  inputs = {
    nixpkgs-unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/*";

    flake-utils.url = "https://flakehub.com/f/numtide/flake-utils/0.1";
    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*";

    nvim.url = "path:../shared/nvim";
    nix-scripts.url = "path:../shared/nix-scripts";
  };
  outputs =
    {
      self,
      nixpkgs-unstable,
      nixpkgs-stable,
      nvim,
      nix-scripts,
      flake-utils,
      fh,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs-defaults =
          pkgs:
          import pkgs {
            system = system;
            config.allowUnfree = true;
          };
        pkgs = {
          unstable = pkgs-defaults nixpkgs-unstable;
          stable = pkgs-defaults nixpkgs-stable;
        };
        paths-maker-args = {
          inherit pkgs system;
          profile-name = "nix/" + self.packages.${system}.default.name;
          nixpkgs-inputs = {
            unstable = nixpkgs-unstable;
          };
        };
      in
      {
        defaultPackage = self.packages.${system}.default;
        packages.default = pkgs.unstable.buildEnv {
          name = "work";
          paths =
            import ./pkgs.nix pkgs
            ++ [fh.packages.${system}.default]
            ++ nvim.paths-maker paths-maker-args
            ++ nix-scripts.paths-maker paths-maker-args;
        };
      }
    );
}
