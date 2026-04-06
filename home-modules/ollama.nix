{ config, pkgs-unstable, ... }:
{
  services.ollama =
  {
    package = pkgs-unstable.ollama-rocm;
    enable = true;
    host = "0.0.0.0";
    environmentVariables =
    {
      OLLAMA_MODELS = "${config.home.homeDirectory}/.cache/ollama/models";
      OLLAMA_NUM_THREAD = "8";
      OLLAMA_NUM_PARALLEL = "4";
      OLLAMA_MAX_QUEUE = "512";
      OLLAMA_KEEP_ALIVE = "10m";
      OLLAMA_MAX_VRAM = "21474836480";
    };
  };
}
