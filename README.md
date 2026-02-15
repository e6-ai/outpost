# Outpost

Find co-living spaces worldwide for digital nomads & remote workers.

## Features

- 🗺️ Map view + list view of co-livings by destination
- 🔍 Search by city, country, or name
- 📶 Filter by WiFi quality — the #1 concern for remote workers
- 💰 Filter by price range
- 🏋️ Filter by amenities (coworking, pool, gym, etc.)
- ❤️ Save your favorite spaces
- 📱 Clean, modern SwiftUI interface

## Data

78+ curated co-living spaces from:
- ColivingCompass.com (scraped)
- Manual research from coliving.com, remoters.net, Mapmelon
- Well-known nomad co-livings worldwide

Data stored in `data/colivings.json`.

## Tech Stack

- SwiftUI + iOS 17+
- MapKit for map exploration
- XcodeGen for project generation
- Codemagic CI/CD

## Build

```bash
brew install xcodegen
xcodegen generate
open Outpost.xcodeproj
```

## Bundle ID

`ai.e6.colivingfinder`
