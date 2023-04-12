{ pkgs ? import <nixpkgs> {} }:
let 
  toGuest = builtins.replaceStrings [ "darwin" ] [ "linux" ]; 

  nixos = import <nixpkgs/nixos> { 
    configuration = { 
      imports = [ 
        <nixpkgs/nixos/modules/profiles/macos-builder.nix>
        <nixpkgs/nixos/modules/profiles/minimal.nix>
      ]; 

      virtualisation.host = { inherit pkgs; }; 
      virtualisation.darwin-builder.hostPort = 31022;
      nix.extraOptions = ''
        experimental-features = nix-command flakes
      '';
    }; 

    system = toGuest pkgs.stdenv.hostPlatform.system; 
  }; 

in 
  nixos.config.system.build.macos-builder-installer
