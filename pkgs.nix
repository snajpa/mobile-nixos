let
  sha256 = "sha256:00ac3axj7jdfcajj3macdydf9w9bvqqvgrqkh1xxr3rfi9q2fz1v";
  rev = "f1c167688a6f81f4a51ab542e5f476c8c595e457";
in
builtins.trace "(Using pinned Nixpkgs at ${rev})"
import (fetchTarball {
  url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  inherit sha256;
})
