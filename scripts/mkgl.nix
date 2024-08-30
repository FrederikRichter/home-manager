pkgs:
program:
let
pname = program.meta.mainProgram;
  wrapped = pkgs.writeShellScriptBin "${pname}" ''
    exec nixGL ${program}/bin/${pname}
  '';
in
pkgs.symlinkJoin {
  name = pname;
  paths = [
    wrapped
    program
  ];
}

