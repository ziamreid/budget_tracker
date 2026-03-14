{ pkgs, ... }: {
  channel = "stable-23.11"; # or "unstable"
  packages = [
    pkgs.nodePackages.firebase-tools
    pkgs.jdk17
    pkgs.unzip
  ];
  env = {};
  idx = {
    extensions = [
      "dart-code.flutter"
      "dart-code.dart-code"
    ];
    previews = {
      enable = true;
      previews = {
        web = {
          command = ["flutter" "run" "--machine" "-d" "web-server" "--web-hostname" "0.0.0.0" "--web-port" "$PORT"];
          manager = "flutter";
        };
        android = {
          command = ["flutter" "run" "--machine" "-d" "android" "-d" "localhost:5555"];
          manager = "flutter";
        };
        ios = {
          command = ["flutter" "run" "--machine" "-d" "ios-simulator"];
          manager = "flutter";
        };
      };
    };
    workspace = {
      onCreate = {
        build-flutter = "flutter pub get";
      };
    };
  };
}
