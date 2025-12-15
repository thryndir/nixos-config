{ pkgs, bliss-src }:
pkgs.rustPlatform.buildRustPackage {
  pname = "blissify";
  version = "unstable";

  src = bliss-src;

  cargoHash = "sha256-7wqfZMIiEcWMqzEjT2HgMGQM6WY5pnRVWtkEunWbpAE=";

  nativeBuildInputs = [ pkgs.pkg-config pkgs.llvmPackages.libclang ];
  buildInputs = [ pkgs.ffmpeg pkgs.sqlite pkgs.alsa-lib ];

  LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";

  BINDGEN_EXTRA_CLANG_ARGS =
    "-isystem ${pkgs.llvmPackages.libclang.lib}/lib/clang/${pkgs.llvmPackages.libclang.version}/include " +
    "-isystem ${pkgs.glibc.dev}/include";

  doCheck = false;
}
