# 📁 AppleSWIFT
- — *STRUCTURE (v1.1.0)*

Ce document *décrit la structure exacte du dépôt* **AppleSWIFT**.

### 📦 》》 Racine du dépôt
```text
AppleSWIFT/
├── Package.swift
├── README.md
├── structure.md
├── .github/
│   └── PULL_REQUEST_TEMPLATE.md
├── Sources/
│   └── APP/
│       ├── AppleSWIFT.swift
│       ├── ModelParser.swift
│       └── NumberValidator.swift
└── Tests/
    └── APPTests/
        └── AppleSWIFTTests.swift
```

》》 📝 **Package.swift**
- Configuration Swift Package Manager (Swift 5.9+, aucune dépendance externe).
- Mappe le module public `AppleSWIFT` sur `Sources/APP` et les tests sur `Tests/APPTests`.

》》 📘 **README.md**
- Documentation principale du projet (v1.1.0).

》》 📂 **Sources/APP/**
- `AppleSWIFT.swift` : Façade publique `Sendable` du framework.
- `ModelParser.swift` : Analyse et formatage de chaînes (`brand`, `model`, `formatted`).
- `NumberValidator.swift` : Normalisation, validation E.164 basique et masquage RGPD (`masked`).

》》 🧪 **Tests/APPTests/**
- `AppleSWIFTTests.swift` : Tests unitaires `XCTest` couvrant parsing, validation, masquage et garde‑fous.

》》 🛡️ **.github/**
- `PULL_REQUEST_TEMPLATE.md` : Modèle standardisé pour les Pull Requests.

---

### 🎯 Résumé clair

| Élément | Présent | Description |
| :--- | :---: | :--- |
| `Package.swift` | ✔️ | Configuration SwiftPM |
| `README.md` | ✔️ | Documentation principale (v1.1.0) |
| `Sources/APP/` | ✔️ | Code source du framework |
| `Tests/APPTests/` | ✔️ | Suite de tests unitaires `XCTest` |
| `.github/` | ✔️ | Gouvernance (`PULL_REQUEST_TEMPLATE.md`) |
