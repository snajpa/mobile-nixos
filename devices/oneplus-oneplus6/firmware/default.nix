{ pkgs, fetchFromGitLab, ... }:

with pkgs;

stdenv.mkDerivation rec {
  name = "oneplus-sdm845-firmware";
  src = fetchFromGitLab {
    owner = "sdm845-mainline";
    repo = "firmware-oneplus-sdm845";
    rev = "3ec855b2247291c79652b319dfe93f7747363c86";
    sha256 = "sha256-7CaXWOpao+vuFA7xknzbLml2hxTlmuzFCEM99aLD2uk=";
  };
  installPhase = ''
    mkdir -p $out/lib/firmware
    cp -r lib/firmware/* $out/lib/firmware/
    chmod +w -R $out
    rm -rf $out/lib/firmware/postmarketos
    cp -r lib/firmware/postmarketos/* $out/lib/firmware
    # copy these things too so initrd can use them
  '';
}