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
    tag = "0.6.1";
    created = "now";

    fromImage = pkgs.dockerTools.pullImage {
        imageName = "equill/restagraph";
        finalImageTag = "0.6.6";
        imageDigest = "sha256:1cd32f8ce1282a9781228b865ea53834e188f10467438b840962f910f0ff1177";
        sha256 = "01ka2sv7inwl0krzxj65bg78dwiw7pihrbvz9f4q2vi2a9ryrfdb";
    };
    contents = [
        sebcat_deriv
        bash
        coreutils
        file
        iproute
        tcpdump
        which
    ];

    config = {
        Cmd = [ "restagraph" ];
        Entrypoint = [ entrypoint ];
        ExposedPorts = {
            "4949/tcp" = {};
        };
        WorkingDir = "/";
    };
}
