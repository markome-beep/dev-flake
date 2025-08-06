{
  description = "Template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = {
    self,
    nixpkgs,
    nvf,
  }: let
    sys = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${sys};
  in {
    packages.${sys} = with pkgs; {
      inherit fastfetch;
      inherit lazygit;
      inherit zoxide;

      neovim =
        (nvf.lib.neovimConfiguration {
          inherit pkgs;

          modules = [
            ./nvf-config.nix
          ];
        }).neovim;
    };

    devShells.${sys}.default = pkgs.mkShell {
      buildInputs = builtins.attrValues self.packages.${sys};

      shellHook = ''
        source ${toString ./shellHook.sh}
      '';
    };
  };
}
