{ pkgs ? import ./pin.nix }:
pkgs.mkShell{
    buildInputs = [
        pkgs.idris
        pkgs.inotify-tools
    ];
}

