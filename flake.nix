{
  description = "resize-observer";

  inputs = {
    purescript-environment.url = "git+ssh://git@github.com/grybiena/purescript-environment?ref=grybiena";
    flake-utils.follows = "purescript-environment/flake-utils";
    nixpkgs.follows     = "purescript-environment/nixpkgs";
    ps-tools.follows    = "purescript-environment/ps-tools";
    purs-nix.follows    = "purescript-environment/purs-nix";

  };
  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ ];

        pkgs = import nixpkgs {
          inherit system overlays;
          config.allowBroken = true;
        };

        ps-tools = inputs.ps-tools.legacyPackages.${system};
        purs-nix = inputs.purs-nix { inherit system; };

        package = import ./package.nix purs-nix;
 
        ps =
          purs-nix.purs { inherit (package) dependencies;
                          dir = ./.;
                        };
      in 
         { packages.default =
             purs-nix.build
               { name = "resize-observer";
                 src.path = ./.;
                 info = package;
               };
           packages.output = ps.output {};
           devShells.default = 
             pkgs.mkShell
               { packages = with pkgs; [
                   nodejs
                   (ps.command {}) 
                   ps-tools.for-0_15.purescript-language-server
                   purs-nix.esbuild
                   purs-nix.purescript
                 ];
               };
         }
   );
}

