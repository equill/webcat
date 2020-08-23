with import <nixpkgs> {};

let
    sebcat_deriv = stdenv.mkDerivation rec {
        name = "sebcat";
        builder = "${bash}/bin/bash";
        args = [ ./nix-builder.sh ];
        inherit coreutils openssl libyaml;
        system = builtins.currentSystem;
        schemapath = ../../schemas;
    };

    ld_path = stdenv.lib.makeLibraryPath [
         pkgs.openssl
         pkgs.libyaml
     ];

    entrypoint = writeScript "entrypoint.sh" ''
    #!${stdenv.shell}
    export LD_LIBRARY_PATH=${ld_path}
    exec $@
    '';

in
pkgs.dockerTools.buildImage {
    name = "equill/sebcat";
    tag = "0.4.0a19";
    created = "now";

    fromImage = pkgs.dockerTools.pullImage {
        imageName = "equill/syscat";
        finalImageTag = "0.2.0a25";
        imageDigest = "sha256:792d92ebe45079e78f96382554ba1a9da95e9b27ae3d5bfaf2997463e6be6fa9";
        sha256 = "15f42hq85zfm86iv58nbv2ryvxx31w7j5qmhm77lc9pywr2k2cja";
    };
    contents = [ sebcat_deriv bash file coreutils which ];

    config = {
        Cmd = [ "syscat" ];
        Entrypoint = [ entrypoint ];
        ExposedPorts = {
            "4949/tcp" = {};
        };
        WorkingDir = "/";
    };
}
