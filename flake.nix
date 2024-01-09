# @copy-paste from https://github.com/nix-community/nixvim README.md
{
  description = "A very basic flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nixvim.url = "github:nix-community/nixvim";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    nixvim,
    flake-utils,
  }: let
    # NOTE try to uncomment one of the config definitions

    # This is fine
    # config = { plugins.lualine.tabline.lualine_a = [ "tabs" ]; };

    # But both of these fail
    config = { plugins.lualine.tabline.lualine_a = [{0 = "tabs"; mode = 2}]; };
    # config = { plugins.lualine.tabline.lualine_a = [{"0" = "tabs"; mode = 2}]; };
  in
    flake-utils.lib.eachDefaultSystem (system: let
      nixvim' = nixvim.legacyPackages."${system}";
      nvim = nixvim'.makeNixvim config;
    in {
      packages = {
        inherit nvim;
        default = nvim;
      };
      devShells = {
        myshell = nixpkgs.mkShell {
          buildInputs = [nvim];
          shellHook = "nvim";
        };
      };
    });
}
