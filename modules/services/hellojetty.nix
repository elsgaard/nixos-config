{ config, pkgs, lib, ... }:

let
  otelAgent = pkgs.fetchurl {
    url = "https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v2.24.0/opentelemetry-javaagent.jar";
    sha256 = "1ki0h9khlzlrh61zj32bm49jdjbmhfi18bz22i184zwhz54csj2w";
  };
  jre = pkgs.jdk25; # match your app classfile version (or compile down)
in

{
  users.groups.hellojetty = { };

  users.users.hellojetty = {
    isSystemUser = true;
    group = "hellojetty";
    home = "/var/lib/hellojetty";
    createHome = true;
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/hellojetty/logs 0750 hellojetty hellojetty - -"
  ];

  systemd.services.hellojetty = {
    description = "HelloJetty (Jetty 12 Uber JAR)";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      User = "hellojetty";
      Group = "hellojetty";
      WorkingDirectory = "/var/lib/hellojetty";

      Environment = [
        "OTEL_SERVICE_NAME=hellojetty"
        "OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf"
        "OTEL_EXPORTER_OTLP_ENDPOINT=https://api.honeycomb.io"
        "OTEL_EXPORTER_OTLP_HEADERS=x-honeycomb-team=xxxxxxx"
      ];

      ExecStart = lib.concatStringsSep " " [
        "${pkgs.jdk25}/bin/java"
        "-Xms128m"
        "-Xmx512m"
        "-XX:+ExitOnOutOfMemoryError"
        "-javaagent:${otelAgent}"
        "-jar /var/lib/hellojetty/app/build/libs/hellojetty.jar"
      ];

      Restart = "on-failure";
      RestartSec = "5s";

      TimeoutStopSec = "20s";
      KillSignal = "SIGTERM";

      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ReadWritePaths = [ "/var/lib/hellojetty/logs" ];

      StandardOutput = "journal";
      StandardError = "journal";
    };
  };
}
