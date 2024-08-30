pkgs:
program:
let
currentOS = builtins.currentSystem;
pname = program.meta.mainProgram;
wrapped = pkgs.writeShellScriptBin "${pname}" ''
exec nixGL ${program}/bin/${pname}
'';
in
# if not nixos patch with nixGL else return input
if builtins.match "nixos" currentOS == null then
	pkgs.symlinkJoin {
	  name = pname;
	  paths = [
	    wrapped
	    program
	  ];
	}
else
	program

