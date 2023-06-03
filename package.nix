{ ps-pkgs, ... }:
  with ps-pkgs;
  { version = "1.0.0";
    dependencies =
      [ web-dom
        web-events
      ];
    src = "src";
  }
