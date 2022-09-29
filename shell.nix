{ sources ? import ./nix/sources.nix
, pkgs ? import sources.nixpkgs {}
}:

let
  zig = pkgs.stdenv.mkDerivation {
    name = "zig";
    src = sources.zig;
    installPhase = ''
      mkdir -p $out/bin
      mv zig $out/bin
      mv lib $out
    '';
    dontStrip = true;
  };
in pkgs.mkShell {
  buildInputs = [
    zig
    pkgs.zls
    pkgs.niv
    pkgs.imagemagick
  ];
}
