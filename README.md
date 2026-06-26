# Claude Code Skill: Bewerbungs-Assistent (Schweiz)

Ein vollständiger Bewerbungs-Assistent für Claude Code, optimiert für den Schweizer Arbeitsmarkt.

## Was dieser Skill macht

1. **Profil anlegen** — einmalig, wird für alle künftigen Bewerbungen genutzt (inkl. Stärken-Beweise, Schwachpunkte mit Gegenargument, Eigenständigkeits-Beispiele und persönlicher Schreibstil)
2. **Stellen suchen** — live auf LinkedIn, Indeed, Glassdoor & Co. (via JobSpy/TheirStack), CH und international
3. **Stelle per Screenshot** — schick ein Foto eines Inserats, der Bot findet das Live-Inserat und liefert den direkten Bewerbungs-Link
4. **Recherche vor dem Schreiben** — Branchenstandard, Firma und Job-Offer werden gezielt analysiert, bevor geschrieben wird
5. **Vorschläge mit Match-Score** — welche Stelle passt wie gut zu deinem Profil
6. **CV + Anschreiben** — maßgeschneidert pro Stelle, in deinem Schreibstil (kein KI-Deutsch), CH- oder internationales Format
7. **Gmail-Entwurf** — direkt in Gmail speichern (wenn Gmail MCP verbunden)
8. **Tracking** — alle Bewerbungen in einer Tabelle verfolgen

---

## Installation

### Option A: Manuell (empfohlen)

```bash
# 1. Repo klonen
git clone https://github.com/usr1243/claude-bewerbung-skill.git

# 2. Skill-Dateien platzieren
mkdir -p ~/.claude/skills/bewerbung/templates ~/.claude/skills/bewerbung/scripts
cp claude-bewerbung-skill/SKILL.md ~/.claude/skills/bewerbung/SKILL.md
cp claude-bewerbung-skill/templates/* ~/.claude/skills/bewerbung/templates/
cp claude-bewerbung-skill/scripts/* ~/.claude/skills/bewerbung/scripts/
chmod +x ~/.claude/skills/bewerbung/scripts/*.sh

# 3. Datenordner anlegen (Pfad frei wählbar)
mkdir -p ~/bewerbungen/bewerbung/profil
mkdir -p ~/bewerbungen/bewerbung/dokumente
```

Dann in `~/.claude/skills/bewerbung/SKILL.md` unter `## Datenablage` den Platzhalter `DATEN_ORDNER` ersetzen durch deinen gewählten Pfad, z.B. `/Users/DEINNAME/bewerbungen`.

### Option B: Per Claude Bot installieren lassen

Gib deinem Claude Code Bot diesen Prompt:

```
Installiere den Bewerbungs-Skill von https://github.com/usr1243/claude-bewerbung-skill

1. Lese README.md und alle Dateien via WebFetch von GitHub raw
2. Erstelle ~/.claude/skills/bewerbung/SKILL.md mit dem Inhalt von SKILL.md
3. Erstelle ~/.claude/skills/bewerbung/templates/ mit cv-ch.md, anschreiben.md, profil-vorlage.md
4. Erstelle ~/.claude/skills/bewerbung/scripts/ mit perplexity_search.sh (chmod +x)
5. Lege den Datenordner-Pfad fest: ~/bewerbungen/bewerbung (Verzeichnisse erstellen)
6. Ersetze in SKILL.md alle DATEN_ORDNER-Platzhalter mit dem echten Pfad
7. Bestätige: "Skill installiert — starte mit /bewerbung"
```

---

## Verwendung

```
/bewerbung
```

Oder sag: *"Ich möchte mich bewerben"*, *"Suche mir einen Job in Zürich"*, *"Erstelle meinen Lebenslauf"*

---

## Dateistruktur

```
~/.claude/skills/bewerbung/
├── SKILL.md                    ← Agent-Anweisungen (dieser Skill)
├── templates/
│   ├── cv-ch.md                ← CV-Vorlage Schweizer Standard
│   ├── anschreiben.md          ← Anschreiben-Vorlage (DE + EN)
│   └── profil-vorlage.md       ← Profil-Template
└── scripts/
    └── perplexity_search.sh    ← optionale Deep-Research (Perplexity-API)

DATEN_ORDNER/bewerbung/         ← frei wählbarer lokaler Ordner (z.B. ~/bewerbungen)
├── profil/
│   ├── profil.md               ← dein Profil (beim ersten Start erstellt)
│   └── bewerbungen.md          ← Bewerbungs-Tracker
└── dokumente/
    └── <Firma>_<Stelle>/       ← generierte CVs + Anschreiben
```

---

## Voraussetzungen

- [Claude Code](https://claude.ai/code) installiert
- WebSearch + WebFetch verfügbar (Standard bei Claude Code)
- Optional: JobSpy (gratis) und/oder TheirStack MCP für Live-Jobsuche — der Skill leitet dich beim ersten Start durch das Setup
- Optional: Gmail MCP für automatische E-Mail-Entwürfe

---

## Optionale Deep-Research (Perplexity, kostenpflichtig)

Für besonders zugeschnittene Bewerbungen kann der Skill über die **Perplexity-API** tief zu Firma, Standort und Kultur recherchieren.

- **Opt-in:** Wird nie automatisch genutzt. Der Bot fragt **jedes Mal vorher** und nennt die ungefähren Kosten.
- **Kosten:** prepaid auf deinem Perplexity-Konto, in der Praxis wenige Cent pro Recherche.
- **API-Key:** Du gibst den Key (`pplx-…`) **selbst im Terminal** ein, nie im Chat:
  ```bash
  echo 'export PERPLEXITY_API_KEY="pplx-DEIN_KEY"' >> ~/.zshrc
  ```
  Danach neues Terminal öffnen. Das Script `scripts/perplexity_search.sh` liest den Key nur aus dieser Umgebungsvariable — er erscheint nie in Logs oder Befehlen.
- Ohne Perplexity läuft alles weiter über die normale Websuche.

---

## Hinweise

- Alle Daten bleiben **lokal** auf deinem Rechner
- Der Bot **erfindet keine Qualifikationen** — nur echte Angaben aus deinem Profil
- **Schweizer Standard:** "ss" statt "ß", Pensum in %, Foto optional, Sie-Form
- Sprache der Dokumente richtet sich nach dem Inserat (DE oder EN)
