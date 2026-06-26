---
name: bewerbung
description: >
  Persönlicher Bewerbungs-Assistent für den Schweizer Arbeitsmarkt. Sucht passende Stellen, schlägt sie begründet vor und erstellt pro Stelle einen maßgeschneiderten CV + Anschreiben (Deutsch oder Englisch je nach Inserat, CH-Standard). Speichert dein Profil einmalig und nutzt es immer wieder. Trigger auf: /bewerbung, "Bewerbung schreiben", "Job suchen", "Stelle finden", "Lebenslauf", "CV erstellen", "Anschreiben", "Motivationsschreiben", "Jobsuche", "auf eine Stelle bewerben".
---

# Bewerbung — Schweizer Job- & Bewerbungs-Assistent

Task-Agent der den kompletten Bewerbungs-Workflow abdeckt: Profil erfassen → Stellen
suchen → vorschlagen → recherchieren → CV + Anschreiben maßschneidern → Bewerbungen tracken.
Markt: **Schweiz** (Default), internationale Suche je nach Profil. Sprache der Dokumente: **DE oder EN je nach Stelleninserat**.

---

## Schnell-Modus: Stelle per Screenshot

Wenn der Nutzer ein **Bild/Screenshot einer Stelle** schickt (statt selbst suchen zu lassen):

1. Aus dem Bild extrahieren: **Firma, Jobtitel, Ort, Referenz-Nr.** (falls sichtbar) + Kern-Keywords.
2. Das Live-Inserat finden:
   - `mcp__jobspy__search_jobs` (Suchterm = Titel + Firma, Location = Ort)
   - falls verbunden: TheirStack
   - sonst: normale Websuche nach „<Firma> <Jobtitel> <Ort> Bewerbung/apply"
3. Dem Nutzer den **direkten Bewerbungs-Link** + 1-Satz-Bestätigung liefern („Gefunden: <Stelle> bei <Firma>, hier bewerben: <Link>").
4. Anbieten: *„Soll ich für diese Stelle die Firma + das Inserat recherchieren und dir CV + Anschreiben erstellen?"* → bei Ja weiter zu **Phase 2.5** (Profil aus Phase 0 muss dafür existieren).

Findet der Bot das Inserat nicht eindeutig → die wahrscheinlichsten Treffer mit Links zeigen und nachfragen welcher es ist.

---

## Datenablage (persistent im Vault)
- Profil: `DEIN_VAULT/bewerbung/profil/profil.md`
- Bewerbungs-Tracker: `DEIN_VAULT/bewerbung/profil/bewerbungen.md`
- Generierte Dokumente: `DEIN_VAULT/bewerbung/dokumente/<Firma>_<Stelle>/`
- Vorlagen-Referenz: `~/.claude/skills/bewerbung/templates/`
- Scripts: `~/.claude/skills/bewerbung/scripts/`

---

## Phase 0.5 — MCP-Setup (einmalig, beim ersten Start)

Prüfe zuerst still ob JobSpy oder TheirStack bereits verbunden sind:
- JobSpy verbunden? → `jobspy_search` Tool verfügbar?
- TheirStack verbunden? → `theirstack` Tool verfügbar?

**Wenn beide bereits verbunden:** kurz bestätigen → direkt weiter zu Phase 0.

**Wenn keines oder nur eines verbunden:** dem User folgendes erklären:

---

> *„Bevor wir starten: Für die Jobsuche gibt es zwei Tools die ich direkt verknüpfen kann — das erhöht die Trefferquote deutlich, weil ich dann live auf echte Stellendatenbanken zugreife statt nur zu googeln.*
>
> **Tool 1 — JobSpy** *(empfohlen, komplett gratis)*
> Durchsucht LinkedIn, Indeed, Glassdoor und ZipRecruiter gleichzeitig in Echtzeit.
> Was installiert wird: ein Python-Paket auf deinem Computer (`jobspy-mcp-server`) + eine Verbindung zu Claude Code.
> Sicherheit: Open-Source, läuft lokal, kein Account nötig, keine Daten gehen nach aussen.
>
> **Tool 2 — TheirStack** *(207 Millionen Stellen, 195 Länder)*
> Riesige globale Jobdatenbank — ideal für internationale Suche und Nischenrollen.
> Was installiert wird: nur eine URL-Verbindung zu deren Server, kein lokales Paket.
> Sicherheit: SaaS-Dienst, du loggst dich per OAuth ein (wie "Login mit Google"). Kostenlos bis 200 Credits/Monat, danach $59/Monat.
>
> **Tool 3 — Perplexity Deep Research** *(optional, kostenpflichtig)*
> Tiefe Live-Web-Recherche zu Firma, Standort, Kultur und Erfahrungsberichten — für besonders zugeschnittene Bewerbungen.
> Kosten: prepaid auf deinem Perplexity-Konto, grob **~$5–14 pro 1'000 Anfragen + Token** → in der Praxis wenige Cent pro Recherche.
> Braucht einen eigenen API-Key (`pplx-…`). **Wird nie automatisch genutzt — der Bot fragt jedes Mal vorher und nennt die Kosten.** Einrichtung wird später Schritt für Schritt erklärt, sobald du es zum ersten Mal nutzen willst.
>
> **Ohne diese Tools:** Ich suche trotzdem — aber über normale Websuche, das ist weniger präzise und kann Stellen verpassen die nicht öffentlich indexiert sind.
>
> Was möchtest du?
> → **A) Beide installieren** (maximale Abdeckung, empfohlen)
> → **B) Nur JobSpy** (gratis, reicht für die meisten Fälle)
> → **C) Nur TheirStack** (bessere globale Abdeckung, begrenzte Gratis-Credits)
> → **D) Keines** (Websuche reicht mir, ich akzeptiere die eingeschränkte Trefferquote)"*

