{ pkgs, templates }:
let
  lib = pkgs.lib;
  toYaml = lib.generators.toYAML { };

  vendorSha256 = "sha256-TMxl3vbgOSB2dnPEP5FF7VVeyxSJRNtkDxUJBrrUZ78=";
  # vendorSha256 = fakeSha256;

  # fileb0x configuration
  fileb0xConf = pkgs.writeText "fileb0x.yaml" (toYaml {
    pkg = "static";
    dest = "./static";
    fmt = false;
    debug = false;

    compression.compress = true;

    custom = [
      { files = [ "./assets/" "./templates/" ]; }
    ];
  });
in
with lib;
pkgs.buildGoModule {
  inherit vendorSha256;

  src = ../.;
  tags = [ "production" ];

  name = "kjudge";

  nativeBuildInputs = with pkgs; [ bash gnugrep sqlite curl ];

  # Generate sources
  preBuild = ''
    # Link templates
    cp -r ${templates}/templates .
    # Install tools
    bash scripts/install_tools.sh
    # Add GOPATH to PATH
    export PATH=$PATH:$(go env GOPATH)/bin
    # Generate fileb0x
    fileb0x ${fileb0xConf}
    # Generate sql models
    go run models/generate/main.go
  '';
}

