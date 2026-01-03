# Google Home Automation Beispiele

Diese Beispiele nutzen **deine echten Gerätenamen** und zeigen komplexe Automatisierungen für realistische Szenarien in deinem Zuhause.

## 📁 Beispiel-Dateien

### 🌅 [morgen_routine.yaml](morgen_routine.yaml)
**Komplexität:** Mittel  
**Verwendete Geräte:** Schlafzimmer (Links, Rechts, Bett), Flur (Flurlicht, Licht 11), Wohnzimmer (Fensterlampe, Schreibtisch, Luftreiniger)

**Features:**
- Zeitbasierte Auslöser mit Wochentag-Filterung (Mo-Fr vs. Wochenende)
- Sanftes Aufwachen mit `LightEffectWake` (10-15 Minuten)
- Gestaffelte Beleuchtung (Schlafzimmer → Flur → Wohnzimmer)
- Automatischer Luftreiniger-Start
- `time.delay` mit `for:` Syntax

**Anwendungsfall:** Automatisches, sanftes Aufwachen bei Sonnenaufgang mit gradueller Beleuchtung durch mehrere Räume.

---

### 🎬 [filmabend.yaml](filmabend.yaml)
**Komplexität:** Hoch  
**Verwendete Geräte:** Samsung The Frame 50, Wohnzimmer-Lichter (Sofa, Lava, Fensterlampe, Schreibtisch), Küche, Flur

**Features:**
- Sprachaktivierung ("Filmabend")
- **Wiedergabestatus-Erkennung** (`device.state.MediaState` mit PLAYING/PAUSED)
- Dynamische Helligkeitsanpassung bei Pause
- **Mehrere Automationen** in einer Datei
- Kino-Atmosphäre mit Hintergrundbeleuchtung
- Automatische Flur-Beleuchtung bei Pause

**Anwendungsfall:** Perfekte Kino-Atmosphäre mit Samsung The Frame TV, die sich automatisch an Wiedergabe/Pause anpasst.

---

### 💡 [abwesenheit_energiesparen.yaml](abwesenheit_energiesparen.yaml)
**Komplexität:** Hoch  
**Verwendete Geräte:** **Alle 24 Geräte** (Wohnzimmer, Schlafzimmer, Küche, Flur, TV, S8 Staubsauger)

**Features:**
- **Anwesenheitserkennung** (`home.state.HomePresence` mit HOME/AWAY)
- Massensteuerung aller Geräte
- S8 Staubsauger Dock-Automation
- **Batterie-Überwachung** (`device.state.EnergyStorage`)
- Zeitabhängige Willkommens-Szenarien (Tag vs. Nacht)
- Intelligente Rückkehr-Beleuchtung

**Anwendungsfall:** Automatisches Ausschalten aller Geräte beim Verlassen und intelligente Begrüßung bei Rückkehr.

---

### 🌙 [nachtmodus.yaml](nachtmodus.yaml)
**Komplexität:** Mittel  
**Verwendete Geräte:** Wohnzimmer (Lava), Schlafzimmer (Bett), Flur (Flurlicht, Licht 11), Sensor 1, Luftreiniger

**Features:**
- Sprachaktivierung ("Nachtmodus", "Guten Morgen")
- **Bewegungserkennung** (`device.event.MotionDetection` mit Sensor 1)
- Temporäre Beleuchtung mit `time.delay`
- Automatische Stummschaltung
- Sanftes Aufwachen mit `LightEffectWake`

**Anwendungsfall:** Nachtbeleuchtung mit Bewegungssensor-Aktivierung für nächtliche Toilettengänge.

---

### 💼 [arbeitsplatz_fokus.yaml](arbeitsplatz_fokus.yaml)
**Komplexität:** Mittel  
**Verwendete Geräte:** Schreibtisch, Bildschirm, Wohnzimmer-Lichter, Küche, Luftreiniger, Küchenlautsprecher

**Features:**
- Fokus-Modus mit Tageslicht-Farbe ("daylight")
- **Pause-Modus** (Pomodoro-Technik) mit Timer
- Ablenkungsreduzierung (TV aus, Ambiente-Lichter aus)
- Musik-Integration für Pausen
- Feierabend-Routine mit Umstellung auf Wohlfühl-Beleuchtung

**Anwendungsfall:** Optimale Arbeitsumgebung mit Fokus-Beleuchtung und strukturierten Pausen.

---

### 💕 [romantischer_abend.yaml](romantischer_abend.yaml)
**Komplexität:** Mittel  
**Verwendete Geräte:** Wohnzimmer (Sofa, Fensterlampe, Lava, Klavier), Küche (Esstisch, Komode), Küchenlautsprecher

