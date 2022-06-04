{ pkgs }: pkgs.stdenv.mkDerivation rec {
  pname = "isolate";
  version = "1.8.1";

  src = pkgs.fetchFromGitHub {
    owner = "ioi";
    repo = "isolate";
    rev = "v${version}";
    sha256 = "sha256-q5UpZA3grlNaTSU44gZRAWLxWSiUwGcuuXDI9MzlJo0=";
  };
}
