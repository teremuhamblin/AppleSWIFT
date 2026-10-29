# 📱 AppleSWIFT
- — Mini‑Projet Ultra Simple

*Un micro‑projet Swift* (ou concept général), en version super légère, orientée *iPhone/ infos / parsing basique*.

Tu peux l’utiliser comme base pour un futur vrai projet, ou juste comme squelette propre.

---

### 🟩 Mini framework
- — Version initiale

*Mini‑framework Swift ultra* léger pour *analyser, formater et valider des
informations simples liées aux iPhones* (numéros, modèles, marques).

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
》》 https://github.com/teremuhamblin/AppleSWIFT
- github.com in Bing
```

- Importez le module :
```swift
import AppleSWIFT
```

### 🚀 Usage rapide
```swift
let parser = AppleSWIFT()

let number = parser.validateNumber("+33612345678")
print(number.isValid)

let info = parser.parseModel("iPhone 14 Pro")
print(info.brand)   // iPhone
print(info.model)   // 14 Pro
```

### 📚 Objectif du projet
Fournir une base simple, propre et compréhensible pour manipuler des données
liées aux iPhone, sans dépendances externes et avec un code minimaliste.

### 🛠️ Licence
Projet libre, simple, utilisable dans n’importe quel contexte.

---
