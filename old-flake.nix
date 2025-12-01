{
  description = "KSV pulumi project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      gitignore,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        inherit (gitignore.lib) gitignoreSource;
        pkgs = import nixpkgs {
          inherit system;
        };

      in
      {

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            #pulumi
            python3
            pulumi-bin
            pulumiPackages.pulumi-python
            #awscli2
            uv

          ];

          env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            pkgs.stdenv.cc.cc.lib
            pkgs.libz
          ];

          shellHook = ''
            echo "welcome to the pulumi shell created by https://github.com/vivekanandan-ks" | ${pkgs.cowsay}/bin/cowsay
            #my custom fish shel prompt customized (comment below to use defualt bash)

          '';
        };
      }
    );
}
