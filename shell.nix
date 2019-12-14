{ pkgs ? import ./pin.nix }:
pkgs.mkShell{
    buildInputs = [
        (pkgs.idrisPackages.with-packages [ pkgs.idrisPackages.sdl2 ])
        pkgs.inotify-tools
        pkgs.haskellPackages.idringen
        pkgs.SDL2
        pkgs.SDL2_gfx
    ];
}

