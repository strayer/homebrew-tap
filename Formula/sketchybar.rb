# Patched build of SketchyBar for testing the fix for FelixKratz/SketchyBar#852
# (bar unclickable under the macOS 27 MenuBarAgent window while the menu bar is
# auto-hidden; the bar now follows the menu bar reveal state). Pinned to a
# commit on the fork branch fix/macos27-topmost-menubar-agent; not bumped by Renovate.
# Remove once the fix is released upstream.
class Sketchybar < Formula
  env :std
  desc "Custom macOS statusbar with shell plugin, interaction and graph support"
  homepage "https://github.com/FelixKratz/SketchyBar"
  url "https://github.com/strayer/SketchyBar/archive/dd43bf67dde4f5f9b31509d3ab85a37158d26777.tar.gz"
  version "2.24.1-fix852.3"
  sha256 "cf79da630381844942e2b6ab14a60ae8f6a989aa8825419939a80db3853e3498"
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
      It works with every topmost setting; topmost=off keeps the revealed menu bar usable.

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
