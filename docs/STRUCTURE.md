# 📁 AppleSWIFT
- — *STRUCTURE*

Ce document *décrit la structure exacte du dépôt* **AppleSWIFT**.

### 📦 》》 Racine du dépôt
```text
AppleSWIFT/
├── Package.swift
├── README.md
└── Sources/
    └── APP/
```

》》 📝 **Package.swift**
```text
Fichier de configuration Swift Package Manager.  
Déclare le nom du package, les produits, les dépendances (aucune dans cette version), et les cibles.
```

》》 📘 **README.md**
```text
Documentation principale du projet.  
Contient :
- description du mini‑framework,
- fonctionnalités,
- installation via SwiftPM,
- exemples d’utilisation,
- objectif du projet.
```

》》 📂 **Sources**/
- *Dossier standard SwiftPM contenant le code source du package*.
```text
Sources/
└── APP/
    ├── AppleSWIFT.swift
    ├── ModelParser.swift
    └── NumberValidator.swift
```

》》 📁 **APP**/
- Module principal du framework :
```text
🔹 AppleSWIFT.swift
Point d’entrée du mini‑framework.  
Expose les fonctions publiques : validation de numéro, parsing de modèle, formatage minimaliste.

🔹 ModelParser.swift
Analyse les chaînes de type “iPhone 14 Pro”, “Samsung Galaxy S21”, etc.  
Retourne une structure contenant :
- brand
- model

🔹 NumberValidator.swift
Validation très simple de numéros de téléphone (format basique).
```

---

》》 🧪 **Tests**/
- non présent dans la version actuelle
   - Le dépôt ne contient pas encore de dossier *Tests/*.  
   - SwiftPM le créera automatiquement si tu ajoutes des tests unitaires.

---

### 🎯 Résumé clair

| Élément | Présent | Description |
|--------|---------|-------------|
| Package.swift | ✔️ | Configuration SwiftPM |
| README.md | ✔️ | Documentation principale |
| Sources/APP | ✔️ | Code source du framework |
| Tests/ | ❌ | À ajouter si tu veux des tests |
| .github/ | ❌ | Aucun fichier de gouvernance pour l’instant |

---
