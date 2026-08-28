<div align="center">

  <img src="docs/images/app-logo.png" alt="Retire Me! logo" width="180" />

  <p align="center">
    <img src="docs/images/app-mockup.png" alt="Retire Me! mockup" width="100%" />
  </p>

  # Retire Me!

  **A gamified mobile application designed to help young adults plan for retirement and build healthy habits through daily check-ins.**

  <br />

  ![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
  ![Platform](https://img.shields.io/badge/Platform-iOS-000000?style=for-the-badge&logo=apple&logoColor=white)
  ![Framework](https://img.shields.io/badge/Framework-Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)

</div>

---

## Table of contents

- [Project overview](#project-overview)
- [Key features](#key-features)
- [Technology stack](#technology-stack)
- [Project structure](#project-structure)
- [Team](#team)

## Project overview

| Item | Details |
| --- | --- |
| Application Type | Mobile Application |
| Primary Platform | Android & iOS |

"Retire Me!" is an offline-first, gamified retirement preparation app targeted at young adults and professionals. It solves the problem of delayed financial and health planning by turning daily habit tracking—like avoiding junk food, saving small amounts of money, or completing life pillar missions—into a rewarding game complete with EXP, level progression, and long-term compound interest projections.

## Key features

| Feature | What the user can do |
| --- | --- |
| **Gamified Onboarding** | Choose a retirement archetype and a "Guilty Pleasure" to avoid daily. |
| **Daily Check-in** | Evaluate 4 life pillars (Financial, Health, Social, Purpose) and confirm habit avoidance to earn EXP. |
| **Compound Interest Projection** | Visualize estimated future retirement funds based on real daily savings. |
| **Health Metrics Conversion** | Track tangible lifetime health impacts (e.g., avoided sugar grams or nicotine sticks). |
| **Dynamic Avatar & Badges** | Level up the "Future Avatar" and unlock achievement badges based on consistency. |
| **Daily Mini Missions** | Complete simple daily tasks across the 4 pillars to boost weekly EXP. |


## Technology stack

| Category | Technology | Purpose |
| --- | --- | --- |
| Frontend | Flutter & Dart | Cross-platform UI Development |
| Architecture | Feature-based Architecture | Scalability and code organization |
| State Management | Provider | Managing global and local application state |
| Backend & DB | Shared Preferences / Hive | Offline-first data persistence (No Auth) |
| Data Visualization| fl_chart | Rendering Radar and Line charts for progress tracking |

## Project structure

```text
├── lib/
│   ├── core/         # Shared utilities, constants (colors), and universal widgets
│   ├── models/       # Data schemas (e.g., user_profile_model.dart)
│   ├── features/     # Feature modules
│   │   ├── onboarding/  # Archetype & Habit selection
│   │   ├── home/        # Dashboard & Daily Check-in logic
│   │   ├── progress/    # Lifetime projections and charts
│   │   ├── report/      # Weekly reports and mini-missions
│   │   └── profile/     # Settings and unlocked badges
│   └── main.dart     # Entry point of the application
├── assets/           # Images, avatars, and custom icons
└── pubspec.yaml      # Project dependencies
