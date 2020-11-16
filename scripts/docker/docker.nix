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
    tag = "0.5.0";
    created = "now";

    fromImage = pkgs.dockerTools.pullImage {
        imageName = "equill/syscat";
        finalImageTag = "0.3.0";
        imageDigest = "sha256:dde8b97c72ed4f24693eb901d2bb8cee14e156e5d0aa63515bb8f8c32d59979c";
        sha256 = "0l3zlqawsllmrz8jaka0rja1036nv3m3ypnwhq687k9lki51y4l2";
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