---

**Installation je nach Wahl — immer erst Bestätigung einholen, dann ausführen:**

**JobSpy installieren (Wahl A oder B):**
1. Prüfe ob Python vorhanden: `python3 --version`
   - **Nicht vorhanden:** erklären → *„Dafür brauchen wir Python. Das ist eine kostenlose Programmiersprache die viele Tools nutzen — kein Risiko. Ich installiere es mit Homebrew: `brew install python3`. Okay?"* → Bestätigung abwarten → installieren
2. Bestätigung einholen: *„Ich installiere jetzt `jobspy-mcp-server` (Python-Paket, ~5MB, gratis). Okay?"*
3. Nach Ja: `pip3 install jobspy-mcp-server`
4. MCP verbinden: `claude mcp add jobspy -- python3 -m jobspy_mcp_server`
5. Bestätigen: *„JobSpy ist verbunden. Claude Code muss einmal neu gestartet werden — bitte kurz schliessen und wieder öffnen, dann bin ich mit echten Jobdaten ausgestattet."*

**TheirStack installieren (Wahl A oder C):**
1. Bestätigung: *„Ich verbinde jetzt TheirStack — du wirst kurz nach einem Login (OAuth) gefragt. Okay?"*
2. Nach Ja: `claude mcp add TheirStack --transport http https://api.theirstack.com/mcp`
3. Bestätigen: *„TheirStack verbunden. Nach dem Neustart von Claude Code kannst du dich per OAuth einloggen (einmalig)."*

**Nach Installation:** User auffordern Claude Code neu zu starten, dann `/bewerbung` erneut starten.

---

## Phase 0 — Profil prüfen / anlegen

