{
  lib,
  buildGoModule,
  fetchFromGitHub,

  # msteams uses a lot of RAM while building
  nomsteams ? true,
  # excludes the zulip bridge from the build. Off by default to match upstream's default feature set
  nozulip ? false,
}:

buildGoModule {
  pname = "matterbridge";
  version = "1.26.0-unstable-2026-10-24";

  src = fetchFromGitHub {
    owner = "matterbridge-org";
    repo = "matterbridge";
    rev = "ef72d19f9d88e00032dfa8062d7920a67466491f";
    hash = "sha256-GjXoRgQt0AOeVVazAPT4APqfLmgr6vtmdWEJ+OUL5Ls=";
  };

  subPackages = [ "." ];

  tags = [
    "goolm"
  ]
  ++ lib.optionals nomsteams [ "nomsteams" ]
  ++ lib.optionals nozulip [ "nozulip" ];

  vendorHash = "sha256-8p3r3PfqdY2y/FPgmq6SCG1wZhgZ3soCfjKRyvXdGq0=";

  meta = {
    description = "Multi-protocol chat bridge (IRC, Matrix, XMPP, Discord, Telegram, etc…)";
    homepage = "https://github.com/matterbridge-org/matterbridge";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ryantm ];
    mainProgram = "matterbridge";
  };
}
