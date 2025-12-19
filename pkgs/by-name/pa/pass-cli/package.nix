{
  stdenvNoCC,
  lib,
  fetchurl,
}:

let
  inherit (stdenvNoCC.hostPlatform) system;

  pname = "pass-cli";
  version = "1.3.2";

  srcs = {
    "aarch64-linux" = fetchurl {
      url = "https://proton.me/download/pass-cli/${version}/pass-cli-linux-aarch64";
      hash = "sha256-w5mwbYQgqAU07T4+vUaYkcVp8XtMFNynGTV3jJQjAFw=";
    };
    "x86_64-linux" = fetchurl {
      url = "https://proton.me/download/pass-cli/${version}/pass-cli-linux-x86_64";
      hash = "sha256-X7FK1t0+SuBGgSsBuhYUCkcR8LtCQMjbplo5B1LSuh0=";
    };
    "aarch64-darwin" = fetchurl {
      url = "https://proton.me/download/pass-cli/${version}/pass-cli-macos-aarch64";
      hash = "sha256-B+hmxagP5Ls+Jc8DZN8Y9fvdrTq+HkMICUzMVsd8aU4=";
    };
    "x86_64-darwin" = fetchurl {
      url = "https://proton.me/download/pass-cli/${version}/pass-cli-macos-x86_64";
      hash = "sha256-VmkTLyHNZ8p8wgvzHOYiQsbDTjzKsjyGDShcQZlAH7A=";
    };
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = srcs.${system} or (throw "Unsupported system ${system}");

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 $src $out/bin/pass-cli
  '';

  meta = {
    description = "Proton Pass CLI";
    homepage = "https://protonpass.github.io/pass-cli/";
    license = lib.licenses.unfree;
    platforms = builtins.attrNames srcs;
    mainProgram = "pass-cli";
    maintainers = with lib.maintainers; [ shunueda ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
