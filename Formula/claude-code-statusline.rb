class ClaudeCodeStatusline < Formula
  desc "Fast, dependency-free statusline and subagent panel renderer for Claude Code"
  homepage "https://github.com/strayer/claude-code-statusline"
  license "MIT"

  # Release binaries built and attested by the project's release workflow
  # (SLSA provenance; verify with `gh attestation verify`). No macOS Intel build.
  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/strayer/claude-code-statusline/releases/download/v1.5.0/claude-statusline-darwin-arm64"
      sha256 "3550255398548dc42d21c4e7376d6f34a449cda6255717aaf6b31808b8e0f289"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/strayer/claude-code-statusline/releases/download/v1.5.0/claude-statusline-linux-amd64"
      sha256 "c54ea705d60aa8a872a8e43b0c4fcf6a58456588280382821efb49b3d086fc51"
    end
    on_arm do
      url "https://github.com/strayer/claude-code-statusline/releases/download/v1.5.0/claude-statusline-linux-arm64"
      sha256 "9d561150c752d764152bcb5b5b54fe7630690c86fc3a071ab5779076eb2a79dc"
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
