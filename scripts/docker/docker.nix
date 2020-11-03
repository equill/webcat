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
    tag = "0.4.0";
    created = "now";

    fromImage = pkgs.dockerTools.pullImage {
        imageName = "equill/syscat";
        finalImageTag = "0.2.0";
        imageDigest = "sha256:dd8aecb591edce51ee890e012df983dd9f7761fb1a073b4d3648519ae05d07f4";
        sha256 = "0gjgf94prgmndhpjg7hak7f3ywadjzkllza6d3yydni7ycyn6y9q";
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