**Features:**
- Farbsteuerung mit Farbnamen ("red", "warm white")
- Koordinierte Beleuchtung über mehrere Räume
- Musik-Integration
- Esstisch-Beleuchtung für Dinner
- Sanfte Rückkehr zur Normalbeleuchtung

**Anwendungsfall:** Romantische Atmosphäre für besondere Abende mit dynamischer Beleuchtung.

---

## 🎯 Wichtige Syntax-Regeln

### Struktur
```yaml
metadata:
  name: Name
  description: Beschreibung

automations:
  - starters:      # Liste (mit -)
      - type: ...
    
    condition:     # KEINE Liste (kein -)
      type: ...
    
    actions:       # Liste (mit -)
      - type: ...
```

### Häufige Befehle

| Befehl | Parameter | Beispiel |
|--------|-----------|----------|
| `device.command.OnOff` | `devices:`, `on: true/false` | Lichter an/aus |
| `device.command.BrightnessAbsolute` | `devices:`, `brightness: 0-100` | Helligkeit setzen |
| `device.command.ColorAbsolute` | `devices:`, `color: {name: "..."}` | Farbe setzen |
| `time.delay` | `for: 5min` | Pause zwischen Aktionen |
| `assistant.command.Broadcast` | `message:`, optional `devices:` | Durchsage |
| `device.command.LightEffectWake` | `duration:`, `wakeBrightness:` | Sanft aufhellen |
| `device.command.LightEffectSleep` | `duration:`, `sleepBrightness:` | Sanft dimmen |

### Wichtige Hinweise

- **`condition:` ist KEINE Liste** (kein `-` davor)
- **`time.delay` nutzt `for:`** nicht `duration:`
- **Gerätenamen** müssen mit Raum-Suffix sein: `Lava - Wohnzimmer`
- **`Lava - Wohnzimmer`** unterstützt nur On/Off (keine Helligkeit)
- **`Luftreiniger - Wohnzimmer`** ist an Smart Plug (nur On/Off, kein SetFanSpeed)
- **Farben** mit Namen: `"warm white"`, `"daylight"`, `"red"`

---

## 🏠 Deine Geräte-Übersicht

### Wohnzimmer (9 Geräte)
- `Wohnzimmer - Wohnzimmer` (Speaker)
- `Wohnzimmer Lights - Wohnzimmer` (Gruppe)
- `Wohzimmerlicht - Wohnzimmer` (Licht mit Helligkeit)
- `Sofa - Wohnzimmer`, `Fensterlampe - Wohnzimmer`, `Schreibtisch - Wohnzimmer`, `Klavier - Wohnzimmer` (Lichter mit Helligkeit)
- `Lava - Wohnzimmer` (**nur On/Off**)
- `Luftreiniger - Wohnzimmer` (Smart Plug, nur On/Off)
- `Samsung The Frame 50 - Wohnzimmer` (TV)
- `Bildschirm - Wohnzimmer` (Display)

### Schlafzimmer (4 Geräte)
- `Schlafzimmer Lights - Schlafzimmer` (Gruppe)
- `Bett - Schlafzimmer`, `Links - Schlafzimmer`, `Rechts - Schlafzimmer`

### Küche (5 Geräte)
- `Küche Lights - Küche` (Gruppe)
- `Esstisch - Küche`, `Komode - Küche` (Lichter mit Helligkeit)
- `Küchenlautsprecher - Küche` (Speaker)
- `S8 - Küche` (Staubsauger)

### Flur (4 Geräte)
- `Flur Lights - Flur` (Gruppe)
- `Flurlicht - Flur`, `Licht 11 - Flur`
- `Sensor 1 - Flur` (Bewegungssensor)

---

## 💡 Nutzungshinweise

1. **Importieren:** Kopiere den YAML-Inhalt in den Google Home Script Editor
2. **Testen:** Beginne mit einfachen Beispielen wie "Morgen Routine"
3. **Anpassen:** Ändere Zeiten, Helligkeiten und Farben nach deinen Wünschen
4. **Kombinieren:** Mische Features aus verschiedenen Beispielen

---

## 🚀 Empfohlene Lernreihenfolge

1. **Einsteiger:** `morgen_routine.yaml` - Einfache Zeitauslöser und Lichteffekte
2. **Fortgeschritten:** `nachtmodus.yaml` - Sprachaktivierung und Bewegungssensor
3. **Profi:** `filmabend.yaml` - Gerätestatus-Erkennung und dynamische Anpassungen
4. **Experte:** `abwesenheit_energiesparen.yaml` - Massensteuerung und Anwesenheitserkennung

---

**Hinweis:** Alle Beispiele verwenden deine echten Gerätenamen und sind sofort einsatzbereit!
