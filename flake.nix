{
  description = "Otter Docs development flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        # this would be removed once Typst reaches 0.15, or 1.0, or something else
        typst = pkgs.rustPlatform.buildRustPackage rec {
          pname = "typst";
          version = "git";

          src = pkgs.fetchFromGitHub {
            owner = "typst";
            repo = "typst";
            rev = "de6f400976f9bf6ab8b923d13a068722959d0070";
            sha256 = "sha256-8MUfTHxrHolg60MC8dM8FlHACLA4tSGDjlyUhqdf1EY=";
          };

          cargoLock.lockFile = src + "/Cargo.lock";
          cargoLock.outputHashes = {
            "codex-0.2.0" = "sha256-yPhL3yV9R9qUjJ3nqfUY99hoqwwGGdZ4HbpdcspXbrk=";
            "krilla-0.6.0" = "sha256-DW0l6radzJ99JJPdE/O5RT747/BHH1bv94vtgBUO2N0=";
            "typst-assets-0.14.2" = "sha256-rt/4/NAdfxfxMjzkAsDGCYofUz+dh92gOFdvHNcut8w=";
            "typst-dev-assets-0.14.2" = "sha256-2GGAoFVa87eO55MqahX+8Dg4hTwIqqIrnhZZcl9ACO4=";
          };

          nativeBuildInputs = [
            pkgs.pkg-config
          ];

          buildInputs = [
            pkgs.openssl
          ];
        };

      in
      {
        devShells.default = pkgs.mkShell { packages = [ typst ]; };
      }
    );
}
