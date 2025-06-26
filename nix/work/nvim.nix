nixpkgs:
with nixpkgs;
let
  nvim = neovim.override {
    withNodeJs = true;
  };
  binDeps = [
    # Language Servers
    buf
    python312Packages.python-lsp-server
    rust-analyzer
    gopls
    lua-language-server
    postgres-lsp
    clang-tools

    # Runtimes
    cargo
    delve
    deno
    lua51Packages.lua
    lua51Packages.luarocks
    nodejs
    php83
    rustc
    tree-sitter
    typescript-language-server
    yarn

    # Utils
    fd
    fzf
    gci
    ripgrep
    yq-go
  ];
in
[
  (writeShellApplication {
    name = "nvim";
    inheritPath = true;
    runtimeEnv = {
      # Adds C/C++ std libs for plugins that dynlink against them
      LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib ];
    };
    runtimeInputs = [ nvim ] ++ binDeps;
    text = ''nvim "$@"'';
  })
]
