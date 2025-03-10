{
  pkgs,
  lib,
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin rec {
  pname = "gp-nvim";
  version = "2024-05-04";

  src = fetchFromGitHub {
    owner = "Robitx";
    repo = "gp.nvim";
    rev = "c130cf2cdd51b01790e5b38b8cf545d4c33405ab";
    hash = "sha256-5JuMmypmC6aNQq626JkkLeoxJrjy9/FX57pBXMKzLsI=";
  };
  # src = pkgs.fetchurl {
  #   url = "https://github.com/Robitx/gp.nvim/archive/52938ffbd47b5e06d0f9b7c8b146f26d6021fbac.tar.gz";
  #   sha256 = "1hbxnr8q50j1jzckr413qzyl1yd8in4r5dd8vpq2gr7kjnlq7gxq";
  # };
  meta = with lib; {
    description = "Gp.nvim (GPT prompt) Neovim AI plugin: ChatGPT sessions & Instructable text/code operations & Speech to text [OpenAI]";
    homepage = "https://github.com/Robitx/gp.nvim";
    license = with licenses; [mit];
  };
}
