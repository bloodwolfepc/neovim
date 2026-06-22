{
  pkgs,
  lib,
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin rec {
  pname = "neorg";
  version = "9.6.4";

  src = fetchFromGitHub {
    owner = "nvim-nerog";
    repo = "neorg";
    rev = "cda15ed88b735c81d2a2f591a699f6266845e095";
    hash = "sha256-aNL8DBe2xQ4jTHrGc01KCCdBN1caU931CoptHzRdhzU";
  };

  meta = {
    homepage = "https://github.com/nvim-neorg/neorg";
  };
}
