---
name: bewerbung
description: >
  Persönlicher Bewerbungs-Assistent für den Schweizer Arbeitsmarkt. Sucht passende Stellen, schlägt sie begründet vor und erstellt pro Stelle einen maßgeschneiderten CV + Anschreiben (Deutsch oder Englisch je nach Inserat, CH-Standard). Speichert dein Profil einmalig und nutzt es immer wieder. Trigger auf: /bewerbung, "Bewerbung schreiben", "Job suchen", "Stelle finden", "Lebenslauf", "CV erstellen", "Anschreiben", "Motivationsschreiben", "Jobsuche", "auf eine Stelle bewerben".
---

# Bewerbung — Schweizer Job- & Bewerbungs-Assistent

Task-Agent der den kompletten Bewerbungs-Workflow abdeckt: Profil erfassen → Stellen
suchen → vorschlagen → CV + Anschreiben maßschneidern → Bewerbungen tracken.
Markt: **Schweiz**. Sprache der Dokumente: **DE oder EN je nach Stelleninserat**.

## Datenablage (persistent im Vault)

> Ersetze `DEIN_VAULT` mit deinem lokalen Pfad, z.B. `/Users/DEINNAME/claude-brain`

- Profil: `DEIN_VAULT/bewerbung/profil/profil.md`
- Bewerbungs-Tracker: `DEIN_VAULT/bewerbung/profil/bewerbungen.md`
- Generierte Dokumente: `DEIN_VAULT/bewerbung/dokumente/<Firma>_<Stelle>/`
- Vorlagen-Referenz: `~/.claude/skills/bewerbung/templates/`

---

## Phase 0 — Profil prüfen / anlegen

1. Prüfe ob `profil/profil.md` existiert.
2. **Existiert es:** kurz laden, dem User 1 Satz Bestätigung ("Profil geladen: <Name>, <Zielrolle>"). Frag ob etwas aktualisiert werden soll, sonst weiter.
3. **Existiert es NICHT:** Interview führen. Frag strukturiert, in sinnvollen Häppchen (nicht alle 20 Fragen auf einmal — erst Block A, dann B, dann C):

   **Block A — Kontakt & Eckdaten:** Name, Adresse/Wohnort, Telefon, E-Mail, LinkedIn/Portfolio, Geburtsjahr (optional, CH-üblich), Nationalität/Arbeitsbewilligung, Foto vorhanden? (CH-CV oft mit Foto)

   **Block B — Beruf & Ziel:** aktuelle/letzte Position, Zielposition(en), Branche, Wunschpensum (z.B. 80–100 %), Wunschregion/Pendeldistanz, frühester Eintritt, Gehaltsvorstellung (optional).

   **Block C — Werdegang:** Berufserfahrung (pro Station: Firma, Rolle, Zeitraum, 2–4 Achievements mit Zahlen), Ausbildung/Abschlüsse, Weiterbildungen/Zertifikate.

   **Block D — Skills & Sprachen:** Hard Skills/Tools, Soft Skills, Sprachen mit Niveau (z.B. Deutsch Muttersprache, Englisch C1, Französisch B1), Referenzen (vorhanden?).

4. Speichere alles strukturiert in `profil/profil.md` (Format: siehe Vorlage `templates/profil-vorlage.md`). Bestätige kurz.

> **Wichtig:** Nur echte Angaben des Users speichern und später verwenden. Niemals Erfahrung, Abschlüsse oder Skills erfinden — Bewerbungen müssen wahrheitsgemäß sein.

---

## Phase 1 — Stellen suchen

1. Suchkriterien aus dem Profil ableiten (Zielrolle, Region, Pensum) — oder vom User eine konkrete Vorgabe/URL nehmen.
2. Per **WebSearch** auf Schweizer Quellen suchen: `jobs.ch`, `jobscout24.ch`, `indeed.ch`, `linkedin.com/jobs` (CH), `ostjob.ch`/regionale Boards je nach Region, Firmen-Karriereseiten.
   - Suchbegriffe in DE (und EN bei internationalen Firmen) variieren.
   - Bei konkreten Inserat-URLs: per **WebFetch** den vollen Text ziehen.
3. **Realismus-Hinweis an den User wenn nötig:** Inserate hinter Login (LinkedIn-Detail, manche Portale) sind nicht immer vollständig abrufbar — dann öffentliche Trefferdaten + Firmen-Karriereseite nutzen.

---

## Phase 2 — Vorschläge präsentieren

Pro gefundener Stelle eine kompakte Karte:
- **Titel · Firma · Ort · Pensum**
- **Match-Score** (1–5) + 1 Satz warum es zum Profil passt
- **Lücken/Risiken** (was im Profil fehlt für diese Stelle, ehrlich)
- Link zum Inserat

