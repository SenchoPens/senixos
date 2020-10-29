final: prev:

{
  google-chrome-beta-with-pipewire =
    prev.callPackage ./google-chrome-with-pipewire {
      google-chrome = final.google-chrome-beta;
      pipewire = final.pipewire_0_2;
    };
  # google-chrome-dev-with-pipewire =
  #   prev.callPackage ./google-chrome-with-pipewire {
  #     google-chrome = final.google-chrome-dev;
  #     pipewire = final.pipewire_0_2;
  #   };
}