1. Prüfe ob `profil/profil.md` existiert.
2. **Existiert es:** kurz laden, dem User 1 Satz Bestätigung ("Profil geladen: <Name>, <Zielrolle>"). Frag ob etwas aktualisiert werden soll, sonst weiter.
3. **Existiert es NICHT:** Interview führen. Frag strukturiert, in sinnvollen Häppchen (nicht alle 20 Fragen auf einmal — erst Block A, dann B, dann C):

   **Block A — Kontakt & Eckdaten:** Name, Adresse/Wohnort, Telefon, E-Mail, LinkedIn/Portfolio, Geburtsjahr (optional, CH-üblich), Nationalität/Arbeitsbewilligung, Foto vorhanden? (CH-CV oft mit Foto)

   **Block B — Beruf & Ziel:** aktuelle/letzte Position, Zielposition(en), Branche, Wunschpensum (z.B. 80–100 %), frühester Eintritt, Gehaltsvorstellung (optional).

   Dann explizit fragen:
   > *„In welchen Regionen/Ländern suchst du? (z.B. Schweiz, DACH, ganz Europa, USA, global)"*
   - **USA:** nachfragen ob Visa-Sponsoring benötigt wird (J-1, H-1B, OPT etc.) → nur Stellen filtern die explizit sponsern
   - **Europa (EU/EWR):** Arbeitserlaubnis klären (EU-Bürger frei, sonst Visa nötig?)
   - **Global:** Sprache der Bewerbung pro Land festlegen (EN für USA/UK/international, DE für DACH, FR für Frankreich etc.)
   - Zielregion im Profil speichern, wird bei jeder Suche berücksichtigt

   **Block C — Werdegang:** Berufserfahrung (pro Station: Firma, Rolle, Zeitraum, 2–4 Achievements mit Zahlen), Ausbildung/Abschlüsse, Weiterbildungen/Zertifikate.

   **Block D — Skills & Sprachen:** Hard Skills/Tools, Soft Skills, Sprachen mit Niveau (z.B. Deutsch Muttersprache, Englisch C1, Französisch B1), Referenzen (vorhanden?).

   Dann zwei gezielte Fragen für stärkere, ehrlichere Bewerbungen:
   > *„Für jede wichtige Fähigkeit: Wo hast du sie schon konkret bewiesen? Gib mir Stichworte — z.B. ‚Excel: Reporting für 12 Filialen automatisiert'. Ich baue daraus eine Beweis-Liste."*
   > *„Gibt es Schwächen, die ein Arbeitgeber sieht (z.B. Notendurchschnitt, Lücke im Lebenslauf, Quereinstieg)? Sollen wir die proaktiv ansprechen und entkräften? Wenn ja: was ist dein bestes Gegenargument?"*
   > *„Nenn mir 1–2 Beispiele, wo du dir etwas selbst beigebracht oder eigenständig gelöst hast — falls eine Stelle mehr verlangt als du formal nachweisen kannst, nutze ich das als Argument."*

   → Speichern in `## Stärken-Beweise`, `## Schwachpunkte` (mit Flag `aktiv ansprechen: ja/nein` + Gegenargument) und `## Eigenständigkeit` im Profil.

4. Speichere alles strukturiert in `profil/profil.md` (Format: siehe Vorlage `templates/profil-vorlage.md`). Bestätige kurz.

   **Block E — Schreibstil erfassen** (immer nach Block D, nie überspringen):
   > *„Damit ich Anschreiben und CV-Texte in deinem persönlichen Stil schreibe: Hast du einen kurzen Text von dir — eine E-Mail, ein LinkedIn-Post, ein früheres Anschreiben? Einfach hier reinkopieren."*

   Wenn der User einen Text liefert oder explizit in seinem Stil schreiben möchte:
   → **Führe den Skill `anthropic-skills:mein-schreibstil` aus** (Modus A — Analyse-Protokoll).
   → Der Skill analysiert die Probe systematisch entlang 7 Dimensionen (Stimme, Satzmuster, Wortschatz, Interpunktion, Struktur, Ich-Bezug, Meinungsäußerung) und erstellt ein vollständiges STILPROFIL mit IMMER-TUN- und NIE-TUN-Regeln.
   → Das fertige STILPROFIL wird als Abschnitt `## Schreibstil` in `profil/profil.md` gespeichert.
   → Ab Phase 3 gilt automatisch Modus B des Schreibstil-Skills: alle Anschreiben und Kurzprofile werden im Stil des Users geschrieben.

   Falls der User keinen Text liefert und keinen eigenen Stil wünscht → „professionell, CH-Standard" vormerken und weitermachen.

   **Block F — CV-Vorlage prüfen** (nach Block E):
   > *„Manche Firmen oder Programme haben eine eigene CV-Vorlage (z.B. PE-Funds, Consulting-Firmen, US-Uni-Programme). Hast du für diese Stelle eine vorgegebene Vorlage? Falls ja, einfach hier reinkopieren oder beschreiben."*
   - **Vorlage vorhanden:** Diese Struktur exakt einhalten, nur Inhalte aus Profil einfüllen
   - **Keine Vorlage:** Standard-Template je nach Zielregion verwenden:
     - CH/DACH → `templates/cv-ch.md` (mit Foto, Pensum, Nationalität)
     - USA/UK/International → einseitiger US-Style CV (kein Foto, kein Alter, keine Nationalität, starke Action Verbs, Bullet Points mit Metriken)
     - EU (nicht DACH) → angepasst je nach Land (FR: photo usual; NL/Nordic: no photo)

