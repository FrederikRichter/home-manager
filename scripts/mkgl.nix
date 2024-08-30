pkgs:
program:
let
package = pkgs.${program};
  wrapped = pkgs.writeShellScriptBin "${program}" ''
    exec nixGL ${package}/bin/${program}
  '';
in
pkgs.symlinkJoin {
  name = "${program}";
  paths = [
    wrapped
    pkgs.${program}
  ];
}

