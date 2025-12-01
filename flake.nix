{
  description = "Pulumi Python + Google Cloud Development Shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # Support standard Linux and Darwin systems
      systems = [
        "x86_64-linux"
        #"aarch64-linux"
        #"aarch64-darwin"
        #"x86_64-darwin"
      ];

      perSystem =
        { pkgs, ... }:
        {
          devShells.default =
            let

              python = pkgs.python313;

            in
            pkgs.mkShell {
              # The tools available in your shell
              packages = with pkgs; [

                (python.withPackages (
                  ps: with ps; [
                    # python dependencies here
                    #pulumi

                  ]
                ))

                pulumi-bin # Infrastructure as Code tool
                pulumiPackages.pulumi-python
                google-cloud-sdk # GCP CLI (needed for authentication)
                #uv # Fast Python package installer (modern replacement for pip/poetry)
              ];

              /*
                env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
                  pkgs.stdenv.cc.cc.lib
                  pkgs.libz
                ];
              */

              # Instructions printed when entering the shell
              shellHook = /* bash */ ''
                echo "☁️  Pulumi Python + GCP Shell Activated"
                echo "1. Authenticate GCP: gcloud auth application-default login"
              '';
            };
        };
    };
}
