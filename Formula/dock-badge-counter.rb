class DockBadgeCounter < Formula
  desc "Read macOS Dock notification badges, once or as a change-watching service"
  homepage "https://github.com/strayer/dock-badge-counter"
  url "https://github.com/strayer/dock-badge-counter/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "731da1df34a509e8fff38fc2f3d8c230eaa666a69beabef161ed59b0d53871f2"
  license "MIT"

  depends_on xcode: ["15.0", :build]
  depends_on macos: :ventura

  def install
    # The source reports "dev"; the release tag (this formula's version) is the real number.
    inreplace "Sources/Commands/DockBadgeCounter.swift", 'let version = "dev"', "let version = \"#{version}\""
    system "swift", "build", "--configuration", "release", "--disable-sandbox"
    bin.install ".build/release/dock-badge-counter"
    pkgetc.install "examples/config.toml" => "config.toml.example"
  end

  # `brew services start dock-badge-counter` runs the watcher as a launchd user agent.
  # Configure it in ~/.config/dock-badge-counter/config.toml (see the example in #{etc}).
  service do
    run [opt_bin/"dock-badge-counter", "watch"]
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var/"log/dock-badge-counter.log"
    error_log_path var/"log/dock-badge-counter.log"
  end

  def caveats
    <<~EOS
      The watcher needs Accessibility permission for the binary itself:
        System Settings > Privacy & Security > Accessibility > + > #{opt_bin}/dock-badge-counter
      A permission prompt is shown on first start. After a `brew upgrade` the grant must be
      renewed, because the binary's ad-hoc code signature changes.

      Example config: #{pkgetc}/config.toml.example
    EOS
  end

  test do
    assert_match "dock-badge-counter", shell_output("#{bin}/dock-badge-counter --help")
    assert_match version.to_s, shell_output("#{bin}/dock-badge-counter --version")
  end
end
