{config, lib, pkgs, username, ...}:
{
xdg = {
  enable = true;
  mime.enable = true;
  userDirs.enable = true;
  userDirs.setSessionVariables = true;
};
}
