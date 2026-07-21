{
  description = "Haita development flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.typst
            pkgs.pagefind
            pkgs.just
            pkgs.ripgrep
          ];
        };
        # for converting Typst to Markdown
        devShells.prepareRelease = pkgs.mkShell {
          packages = [ pkgs.pandoc ];
        };
      }
    );
}
