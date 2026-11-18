cask "avro-keyboard" do
  version "2.0.0"
  sha256 "3154f0e32ea37e0b934b0e09cd196671b1b9f120017226e022e43c434766f63a"

  url "https://github.com/ImRIzo/iAvro-arm64/releases/download/v#{version}/AvroKeyboard-#{version}.zip"
  name "Avro Keyboard"
  desc "Avro phonetic Bangla input method for Apple Silicon"
  homepage "https://github.com/ImRIzo/iAvro-arm64"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :ventura

  input_method "Avro Keyboard.app"

  # The app is ad-hoc signed, not notarized: without this macOS refuses to load
  # the input method. Strip quarantine in the staged copy before it is moved to
  # ~/Library/Input Methods. Remove once releases are Developer ID signed + notarized.
  preflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{staged_path}}/Avro Keyboard.app"]
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
