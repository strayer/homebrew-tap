# Patched build of SketchyBar for testing the fix for FelixKratz/SketchyBar#852
# (topmost=on bar unclickable under the macOS 27 MenuBarAgent window). Pinned to a
# commit on the fork branch fix/macos27-topmost-menubar-agent; not bumped by Renovate.
# Remove once the fix is released upstream.
class Sketchybar < Formula
  env :std
  desc "Custom macOS statusbar with shell plugin, interaction and graph support"
  homepage "https://github.com/FelixKratz/SketchyBar"
  url "https://github.com/strayer/SketchyBar/archive/6a88a7783a3a8dbf7d430096e121c5c5b9cc7ef2.tar.gz"
  version "2.24.1-fix852"
  sha256 "3dedeb14bcc9ced0ba909f446be221e57c368d8f9147dfcb79b0920a82de24ba"
  license "GPL-3.0-only"
  head "https://github.com/strayer/SketchyBar.git", branch: "fix/macos27-topmost-menubar-agent"

  livecheck do
    skip "pinned to a patched commit"
  end

  def install
    ENV.delete("CFLAGS")
    ENV.delete("LDFLAGS")
    ENV.delete("CXXFLAGS")
    (var/"log/sketchybar").mkpath
    system "make"

    system "codesign", "--force", "-s", "-", "#{buildpath}/bin/sketchybar"
    bin.install "bin/sketchybar"
    (pkgshare/"examples").install "sketchybarrc"
    (pkgshare/"examples").install "plugins/"

    # Man pages come from the upstream documentation site, as in felixkratz/formulae.
    system "curl", "https://felixkratz.github.io/SketchyBar/documentation.tar.gz",
           "-o", "#{buildpath}/documentation.tar.gz"
    system "tar", "-xzf", "#{buildpath}/documentation.tar.gz", "-C", buildpath
    man1.install "sketchybar.1"
    man5.install Dir["sketchybar*.5"]
  end

  def caveats
    <<~EOS
      This is a patched test build for https://github.com/FelixKratz/SketchyBar/issues/852.
      The fix only applies with `sketchybar --bar topmost=on`.

      To return to the upstream release:
        brew services stop sketchybar
        brew uninstall sketchybar
        brew install felixkratz/formulae/sketchybar
        brew services start sketchybar
    EOS
  end

  service do
    run opt_bin/"sketchybar"
    environment_variables PATH: std_service_path_env, LANG: "en_US.UTF-8"
    keep_alive true
    process_type :interactive
    log_path var/"log/sketchybar/sketchybar.out.log"
    error_log_path var/"log/sketchybar/sketchybar.err.log"
  end

  test do
    assert_match "sketchybar-v2.24.1", shell_output("#{bin}/sketchybar --version")
  end
end
