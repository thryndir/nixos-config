{...}:
{
  systemd.user.services.bluetooth-volume-limiter =
  {
    Unit =
    {
      Description = "Limit max volume for bluetooth devices";
      After = [ "pipewire-pulse.service" "wireplumber.service" ];
    };

    Service = {
      # On redémarre le script s'il plante
      Restart = "always";
      RestartSec = "5s";
    
      ExecStart = let
        pkgs = import <nixpkgs> {};
        limit = "40";
      in "${pkgs.writeShellScript "bt-vol-limit" ''
        export PATH=${pkgs.pulseaudio}/bin:${pkgs.gnugrep}/bin:${pkgs.gawk}/bin:$PATH
      
        # Fonction pour vérifier et limiter un sink spécifique
        check_limit() {
          local sink_id=$1
        
          # Récupère le nom et le volume actuel (en %)
          # On utilise pactl car il est stable pour le scripting, même sous PipeWire
          local info=$(pactl list sinks | grep -A 15 "Sink #$sink_id")
          local name=$(echo "$info" | grep "Name:" | awk '{print $2}')
          local vol=$(echo "$info" | grep "Volume:" | head -n1 | awk -F/ '{print $2}' | tr -d ' %')

          # Si c'est du bluetooth (bluez) et que le volume dépasse la limite
          if [[ "$name" == *"bluez_output"* ]] && [ "$vol" -gt "${limit}" ]; then
            echo "Volume trop haut ($vol%) sur $name. Limitation à ${limit}%."
            pactl set-sink-volume "$sink_id" ${limit}%
          fi
        }

        echo "Démarrage du limiteur de volume Bluetooth (Max: ${limit}%)"

        # 1. Vérification au lancement
        pactl list short sinks | cut -f1 | while read id; do check_limit "$id"; done

        # 2. Écoute active des changements
        pactl subscribe | grep --line-buffered "sink" | while read -r line; do
          # On extrait l'ID du sink qui vient de changer
          sink_id=$(echo "$line" | cut -d'#' -f2)
          check_limit "$sink_id"
        done
      ''}";
    };

    Install =
    {
      WantedBy = [ "default.target" ];
    };
  };
}
