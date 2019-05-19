with import <nixpkgs> {};

let
    sebcat_deriv = stdenv.mkDerivation rec {
        name = "sebcat";
        builder = "${bash}/bin/bash";
        args = [ ./nix-builder.sh ];
        inherit coreutils openssl libyaml;
        system = builtins.currentSystem;
        schemapath = ../../schemas;
        sebcatpath = ./sebcat;
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
    tag = "0.1.8a45";

    contents = sebcat_deriv;

    config = {
        Cmd = [ "sebcat" ];
        Entrypoint = [ entrypoint ];
        ExposedPorts = {
            "4949/tcp" = {};
        };
        WorkingDir = "/";
    };
}
