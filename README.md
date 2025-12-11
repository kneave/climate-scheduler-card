# Climate Scheduler Card

A custom Lovelace card for the [Climate Scheduler](https://github.com/kneave/climate-scheduler) integration.

**Note**: This card requires the Climate Scheduler integration to be installed. It provides the frontend UI while the integration provides the backend services.

## Installation

### HACS (Recommended)

1. Open HACS
2. Go to "Frontend"
3. Click "+ Explore & Download Repositories"
4. Search for "Climate Scheduler Card"
5. Click "Download"
6. Restart Home Assistant (not always required, but recommended)

### Manual Installation

1. Download \climate-scheduler-card.js\ from the latest release
2. Copy all files from \dist/\ to \/config/www/community/climate-scheduler-card/\
3. Add the resource in your Lovelace configuration:
   - Go to Settings → Dashboards → Resources
   - Click "+ Add Resource"
   - URL: \/local/community/climate-scheduler-card/climate-scheduler-card.js\
   - Resource type: JavaScript Module

## Requirements

**You must have the Climate Scheduler integration installed:**
- Install from [HACS](https://hacs.xyz) or
- Manual install from [GitHub](https://github.com/kneave/climate-scheduler)

The card will show an error if the integration is not found.

## Usage

### As a Dashboard Card

Add to your dashboard:

```yaml
type: custom:climate-scheduler-card
```

### As a Full Panel

Add to your \configuration.yaml\:

```yaml
lovelace:
  mode: yaml
  dashboards:
    climate-scheduler:
      mode: yaml
      title: Climate Scheduler
      icon: mdi:calendar-clock
      show_in_sidebar: true
      filename: climate-scheduler.yaml
```

Then create \climate-scheduler.yaml\:

```yaml
views:
  - title: Climate Scheduler
    path: climate-scheduler
    panel: true
    cards:
      - type: custom:climate-scheduler-card
```

## Features

- 📱 Touch-friendly graph editor
- ⏰ 15-minute precision scheduling
- 📊 Visual temperature graph with draggable nodes
- 📈 Temperature history overlay
- 🏠 Multi-entity & group support
- ⚙️ Advanced climate controls (HVAC mode, fan mode, etc.)
- 🌡️ Automatic °C/°F conversion

## Screenshots

![Graph Editor](https://raw.githubusercontent.com/kneave/climate-scheduler/main/screenshots/graph-editor.png)

## Support

- [Report Issues](https://github.com/kneave/climate-scheduler/issues)
- [Integration Documentation](https://github.com/kneave/climate-scheduler)
- [Community Forum](https://community.home-assistant.io/)

## License

MIT License - see [LICENSE](LICENSE)
