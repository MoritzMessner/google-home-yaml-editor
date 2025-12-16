# Google Home YAML Editor

A lightweight Flutter web app for visually editing Google Home automation YAML scripts.

**[🚀 Try it live](https://moritzmessner.github.io/google-home-yaml-editor/)**

## Features

- **Visual Editor**: Edit automations using intuitive cards and forms
- **Live YAML Preview**: See the YAML output update in real-time as you edit
- **Side-by-Side Layout**: Visual editor on the left, YAML on the right
- **Import YAML**: Paste existing Google Home automation scripts to edit visually
- **Copy to Clipboard**: Easily copy the generated YAML

## Supported Automation Components

### Triggers (Starters)
- **OK Google Command**: Voice-activated triggers
- **Device State**: Trigger when a device state changes

### Conditions
- **Time Between**: Only run automation during specific hours (supports sunrise/sunset)

### Actions
- **On/Off**: Turn devices on or off
- **Brightness**: Set device brightness (0-100%)
- **Color**: Set color by name or temperature (Kelvin)
- **Delay**: Wait before next action

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)

### Run Locally

```bash
# Get dependencies
flutter pub get

# Run on web
flutter run -d chrome
```

### Build for Production

```bash
flutter build web
```

## Example YAML Output

```yaml
metadata:
  name: Cozy Living Room
  description: Warm ambient lighting for movie night

automations:
  - starters:
      - type: assistant.event.OkGoogle
        eventData: query
        is: "Movie time"

    condition:
      type: time.between
      after: sunset
      before: 23:00

    actions:
      - type: device.command.BrightnessAbsolute
        devices:
          - Living Room Light
        brightness: 20
      - type: device.command.ColorAbsolute
        devices:
          - Living Room Light
        color:
          temperature: 2700K
```

## License

MIT