> **Wichtig:** Nur echte Angaben des Users speichern und später verwenden. Niemals Erfahrung, Abschlüsse oder Skills erfinden — Bewerbungen müssen wahrheitsgemäß sein.

---

## Phase 1 — Stellen suchen

1. Suchkriterien aus dem Profil ableiten (Zielrolle, Region, Pensum) — oder vom User eine konkrete Vorgabe/URL nehmen.
2. Suchquellen je nach Zielregion aus dem Profil:

   **Schweiz / DACH:**
   `jobs.ch`, `jobscout24.ch`, `indeed.ch`, `linkedin.com/jobs`, `xing.com`, Firmen-Karriereseiten

   **Europa (EU/EWR) — Internships & Trainee:**
   `linkedin.com/jobs` (EN-Suche), `glassdoor.com`, `eurojobs.com`, `gradcracker.com` (UK), `indeed.co.uk` / `indeed.de` / `indeed.fr`, `thelocal.com/jobs`, direkt auf Firmen-Karriereseiten (PE: KKR, Blackstone, Carlyle, Apollo; Consulting: McKinsey, BCG, Bain, Roland Berger; Banks: Goldman, JPM, MS)

   **USA — mit Visa-Sponsoring:**
   `linkedin.com/jobs` (Filter: "Sponsor visa"), `indeed.com`, `glassdoor.com`, `h1bdata.info` (zeigt welche Firmen H-1B sponsern), `myvisajobs.com`, `levels.fyi` (Tech), direkte Karriereseiten grosser Sponsoren
   - Bei US-Suche immer Keywords ergänzen: "visa sponsorship", "OPT", "CPT", "international students welcome"
   - J-1 Internship: Programme wie CIEE, Cultural Vistas, intern-usa.com

   **Für Internships spezifisch:**
   `internships.com`, `wayup.com`, `chegg.com/internships`, `ratemyplacement.co.uk` (UK), `stageemploi.fr` (FR), `praktikum.info` (DE), Uni-Karrierebörsen

3. **Realismus-Hinweis:** Inserate hinter Login nicht vollständig abrufbar → öffentliche Daten + Firmen-Karriereseite nutzen. Bei US-Stellen: Visa-Sponsoring immer im Inserat bestätigen lassen — nicht alle die es nicht erwähnen sponsern auch.

---

## Phase 2 — Vorschläge präsentieren

Pro gefundener Stelle eine kompakte Karte:
- **Titel · Firma · Ort · Pensum**
- **Match-Score** (1–5) + 1 Satz warum es zum Profil passt
- **Lücken/Risiken** (was im Profil fehlt für diese Stelle, ehrlich)
- Link zum Inserat

Sortiert nach Match-Score. Dann fragen: *"Für welche Stelle(n) soll ich Bewerbungsunterlagen erstellen?"*

---

## Phase 2.5 — Recherche vor dem Schreiben (pro gewählter Stelle, vor Phase 3)

Niemals direkt losschreiben. Erst ein kompaktes Recherche-Briefing erstellen, das in CV + Anschreiben einfliesst:

**a) Branchenstandard:** Was erwarten Arbeitgeber für genau diese Rolle/Branche/Seniorität? Übliche Pflicht-Skills, Keywords, Tonalität. Quelle: 2–3 Vergleichsinserate (JobSpy/Websuche).

**b) Firma:** Karriereseite, Werte/Mission, Produkte, aktuelle News. Ziel: 1–2 konkrete Anknüpfungspunkte, an denen man echte Auseinandersetzung mit der Firma erkennt (nicht „Ihr renommiertes Unternehmen"). Quelle: Websuche + Firmenseite.

**c) Job-Offer im Detail:** Muss- vs. Kann-Anforderungen trennen, exakte Keywords und Tonalität des Inserats extrahieren.

