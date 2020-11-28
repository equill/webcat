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
    tag = "0.6.0a1";
    created = "now";

    fromImage = pkgs.dockerTools.pullImage {
        imageName = "equill/restagraph";
        finalImageTag = "0.6.5a1";
        imageDigest = "sha256:5d241a1aaa3175601521478e4b6760eefbd347a71b531ef16fb6ed67738adb73";
        sha256 = "0hfccr8d3dci6w2jphf87q8945p58p1m53m1s13m61sqwx5b7970";
    };
    contents = [ sebcat_deriv bash file coreutils which tcpdump ];

    config = {
        Cmd = [ "restagraph" ];
        Entrypoint = [ entrypoint ];
        ExposedPorts = {
            "4949/tcp" = {};
        };
        WorkingDir = "/";
    };
}
