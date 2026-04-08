{
  description = "Doom Emacs";
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/=0.2511.907408";
    nix-doom-emacs-unstraightened.url = "github:marienz/nix-doom-emacs-unstraightened?rev=fa2ccf9e35b7f5c99f28a50938c8db951531f544";
  };
  outputs =
    {
      self,
      nixpkgs,
      nix-doom-emacs-unstraightened,
    }:
    {
      lib.packages = self.paths-maker;
      paths-maker =
        {
          system,
          profile-name ? "nix/default",
          ...
        }:
        with import nixpkgs {
          system = system;
          overlays = [ nix-doom-emacs-unstraightened.overlays.default ];
        };
        let
          doom = emacsWithDoom {
            emacs = emacs-nox;
            doomDir = lib.cleanSource ./doom.d;
            doomLocalDir = "~/.local/share/nix-doom";
          };
        in
        [
          (
            if profile-name == "nix/work" then
              (writeShellApplication {
                name = "emacs";
                inheritPath = true;
                runtimeEnv = {
                  # Adds sssd for home to work
                  LD_LIBRARY_PATH = lib.makeLibraryPath [ sssd ];
                };
                runtimeInputs = [ doom ];
                text = ''emacs "$@"'';
              })
            else
              doom
          )
        ];
    };
}
