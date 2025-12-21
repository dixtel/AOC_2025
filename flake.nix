{
  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-22.11";
    
  };
  outputs = { nixpkgs, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in  {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        sbcl
      ];
    };
  };
}
