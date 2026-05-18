{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pi-coding-agent
  ];

  home.sessionVariables = {
    PI_CODING_AGENT_DIR = "$HOME/.pi/agent";
    PI_SKIP_VERSION_CHECK = "1";
    PI_TELEMETRY = "0";
  };

  home.file.".pi/agent/settings.json".text = builtins.toJSON {
    theme = "dark";
    enableInstallTelemetry = false;
    quietStartup = false;

    compaction = {
      enabled = true;
      reserveTokens = 16384;
      keepRecentTokens = 20000;
    };

    retry = {
      enabled = true;
      maxRetries = 3;
      baseDelayMs = 2000;
      provider = {
        maxRetryDelayMs = 60000;
      };
    };

    enabledModels = [
      "claude-*"
      "openai/*"
      "gpt-*"
      "gemini-*"
    ];

    npmCommand = [
      "${pkgs.nodejs}/bin/npm"
    ];

    warnings = {
      anthropicExtraUsage = true;
    };
  };

  home.file.".pi/agent/AGENTS.md".text = ''
    # Global Pi Instructions

    - Be direct and concise.
    - Prefer existing project conventions over new abstractions.
    - Read relevant files before making changes.
    - Do not write secrets into repositories.
    - After code changes, run the narrowest useful checks available.
  '';
}
