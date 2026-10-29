class ClaudeCodeStatusline < Formula
  desc "Fast, dependency-free statusline and subagent panel renderer for Claude Code"
  homepage "https://github.com/strayer/claude-code-statusline"
  license "MIT"

  # Release binaries built and attested by the project's release workflow
  # (SLSA provenance; verify with `gh attestation verify`). No macOS Intel build.
  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/strayer/claude-code-statusline/releases/download/v1.4.0/claude-statusline-darwin-arm64"
      sha256 "221b328fb2b4beacb44e25f52a3b4bca5d5f8a347b8120ba0deaa34a1b610ab7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/strayer/claude-code-statusline/releases/download/v1.4.0/claude-statusline-linux-amd64"
      sha256 "1fdcecba57e5aaa9d62d4dc58fc0dc825d1582a6b1caa53ddc8a90fc04a37365"
    end
    on_arm do
      url "https://github.com/strayer/claude-code-statusline/releases/download/v1.4.0/claude-statusline-linux-arm64"
      sha256 "704cbabb2ea4e0c8265df54ccf104a71bd4fc32915dbddbfa8b526c5d835a8de"
    end
  end

  def install
    binary = Dir["claude-statusline-*"].first
    bin.install binary => "claude-statusline"
    chmod 0755, bin/"claude-statusline"
  end

  test do
    input = '{"model":{"display_name":"Claude Opus 5.5"},"workspace":{"current_dir":"/tmp"},' \
            '"context_window":{"context_window_size":200000,"used_percentage":10,"remaining_percentage":90}}'
    assert_match "[Opus 5.5]", pipe_output(bin/"claude-statusline", input)

    tasks = '{"columns":120,"cwd":"/tmp","tasks":[{"id":"t1","agentType":"Explore","status":"running",' \
            '"description":"Searching","label":"Searching","model":"claude-haiku-5-5",' \
            '"contextWindowSize":200000,"tokenCount":5000,"tokenSamples":[1000,5000],"cwd":"/tmp"}]}'
    assert_match(/"id":"t1".*Haiku 5\.5/, pipe_output("#{bin}/claude-statusline --subagents", tasks))
  end
end
