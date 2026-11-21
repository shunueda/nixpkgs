{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.river;

  wayland-lib = import ./lib.nix { inherit lib; };
in
{
  options.programs.river = {
    enable = lib.mkEnableOption "river, a non-monolithic Wayland compositor";

    package =
      lib.mkPackageOption pkgs "river" {
        nullable = true;
        extraDescription = ''
          If the package is not overridable with `xwaylandSupport`, then the module option
          {option}`xwayland` will have no effect.

          Set to `null` to not add any River package to your path.
          This should be done if you want to use the Home Manager River module to install River.
        '';
      }
      // {
        apply =
          p:
          if p == null then
            null
          else
            wayland-lib.genFinalPackage p {
              xwaylandSupport = cfg.xwayland.enable;
            };
      };

    xwayland.enable = lib.mkEnableOption "XWayland" // {
      default = true;
    };
  };

  imports = [
    (lib.mkRemovedOptionModule [
      "programs"
      "river"
      "extraPackages"
    ] "Use `environment.systemPackages` instead, or `programs.river-classic` for river 0.3.")
  ];

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = lib.optional (cfg.package != null) cfg.package;

        # To make a river session available if a display manager like SDDM is enabled:
        services.displayManager.sessionPackages = lib.optional (cfg.package != null) cfg.package;

        # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1050913
        xdg.portal.config.river.default = lib.mkDefault [
          "wlr"
          "gtk"
        ];
      }

      (import ./wayland-session.nix {
        inherit lib pkgs;
        enableXWayland = cfg.xwayland.enable;
      })
    ]
  );

  meta.maintainers = with lib.maintainers; [ shunueda ];
}