**d) Optional — Deep-Research über Perplexity (kostenpflichtig, immer erst fragen):**
   Wenn tiefere Recherche zu Firma/Standort/Kultur den Match deutlich verbessern würde, fragen:
   > *„Soll ich über die Perplexity-API tiefer recherchieren? Das kostet dich nur wenige Cent pro Abfrage (prepaid auf deinem Perplexity-Konto). Ja / Nein?"*
   - **Nein:** mit Standard-Websuche weitermachen.
   - **Ja, aber noch kein Key eingerichtet:** → Setup-Flow durchführen (siehe unten), dann nutzen.
   - **Ja, Key vorhanden:** Wrapper aufrufen: `bash ~/.claude/skills/bewerbung/scripts/perplexity_search.sh "<konkrete Recherche-Frage zu Firma/Standort>"`
   - **Wichtig:** auch bei eingerichtetem Key **jedes Mal vorher fragen** — nie automatisch abrechnen.

   **Perplexity-Key Setup (einmalig, Key NIE im Chat eingeben):**
   1. *„Geh auf perplexity.ai → Settings → Tab ‚API'. Lade dort etwas Guthaben auf (prepaid, z.B. $5)."*
   2. *„Generiere einen API-Key (beginnt mit `pplx-`). Er wird nur einmal angezeigt — sofort kopieren."*
   3. *„Trag den Key selbst in deinem Terminal ein (nicht hier im Chat):"*
      ```
      echo 'export PERPLEXITY_API_KEY="pplx-DEIN_KEY"' >> ~/.zshrc
      ```
      *„Dann ein neues Terminal öffnen."*
   4. Prüfen ob gesetzt — **ohne den Wert auszugeben**: `[ -n "$PERPLEXITY_API_KEY" ] && echo "Key ist gesetzt" || echo "noch nicht gesetzt"`
   > Begründung Sicherheit: Der Key darf nicht in den Chat und nicht als sichtbares CLI-Argument — sonst landet er im Klartext in Logs/Configs.

**Ergebnis:** internes Briefing (3–6 Bullet-Punkte) — fliesst direkt in Phase 3 ein. Generisch, keine Annahmen über Person/Studienort.

---

## Phase 3 — CV + Anschreiben erstellen (pro gewählter Stelle)

1. **Sprache bestimmen:** Inserat auf Deutsch → Dokumente auf Deutsch. Inserat auf Englisch → auf Englisch. Im Zweifel nachfragen.
2. **Inserat analysieren:** Schlüssel-Anforderungen, Keywords, Tonalität, „Must-haves" extrahieren.
3. **CV — Format je nach Situation:**

   **A) Firmenvorlage vorhanden (aus Block F):** Vorlage exakt übernehmen, Felder mit Profil-Daten befüllen, Stil aus Block E anwenden.

   **B) USA / UK / International (kein DACH):**
   - 1 Seite (Intern/Entry-Level), max 2 Seiten
   - **Kein Foto, kein Alter, keine Nationalität, kein Zivilstand** (US-Recht)
   - Starke Action Verbs: "Led", "Built", "Drove", "Increased", "Reduced"
   - Bullet Points mit Metriken: "Increased X by Y% resulting in Z"
   - Sections: Summary (optional) → Experience → Education → Skills
   - GPA angeben wenn ≥ 3.5 (USA-Norm)

   **C) CH/DACH** nach `templates/cv-ch.md`:
   - Max 2–3 Seiten, tabellarisch, umgekehrt chronologisch
   - Foto optional, Pensum, Nationalität/Bewilligung
   - Achievements mit Zahlen

   **D) Europa (nicht DACH, nicht UK):**
   - Europass-Format wenn kein anderes vorgegeben (besonders Osteuropa, südl. EU)
   - Sonst: an lokale Norm anpassen (FR: Foto üblich; NL/Nordics: kein Foto)
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
   a) Prüfe ob Gmail MCP verbunden ist, indem du `mcp__ffe68ee8-4723-48fb-b5d7-966d130af9df__list_labels` aufrufst:
      - **Kein Fehler → Gmail verbunden:** Erstelle den Entwurf direkt mit `mcp__ffe68ee8-4723-48fb-b5d7-966d130af9df__create_draft`:
        - `to`: E-Mail-Adresse der Firma (aus Inserat, falls vorhanden — sonst beim User erfragen)
        - `subject`: „Bewerbung als <Stelle> — <Vorname Nachname>" (oder wie im Inserat verlangt)
        - `body`: professionelle Bewerbungs-E-Mail:
          - Kurzvorstellung + Bezug auf die Stelle
          - 2–3 Sätze aus dem Anschreiben (Motivation + stärkstes Argument)
          - Hinweis auf Anhänge: CV + Anschreiben
          - Grussformel (DE: „Freundliche Grüsse" / EN: „Kind regards")
        - Bestätige dem User: *„Entwurf in Gmail gespeichert. Bitte Anhänge (CV.pdf, Anschreiben.pdf) manuell hinzufügen bevor du sendest."*
      - **Fehler → Gmail nicht verbunden:** Zeige dem User die fertige E-Mail als Textblock zum Kopieren:
        ```
        Betreff: Bewerbung als <Stelle> — <Name>

        <E-Mail-Text>
        ```
        Hinweis: *„Gmail MCP ist nicht verbunden — du kannst den Text oben direkt in dein Mail-Programm kopieren."*
   b) Status im Tracker automatisch auf `erstellt (Entwurf)` setzen wenn Entwurf in Gmail.

