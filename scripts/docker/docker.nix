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
    tag = "0.6.2";
    created = "now";

    fromImage = pkgs.dockerTools.pullImage {
        imageName = "equill/restagraph";
        finalImageTag = "0.6.8";
        imageDigest = "sha256:da0d2a832fc199c51f632c3e6a2a91c1238070b489182d48201960f68243836f";
        sha256 = "1grjbzw5859mygmv9mgrnmmkaa2605il0968i5ss5n4nwc8n5s0x";
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
