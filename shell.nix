with import <nixpkgs> {};

stdenv.mkDerivation rec {
    name = "sebcat";

    buildInputs = [
        # Lisp env
        pkgs.gcc
        pkgs.libyaml
        pkgs.openssl
        pkgs.sbcl
        # Python env
        pkgs.python3
        pkgs.python37Packages.requests
        pkgs.python37Packages.pylint
    ];

    env = buildEnv {
        name = name;
        paths = buildInputs;
    };

    shellHook = "export PS1='\n\\[\\033[01;32m\\][nix sebcat] \\w\\$\\[\\033[00m\\] '";

    LD_LIBRARY_PATH = stdenv.lib.makeLibraryPath [
        pkgs.openssl
        pkgs.libyaml
    ];

}
