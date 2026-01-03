# Google Home Script Editor & YAML Visualizer

A lightweight, visual tool to generate, edit, and understand **Google Home automation YAML scripts**. Perfect for creating complex **smart home routines** for the **Google Home Script Editor** (Public Preview) without writing code from scratch.

**[🚀 Try it live](https://moritzmessner.github.io/google-home-yaml-editor/)**

## What is this?

The [Google Home Script Editor](https://home.google.com/) unlocks powerful home automation capabilities using **YAML** scripting. It allows for much more complex logic than the standard Google Home app app routines, including multiple conditions, advanced starters, and precise device control. However, writing YAML syntax manually can be error-prone and unintuitive for many users.

This **Visual Editor** bridges the gap. It allows you to build your **advanced automations** using a user-friendly interface—selecting triggers, conditions, and actions from simple forms—while automatically generating the valid YAML code you need in real-time.

## Features

- **Visual Editor**: Edit automations using intuitive cards and forms
- **Live YAML Preview**: See the YAML output update in real-time as you edit
- **Side-by-Side Layout**: Visual editor on the left, YAML on the right
- **Import YAML**: Paste existing Google Home automation scripts to edit visually
- **Copy to Clipboard**: Easily copy the generated YAML for use in the Google Home web interface

## Example Workflows

Unlock the full potential of your smart home with these examples. You can find the full YAML files in the `examples/` folder of this repository:

- **[Movie Night (Filmabend)](examples/filmabend.yaml)**: *("Hey Google, Movie time")* - Dims the lights to 20%, sets a warm color temperature, and prepares the room for a cinema experience.
- **[Morning Routine (Morgenroutine)](examples/morgen_routine.yaml)**: *("Hey Google, Good Morning")* - Gradually brightens the bedroom lights, plays the news, and sets the thermostat.
- **[Work Focus (Arbeitsplatz Fokus)](examples/arbeitsplatz_fokus.yaml)**: *("Hey Google, Focus Mode")* - Sets desk lights to cool white (4000K) and 100% brightness for maximum concentration.
- **[Romantic Evening (Romantischer Abend)](examples/romantischer_abend.yaml)**: *("Hey Google, Romantic mode")* - Sets deep red/purple ambient lighting and warms up the room.
- **[Energy Saving (Energiesparen)](examples/abwesenheit_energiesparen.yaml)**: Automatically turns off all non-essential devices and lights when everyone leaves the house.
- **[Night Mode (Nachtmodus)](examples/nachtmodus.yaml)**: Ensures all lights are off and security systems are armed at specific times or by command.

## How to use with Google Home Script Editor

1. **Design**: Build your automation in this [visual tool](https://moritzmessner.github.io/google-home-yaml-editor/).
2. **Copy**: Click the "Copy to Clipboard" button or manually copy the YAML code from the right-hand panel.
3. **Go to Editor**: Visit [home.google.com/automations](https://home.google.com/automations) and sign in.
4. **Create New**: Click **+ Add new** and select **Script Editor**.
5. **Paste & Save**: Paste your generated code into the editor, click **Validate**, and then **Activate** (or Save).

## Resources & Codelabs

- **[Official Google Home Scripting Codelab](https://developers.home.google.com/codelabs/create-a-scripted-automation)**: A great starting point for learning how to write scripts manually.
- **[Google Home Developer Documentation](https://developers.home.google.com/automation/script-editor)**: The full reference for all available starters, conditions, and actions.
- **[Supported Devices List](https://developers.home.google.com/automations/supported-devices)**: A comprehensive list of device types supported by the Script Editor.
- **[Google Home Web (Automations)](https://home.google.com/automations)**: The web version of Google Home for automations.

## Common Automations

Here are some popular ideas you can build:
- **"Turn on lights when I arrive home"**: Use a `home.state.HomePresence` starter.
- **"Dim lights at sunset"**: Use a `time.schedule` starter keying off `sunset`.
- **"Flash lights when doorbell rings"**: Combine a device starter (Doorbell) with a repeated on/off action.

## Referencing Devices

When using devices in your scripts, you must reference them by their **exact name** as they appear in the Google Home app. 

- **Case Sensitivity**: Names are case-sensitive. "Living Room Lamp" is different from "living room lamp".
- **Quotes**: If your device name contains spaces or special characters, it is best practice to wrap it in quotes in your YAML (e.g., `- 'Living Room Light'`).
- **Uniqueness**: Ensure your devices have unique names across your home to avoid ambiguity in the Script Editor.

## Supported Components

### Triggers (Starters)
- **OK Google Command**: Custom voice phrases to start routines.
- **Device State**: Trigger when a device turns on/off, changes brightness, etc.
- **Time Schedule**: At specific times or relative to sunrise/sunset.

### Conditions
- **Time Between**: Restrict automations to only run during specific hours (e.g., only at night).
- **Device State**: Only run if a device is in a certain state (e.g., "only if the TV is on").

### Actions
- **On/Off**: Control power state.
- **Brightness**: Set absolute brightness (0-100%).
- **Color**: Set RGB or Color Temperature (Kelvin).
- **Delay**: Pause execution for a set duration.

## Getting Started for Developers

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

