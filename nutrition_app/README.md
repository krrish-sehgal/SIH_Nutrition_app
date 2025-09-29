# AyurDiet Pro – SIH Nutrition Prototype

This Flutter prototype reimagines the original nutrition app into an Ayurveda-first practice management experience for Smart India Hackathon (SIH) submissions.

## Practitioner Highlights

- **Patient cockpit:** Quick glance at prakriti-driven tags, focus areas, and active plans with calorie/macros snapshots.
- **Rich patient profiles:** Lifestyle, digestion quality, bowel routines, and hydration trackers paired with practitioner notes.
- **Diet chart generator:** Blend modern goals (weight, activity level) with Ayurvedic intelligence (Rasa, Guna, Virya, prakriti). Pre-built templates seed plans with warming/cooling and digestibility labels.
- **Card-based plan view:** Meal cards list nutrients and Ayurvedic badges, plus one-tap swaps between curated alternatives.
- **Share & export stubs:** Simulated ABDM vault archive, PDF export, and instant patient-sync flows.

## Patient App Preview

A lightweight companion screen simulates the mobile experience for patients: meal reminders, plan overview, and quick access to recipe details.

## Getting Started

```bash
flutter pub get
flutter run
```

### Navigation cheatsheet

| Screen                 | Route             | Purpose                                                 |
| ---------------------- | ----------------- | ------------------------------------------------------- |
| Splash → Welcome       | `/splash`         | Entry animation and SIH mission blurb                   |
| Practitioner dashboard | `/dashboard`      | Patient list & plan snapshots                           |
| Patient profile        | `/patientProfile` | Deep dive into lifestyle + current plan                 |
| Diet generator         | `/dietGenerator`  | Configure goals/activity/prakriti and generate new plan |
| Diet plan view         | `/dietChart`      | Card view with share/export and swap actions            |
| Meal detail            | `/mealDetail`     | Ingredients, rasa, guna notes, alternatives             |
| Patient app preview    | `/patientApp`     | Simulated reminders & meal checklist                    |

> ℹ️ Authentication and workout/blog modules from the legacy project remain in the codebase but are no longer surfaced in navigation for this prototype.

## Next ideas

- Hook the generator to a real rules engine or LLM prompt for dynamic meal recommendations.
- Attach ABDM/EHR exports to actual API endpoints.
- Connect patient reminders to Firebase Cloud Messaging for true notifications.