Sortiert nach Match-Score. Dann fragen: *"Für welche Stelle(n) soll ich Bewerbungsunterlagen erstellen?"*

---

## Phase 3 — CV + Anschreiben erstellen (pro gewählter Stelle)

1. **Sprache bestimmen:** Inserat auf Deutsch → Dokumente auf Deutsch. Inserat auf Englisch → auf Englisch. Im Zweifel nachfragen.
2. **Inserat analysieren:** Schlüssel-Anforderungen, Keywords, Tonalität, „Must-haves" extrahieren.
3. **CV (CH-Standard)** nach `templates/cv-ch.md`:
   - Kompakt, max 2–3 Seiten, tabellarisch, umgekehrt chronologisch.
   - Foto-Platzhalter wenn Profil Foto vorsieht.
   - Achievements mit Zahlen, auf die Stelle zugespitzt (relevante Erfahrung nach oben).
   - Sprachen mit Niveau, relevante Skills/Tools, Weiterbildungen.
4. **Anschreiben** nach `templates/anschreiben.md`:
   - CH-Briefkopf (Absender, Firma/Empfänger, Ort + Datum, Betreff mit Stelle/Referenz).
   - 3–4 Absätze: Aufhänger (warum diese Firma) → Match (2–3 stärkste Belege aus dem Profil zur Anforderung) → Mehrwert/Motivation → Call-to-Action + Grußformel.
   - Konkret, keine Floskeln ("hiermit bewerbe ich mich" vermeiden), Bezug auf das Inserat.
5. **Speichern:** beide Dokumente als `.md` unter `dokumente/<Firma>_<Stelle>/`. Dateinamen: `CV_<Name>.md`, `Anschreiben_<Firma>.md`.
6. **Optional Word-Export:** Wenn der User .docx will → den Skill `anthropic-skills:docx` nutzen um professionelle Word-Dateien zu erzeugen.

7. **E-Mail-Entwurf anbieten:**
   Nach dem Erstellen von CV + Anschreiben immer fragen:
   > *„Soll ich auch einen E-Mail-Entwurf für die Bewerbung erstellen?"*

   **Wenn Ja:**
   a) Prüfe ob Gmail MCP verbunden ist (versuche `list_labels` aufzurufen):
      - **Kein Fehler → Gmail verbunden:** Erstelle den Entwurf direkt per `create_draft`:
        - `to`: E-Mail-Adresse der Firma (aus Inserat, sonst beim User erfragen)
        - `subject`: „Bewerbung als <Stelle> — <Vorname Nachname>"
        - `body`: Kurzvorstellung + Bezug auf Stelle + 2–3 Sätze Motivation + Hinweis auf Anhänge + Grussformel
        - Bestätige: *„Entwurf in Gmail gespeichert. Bitte Anhänge manuell hinzufügen."*
      - **Fehler → Gmail nicht verbunden:** Zeige E-Mail als Textblock zum Kopieren.
   b) Status im Tracker auf `erstellt (Entwurf)` setzen.

**Qualitätsregeln:**
- Jede Aussage auf das Inserat zugespitzt, keine Massenbewerbung.
- Achievements > Aufgaben (Resultate mit Zahlen statt „zuständig für…").
- Aktive, präzise Sprache. Keine Übertreibung, keine erfundenen Fakten.
- DE: korrekte Umlaute, Sie-Form, CH-Schreibweise (ß → ss). EN: professionelles Business-Englisch.

---

## Phase 4 — Tracking

Nach jeder erstellten Bewerbung eine Zeile in `profil/bewerbungen.md` ergänzen:

| Datum | Firma | Stelle | Sprache | Status | Inserat-Link | Dokumente |
|-------|-------|--------|---------|--------|--------------|-----------|

Status-Werte: `erstellt` → `versendet` → `Antwort` → `Gespräch` → `Zu-/Absage`.
Auf Nachfrage Übersicht/Statusupdate ausgeben.

---

## Regeln
- **Wahrheitspflicht:** Nie Qualifikationen/Erfahrung erfinden. Nur Profil-Daten verwenden. Lücken ehrlich benennen.
- **Profil zuerst:** Ohne Profil keine Dokumente — erst Phase 0.
- **CH-Konventionen:** kompakter CV, Foto optional, Sprachen mit Niveau, „ss" statt „ß".
- **Datenschutz:** Profil enthält persönliche Daten — bleibt lokal, nicht nach außen geben.
- **Kein Auto-Absenden:** Der Bot bereitet alles vor; das finale Absenden macht der User selbst.
