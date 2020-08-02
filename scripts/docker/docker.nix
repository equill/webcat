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
    tag = "0.4.0a6";
    created = "now";

    fromImage = pkgs.dockerTools.pullImage {
        imageName = "equill/syscat";
        finalImageTag = "0.2.0a2";
        imageDigest = "sha256:98832a638956b1c1379766c1867be8eb05fff63b122d8f2f24129363039e4a24";
        sha256 = "19cf830547aced0e647c05a55d37bb8508a9fb1279f40ccf8cc137bfc1283c51";
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
