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
    tag = "0.4.0a25";
    created = "now";

    fromImage = pkgs.dockerTools.pullImage {
        imageName = "equill/syscat";
        finalImageTag = "0.2.0a27";
        imageDigest = "sha256:094383666aaaf174b7d136e617570a44e095b14e7d442dceeb5e3f14c504b0bb";
        sha256 = "19770533nfgdhb56bvvg099if4jqg4wdswip2wmjrcrvfnx8xhcg";
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
