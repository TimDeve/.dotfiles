{
  description = "Doom Emacs";
  inputs = {
    nix-doom-emacs-unstraightened.url = "github:marienz/nix-doom-emacs-unstraightened";
  };
  outputs =
    { self, nix-doom-emacs-unstraightened }:
    {
      paths-maker =
        {nixpkgs-inputs, ...}:
        let
          pkgs = import nixpkgs-inputs.unstable {
            system = "x86_64-linux";
            overlays = [ nix-doom-emacs-unstraightened.overlays.default ];
            config.allowUnfree = true;
          };
        in
        [
          (pkgs.emacsWithDoom {
            doomDir = pkgs.lib.cleanSource ./doom.d;
            emacs = pkgs.emacs-nox;
            doomLocalDir = "~/.local/share/nix-doom";
          })
        ];
    };
}
