{
  lib,
  melpaBuild,
  fetchFromGitHub,
  nix-update-script,
  magit,
  difftastic,
}:
melpaBuild {
  pname = "magit-difftastic";
  version = "0.1.0-unstable-2026-09-08";

  src = fetchFromGitHub {
    owner = "rschmukler";
    repo = "magit-difftastic";
    rev = "9830a8b19be2181c65b9fe3ed9e2f509ae108216";
    hash = "sha256-YWmv0cBGtY4C7eMmJRrwOGVVz2eYuYbutn3NzCBn7lU=";
  };

  packageRequires = [
    magit
    difftastic
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };

  meta = {
    description = "Difftastic-rendered, stageable sections in Magit";
    homepage = "https://github.com/rschmukler/magit-difftastic";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.shunueda ];
  };
}
