# SPDX-License-Identifier: MIT
{ pkgs }:
let
  stage3 = import ../tests/gentoo.nix { inherit pkgs; };
  eselect =
    pkgs.runCommand "eselect-1.4.32"
      {
        nativeBuildInputs = [
          pkgs.gnutar
          pkgs.xz
        ];
      }
      ''
        mkdir -p $out
        tar xf ${stage3} -C $out ./usr/bin/eselect ./usr/share/eselect
        mv $out/usr/* $out/
        rmdir $out/usr
        substituteInPlace $out/bin/eselect --replace-fail '/usr/share/eselect' "$out/share/eselect"
        patchShebangs $out/bin
      '';
in
{
  inherit eselect;
  package = pkgs.stdenv.mkDerivation {
    pname = "paludis";
    version = "3.0.2";
    src = pkgs.fetchgit {
      url = "https://gitlab.exherbo.org/paludis/paludis.git";
      rev = "a146dc441c7e0a5327d79b82ad793d802b97f50e";
      hash = "sha256-HCIrcNS/zF3dY38C70EvHr7ZhTv6x+qF8lKixn1Q14c=";
    };
    nativeBuildInputs = [
      pkgs.cmake
      pkgs.pkg-config
      pkgs.m4
      pkgs.python3
      pkgs.asciidoc
      pkgs.xmlto
      pkgs.html-tidy
      pkgs.docbook_xml_dtd_45
      pkgs.docbook_xsl
      eselect
    ];
    buildInputs = [ pkgs.file ];
    postPatch = ''
      patchShebangs misc paludis src
    '';
    cmakeFlags = [
      "-DCMAKE_INSTALL_SYSCONFDIR=/etc"
      "-DENABLE_GTEST=OFF"
      "-DENABLE_STRIPPER=ON"
      "-DUSE_PREBUILT_DOCUMENTATION=OFF"
      "-DPALUDIS_ENVIRONMENTS=paludis;portage"
      "-DCONFIG_FRAMEWORK=${eselect}/bin/eselect"
    ];
    # Object libraries consume generated core headers without a native CMake edge.
    preBuild = ''
      cmake --build . --target libpaludis_SE libpaludisutil_SE libpaludisutil_NN -j"$NIX_BUILD_CORES"
    '';
    enableParallelBuilding = true;
    meta.license = pkgs.lib.licenses.gpl2Only;
  };
}
