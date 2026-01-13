{ config, pkgs, ... }:
{
  imports = [./aichat-stylix.nix];
  services.ollama =
  {
    enable = true;
    acceleration = false;
    environmentVariables =
    {
      OLLAMA_MODELS = "${config.home.homeDirectory}/.cache/ollama/models";
      OLLAMA_NUM_THREAD = "8";
      OLLAMA_NUM_GPU = "0";
      OLLAMA_NUM_PARALLEL = "2";
      OLLAMA_KEEP_ALIVE = "10m";
      OLLAMA_MAX_QUEUE = "4";
    };
  };

  home.file.".local/share/ollama/modelfiles/qwen".source =
    ./qwen-modelfile;
  home.file.".local/share/ollama/modelfiles/gemma".source =
    ./gemma-modelfile;
  xdg.configFile."aichat/config.yaml".source = (pkgs.formats.yaml { }).generate "aichat"
  {
    model = "ollama:gemma:latest";
    save_session = null;
    highlight = true;
    light_theme = false;
    clients =
    [
      {
        type = "openai-compatible";
        name = "ollama";
        api_base = "http://localhost:11434/v1";
        models =
        [
          {
            name = "gemma:latest";
          }
          {
            name = "qwen:latest";
          }
        ];
      }
    ];
  };
}
