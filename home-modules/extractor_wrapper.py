import sys
import os
import subprocess
import tempfile
import json

# On récupère le chemin du VRAI extracteur via variable d'environnement
REAL_EXTRACTOR = os.environ.get("REAL_EXTRACTOR_BIN")

if not REAL_EXTRACTOR:
    sys.stderr.write("Error: REAL_EXTRACTOR_BIN not set\n")
    sys.exit(1)

if len(sys.argv) < 3:
    sys.stderr.write("Usage: wrapper.py input output [profile]\n")
    sys.exit(1)

input_file = sys.argv[1]
output_file = sys.argv[2]
# On ignore volontairement sys.argv[3] (le profil beets)

temp_wav = None
target_file = input_file

# --- 1. Transcodage (Opus -> WAV) ---
# Essentia (v2.1_beta2) ne lit pas l'Opus. On le convertit en WAV temporaire.
if input_file.lower().endswith(('.opus', '.ogg', '.m4a')):
    try:
        fd, temp_wav = tempfile.mkstemp(suffix='.wav')
        os.close(fd)
        # On suppose que 'ffmpeg' est dans le PATH (injecté par le wrapper Nix)
        subprocess.check_call([
            "ffmpeg", "-y", "-v", "error", "-i", input_file, 
            "-ac", "1", "-ar", "44100", temp_wav
        ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        target_file = temp_wav
    except Exception as e:
        sys.stderr.write(f"FFmpeg error: {e}\n")
        if temp_wav and os.path.exists(temp_wav): os.remove(temp_wav)
        sys.exit(1)

# --- 2. Extraction (C++) ---
try:
    # On appelle le binaire C++ officiel
    cmd = [REAL_EXTRACTOR, target_file, output_file]
    subprocess.check_call(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    
    # --- 3. Fix JSON (Key Mapping) ---
    # On enrichit le JSON pour que le plugin Beets trouve la tonalité
    with open(output_file, 'r') as f:
        data = json.load(f)
    
    if 'tonal' in data:
        t = data['tonal']
        key = t.get('key_key', '')
        scale = t.get('key_scale', '')
        
        if key and scale:
            # On injecte les champs alternatifs souvent cherchés par les plugins
            if 'chords_key' not in t: t['chords_key'] = key
            if 'chords_scale' not in t: t['chords_scale'] = scale
            if 'key_krumhansl' not in t: t['key_krumhansl'] = {'key': key, 'scale': scale}
            if 'key_edma' not in t: t['key_edma'] = {'key': key, 'scale': scale}
                
    with open(output_file, 'w') as f:
        json.dump(data, f)
        
except Exception as e:
    sys.stderr.write(f"Extraction error: {e}\n")
    sys.exit(1)
finally:
    if temp_wav and os.path.exists(temp_wav): os.remove(temp_wav)
