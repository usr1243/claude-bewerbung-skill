#!/usr/bin/env bash
# perplexity_search.sh — sichere Deep-Research-Abfrage über die Perplexity-API.
#
# Der API-Key wird AUSSCHLIESSLICH aus der Umgebungsvariable PERPLEXITY_API_KEY
# gelesen — nie als Argument übergeben, nie ausgegeben, nie geloggt.
#
# Setup (macht der Nutzer selbst im Terminal):
#   export PERPLEXITY_API_KEY="pplx-..."   # am besten in ~/.zshrc
#
# Usage:
#   bash perplexity_search.sh "Deine Recherche-Frage"
#
# Modell: sonar (günstigste Stufe). Gibt die rohe JSON-Antwort auf stdout aus.

set -euo pipefail

: "${PERPLEXITY_API_KEY:?PERPLEXITY_API_KEY ist nicht gesetzt. Bitte zuerst 'export PERPLEXITY_API_KEY=\"pplx-...\"' in ~/.zshrc eintragen und ein neues Terminal öffnen.}"

if [ "$#" -lt 1 ] || [ -z "${1:-}" ]; then
  echo "Usage: bash perplexity_search.sh \"<query>\"" >&2
  exit 2
fi

# Query sicher als JSON-String kodieren (verhindert Quoting-Probleme).
content_json="$(printf '%s' "$1" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')"

curl -s https://api.perplexity.ai/chat/completions \
  -H "Authorization: Bearer ${PERPLEXITY_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{\"model\":\"sonar\",\"messages\":[{\"role\":\"user\",\"content\":${content_json}}]}"
