with import <nixpkgs> {};

let
    mytaxsys_deriv = stdenv.mkDerivation rec {
        name = "mytaxsys";
        builder = "${bash}/bin/bash";
        args = [ ./nix-builder.sh ];
        inherit coreutils openssl libyaml;
        system = builtins.currentSystem;
        schemapath = ../../schemas;
        mytaxsyspath = ./mytaxsys;
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
    name = "equill/mytaxsys";
    tag = "0.1.6";

    contents = mytaxsys_deriv;

    config = {
        Cmd = [ "mytaxsys" ];
        Entrypoint = [ entrypoint ];
        ExposedPorts = {
            "4949/tcp" = {};
        };
        WorkingDir = "/";
    };
}
