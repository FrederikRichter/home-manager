pkgs:
program:
let
package = pkgs.${program};
result = package.overrideAttrs (oldAttrs: {
	pname = program;
	nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ pkgs.makeWrapper pkgs.nixgl.auto.nixGLDefault];
	postInstall = (oldAttrs.postInstall or "") + ''
	 nixGL $out/bin/${program} 
	'';}
  );
in result
