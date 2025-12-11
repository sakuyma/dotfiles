{ pkgs ? import <nixpkgs> { }, lib, ... }: pkgs.stdenv.mkDerivation rec {
  pname = "hyprquickshot";
  version = "0.1.0";

  nativeBuildInputs = with pkgs; [
    makeWrapper
  ];
  buildInputs = with pkgs; [
    quickshell
    grim
    imagemagick
    wl-clipboard
  ];

  src = pkgs.lib.cleanSource ./.;

  installPhase = ''
    mkdir -p $out/bin

    mv icons shaders src shell.qml $out

    echo "#!/usr/bin/env sh" > $out/bin/hyprquickshot
    echo "quickshell -p $out" >> $out/bin/hyprquickshot
    chmod +x $out/bin/hyprquickshot

    wrapProgram $out/bin/hyprquickshot \
      --set PATH "$PATH:${lib.makeBinPath [
        pkgs.quickshell
        pkgs.grim
        pkgs.imagemagick
        pkgs.wl-clipboard
      ]}"
  '';
}