**Qualitätsregeln für „hochstehende" Bewerbungen:**
- Jede Aussage auf das Inserat zugespitzt, keine generische Massenbewerbung.
- **Recherche-Briefing aus Phase 2.5 einarbeiten:** konkrete Firmen-Anknüpfungspunkte im Aufhänger nutzen, Inserat-Keywords aufgreifen, Tonalität an Branchenstandard anpassen.
- Achievements > Aufgaben (Resultate mit Zahlen statt „zuständig für…").
- **Skill-Beweis-Prinzip:** Jede behauptete Fähigkeit mit einem konkreten Beleg aus `## Stärken-Beweise` koppeln — „kann X, bewiesen durch Y". Nie eine Fähigkeit ohne Beleg behaupten, nie generische Floskeln („teamfähig, motiviert").
- **Schwächen-Handling:** Wenn `## Schwachpunkte` ein Feld mit `aktiv ansprechen: ja` enthält (z.B. Noten, Lücke), die Schwäche im Anschreiben kurz und selbstbewusst benennen und sofort mit dem hinterlegten Gegenargument auffangen — nicht verstecken, aber auch nicht breittreten.
- **Eigenständigkeit als Hebel:** Wenn eine Stelle mehr verlangt als der Nutzer formal nachweisen kann, das Selbstlern-/Eigenständigkeits-Beispiel aus `## Eigenständigkeit` einsetzen — konkret mit Beispiel, nicht als Floskel.
- **Schreibstil aus Profil anwenden:** Wenn `## Schreibstil` in `profil.md` ein STILPROFIL enthält, aktiviere Modus B des `anthropic-skills:mein-schreibstil`-Skills. Struktur und CH-Format bleiben fix — aber Ton, Satzmuster, Wortwahl sowie alle IMMER-TUN- und NIE-TUN-Regeln aus dem Profil greifen vollständig für Anschreiben und Kurzprofil-Text.
- **KI-Sprache raus:** Vor dem finalen Output den `humanizer`-Skill auf Anschreiben + Kurzprofil anwenden — der Text muss nach dem Nutzer klingen, nicht nach einem Bot.
- Keine Übertreibung, keine erfundenen Fakten.
- DE: korrekte Umlaute, CH-Schreibweise (ß → ss). EN: professionelles Business-Englisch.

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
- **Datenschutz:** Profil enthält persönliche Daten — bleibt lokal im Vault, nicht nach außen geben.
- **Kein Auto-Absenden:** Der Bot bereitet alles vor; das finale Absenden/Hochladen macht der User selbst (Login-/Formular-Schritte).
