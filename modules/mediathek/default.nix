{ pkgs, ... }:

let
  mediathek = pkgs.writers.writePython3Bin "mediathek" {
    doCheck = false;
  } (builtins.readFile ./mediathek.py);
in
{
  home.packages = [ mediathek ];
}
