cask "avro-keyboard" do
  version "2.1.0"
  sha256 "980da76657a8a98cdf37ad1242596c1105d4afa14b06a84afa2d28de0867bbf7"

  url "https://github.com/ImRIzo/iAvro-arm64/releases/download/v#{version}/AvroKeyboard-#{version}.zip"
  name "Avro Keyboard"
  desc "Avro phonetic Bangla input method for Apple Silicon"
  homepage "https://github.com/ImRIzo/iAvro-arm64"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: ">= :ventura"

  input_method "Avro Keyboard.app"

  # The app is ad-hoc signed, not notarized: without this macOS refuses to load
  # the input method. Remove once releases are Developer ID signed + notarized.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{Dir.home}/Library/Input Methods/Avro Keyboard.app"]
  end

  uninstall quit: "com.omicronlab.inputmethod.AvroKeyboard"

  zap trash: [
    "~/Library/Application Support/OmicronLab/Avro Keyboard",
    "~/Library/Preferences/com.omicronlab.inputmethod.AvroKeyboard.plist",
  ]

  caveats <<~EOS
    Log out and back in, then add it in
      System Settings → Keyboard → Input Sources → + → Bangla → Avro Keyboard
  EOS
end
