{ ps-pkgs, pkgs, name, ... }:
  with ps-pkgs;
  { version = "1.0.0";
    dependencies =
      [ web-dom
      ];
    src = "src";
    pursuit = {
      inherit name; 
      repo = "https://github.com/grybiena/resize-observer.git";
      license = pkgs.lib.licenses.mit;
    };
  }
