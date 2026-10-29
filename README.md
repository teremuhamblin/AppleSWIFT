# 📱 SmartphonesZ
- — Mini‑Projet Ultra Simple

Un micro‑projet Swift (ou concept général), en version super légère, orientée smartphones / infos / parsing basique.

Tu peux l’utiliser comme base pour un futur vrai projet, ou juste comme squelette propre.

---

### 🟩 Mini framework
- — Version initiale

Mini‑framework Swift ultra léger pour analyser, formater et valider des
informations simples liées aux smartphones (numéros, modèles, marques).

### ✨ Fonctionnalités
```text
- 🔢 Validation très simple de numéros de téléphone (format basique).
- 📱 Extraction de marque et modèle à partir d’une chaîne.
- ⚙️ Formatage minimaliste pour affichage propre.
- 🧩 Code clair, court, facile à étendre.
```

### 📦 Installation
- Ajoutez le dépôt GitHub dans votre projet *Swift Package Manager* :
```text
https://github.com/teremuhamblin/SmartphonesZ (github.com in Bing)
```

- Importez le module :
```swift
import SmartphonesZ
```

### 🚀 Usage rapide
```swift
let parser = SmartphonesZ()

let number = parser.validateNumber("+33612345678")
print(number.isValid)

let info = parser.parseModel("Samsung Galaxy S21")
print(info.brand)   // Samsung
print(info.model)   // Galaxy S21
```

### 📚 Objectif du projet
Fournir une base simple, propre et compréhensible pour manipuler des données
liées aux smartphones, sans dépendances externes et avec un code minimaliste.

### 🛠️ Licence
Projet libre, simple, utilisable dans n’importe quel contexte.

---
