# To get the pinned nixpkgs simply use:
#   nix-shell
# If you want to use a different nixpkgs version use:
#   export NIX_PATH=nixpkgs-1509=https://github.com/NixOS/nixpkgs-channels/archive/nixos-15.09.tar.gz:$NIX_PATH
#   nix-shell --arg nixpkgs "<nixpkgs-1509>"
#   export NIX_PATH=my-nixpkgs=$HOME/my-fork:$NIX_PATH
#   nix-shell --arg nixpkgs "<my-nixpkgs>"
{nixpkgs ? null}:
let
  pinnedPkg = (import <nixpkgs> {}).fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "8ef3eaeb4e531929ec29a880cb4c67f790e5eb70";
    sha256 = "1v9lgk3j394i91qz1h7cv6mbg6xkdllfccc902ydb1gvp6bzmh6z";
  };
  pkgs = if nixpkgs==null then
           import pinnedPkg {}
         else
           import <nixpkgs> {};
in with pkgs; stdenv.mkDerivation rec {
  name = "some-python-project";
  src = if lib.inNixShell then null else ./.; # Avoid copying of src dir when using nix-shell
  buildInputs = [ stdenv
                  pythonPackages.numpy
                  pythonPackages.ipython
  ];
}

