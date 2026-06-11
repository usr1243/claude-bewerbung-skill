# Claude Code Skill: Bewerbungs-Assistent (Schweiz)

Ein vollständiger Bewerbungs-Assistent für Claude Code, optimiert für den Schweizer Arbeitsmarkt.

## Was dieser Skill macht

1. **Profil anlegen** — einmalig, wird für alle künftigen Bewerbungen genutzt
2. **Stellen suchen** — live auf jobs.ch, jobscout24.ch, indeed.ch
3. **Vorschläge mit Match-Score** — welche Stelle passt wie gut zu deinem Profil
4. **CV + Anschreiben** — maßgeschneidert pro Stelle, CH-Standard (ss statt ß, Foto, Pensum)
5. **Gmail-Entwurf** — direkt in Gmail speichern (wenn Gmail MCP verbunden)
6. **Tracking** — alle Bewerbungen in einer Tabelle verfolgen

---

## Installation

### Option A: Manuell (empfohlen)

```bash
# 1. Repo klonen
git clone https://github.com/usr1243/claude-bewerbung-skill.git

# 2. Skill-Dateien platzieren
mkdir -p ~/.claude/skills/bewerbung/templates
cp claude-bewerbung-skill/SKILL.md ~/.claude/skills/bewerbung/SKILL.md
cp claude-bewerbung-skill/templates/* ~/.claude/skills/bewerbung/templates/

# 3. Vault-Verzeichnis anlegen (Pfad frei wählbar)
mkdir -p ~/claude-brain/bewerbung/profil
mkdir -p ~/claude-brain/bewerbung/dokumente
```

Dann in `~/.claude/skills/bewerbung/SKILL.md` unter `## Datenablage` den Platzhalter `DEIN_VAULT` ersetzen durch deinen gewählten Pfad, z.B. `/Users/DEINNAME/claude-brain`.

### Option B: Per Claude Bot installieren lassen

Gib deinem Claude Code Bot diesen Prompt:

```
Installiere den Bewerbungs-Skill von https://github.com/usr1243/claude-bewerbung-skill

1. Lese README.md und alle Dateien via WebFetch von GitHub raw
2. Erstelle ~/.claude/skills/bewerbung/SKILL.md mit dem Inhalt von SKILL.md
3. Erstelle ~/.claude/skills/bewerbung/templates/ mit cv-ch.md, anschreiben.md, profil-vorlage.md
4. Lege den Vault-Pfad fest: ~/claude-brain/bewerbung (Verzeichnisse erstellen)
5. Ersetze in SKILL.md alle DEIN_VAULT-Platzhalter mit dem echten Pfad
6. Bestätige: "Skill installiert — starte mit /bewerbung"
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
└── templates/
    ├── cv-ch.md                ← CV-Vorlage Schweizer Standard
    ├── anschreiben.md          ← Anschreiben-Vorlage (DE + EN)
    └── profil-vorlage.md       ← Profil-Template

DEIN_VAULT/bewerbung/
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
- Optional: Gmail MCP für automatische E-Mail-Entwürfe

---

## Hinweise

- Alle Daten bleiben **lokal** auf deinem Rechner
- Der Bot **erfindet keine Qualifikationen** — nur echte Angaben aus deinem Profil
- **Schweizer Standard:** "ss" statt "ß", Pensum in %, Foto optional, Sie-Form
- Sprache der Dokumente richtet sich nach dem Inserat (DE oder EN)
