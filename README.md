![SwiftUI](https://img.shields.io/badge/SwiftUI-blue.svg?style=flat)
![Swift5.9](https://img.shields.io/badge/Swift_Version-6.0-blue?logo=swift)
![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)
# Heroes App 📱

**Heros App** is a Swift-based iOS application built using TCA architecture. The app displays a list of Hereos with their details and allows search Heroes by their names.

---

## **Table of Contents**

1. [Introduction](#introduction)
2. [Features](#features)
3. [App Screenshots](#app-screenshots)
4. [How It Works](#how-it-works)  
   - [Main View](#1-main-view)  
   - [Hero Details](#2-hero-details)
5. [Setup & Installation](#setup--installation)
6. [Architecture Overview](#architecture-overview)  
7. [TCA Digram](#tca-digram)
8. [Key Improvements](#key-improvements)
9. [Dependencies](#dependencies)
10. [API Integration](#api-integration)  
    - [Endpoints](#endpoints)
11. [Future Enhancements](#future-enhancements)
12. [Issues](#issues)
13. [Contributing](#contributing)
14. [License](#license)

---

## **Features**
- 📜 **List of Hereos**: Displays a List of all Hereos with their name, Image, and description.
- 🔍 **Search**: Search Hereos by their names.
- 🧍‍♂️ **Hero Details**: View detailed information about a selected hero, including:
  - Name
  - Image
  - Full description
  - Comics
  - Series
  - Stories

## **App Screenshots**

| **Heroes List**  | **Hereos Details**                                                                                                                                                              
|-------------------------------------------------------------|----------------------------------------------------------------------------------------------------
| <img src="https://github.com/user-attachments/assets/05d46ce5-0bed-41d9-a246-d383946bf28c" alt="hero List" width="400" height="500"> | <img src="https://github.com/user-attachments/assets/30b809a7-6908-40e0-b6b9-27a36c918520" alt="hero List" width="400" height="500">  
| Displays a list of all heroes, including their name, species, and status.                       | Shows detailed information about a selected Hero.         | 

---

## **How It Works**

### **1. Main View**
The main screen is a table view displaying all heroes fetched from the API.

- Each row displays:
  - hero's name.
  - hero's image.
  - hero's short description.

### **2. Hero Details**
On selecting a hero from the list, a detail view is shown with the character's:
- Profile image.
- Name.
- Description.
- Comics.
- Series.
- Stories.

---

## **Setup & Installation**

1. **Clone the Repository**  
   ```bash
   git clone https://github.com/knight6700/WallaMarvel
   ```
2. **Install all dependancies with Gem**  
   - Open `Terminal`
   - ```cd project-path```
   - ``` chmod +x onboarding.sh ```
   - ``` \.onboarding.sh```
   - Write private and public keys Api for `Debug` and `Release`

3. **Open in Xcode**  
   - Open the `.xcodeproj`

4. **Install Dependencies**  
   - Resolve Swift Package Manager (SPM) dependencies.

5. **Run the App**  
   - Select a simulator or a connected device.
   - Click the **Run** button or press `⌘R`.

---

## **Architecture Overview**

The app adopts **TCA (The Composable Architecture)** to structure features in a modular, testable, and scalable way, following principles of unidirectional data flow and state management.

---

### **Data Layer**

This layer handles data retrieval and transformation from remote sources.

* **`HeroesDTO`**: Data Transfer Object representing the raw structure returned from the API.
* **`HeroRemoteDataSource`**: Responsible for making API calls to fetch hero data.
* **`HeroMapper`**: Maps `HeroesDTO` to domain-specific models.
* **`Parameters`**: Encapsulates API query parameters.

---

### **Domain Layer**

Encapsulates business logic and defines contracts between the data and presentation layers.

* **Models**:

  * `Hero`: Core domain model representing a hero.
  * `SearchSuggestions`: Holds logic for filtering/searching heroes.
  * `ThumbnailURLBuilder`: Helps build image URLs.
* **Repository**:

  * `HeroRepository`: Acts as the abstraction over the data layer and exposes domain-ready data.
  * **HeroPreFetch**: Contains logic to pre-fetch or cache data for better UX.

---

### **Feature Layer (Presentation)**

Built using TCA's modular architecture to manage state, actions, effects, and reducers.

* **`HeroListFeature`**: Implements the main feature showing the list of heroes. It includes:

  * `State`: Holds UI-relevant data.
  * `Action`: Defines all user and system-driven events.
  * `Reducer`: Handles state mutation based on actions.
  * `Effect`: Handles side effects like API calls or async operations.
* **`HeroCell`**: Represents a reusable UI component for displaying a single hero in the list.

---

## **TCA Digram**
![1_Ob3Ulthtg-C6D-mvGvNfkA](https://github.com/user-attachments/assets/1c7624a8-edfd-42ba-a69f-8db178b815ea)
[for more details](https://github.com/pointfreeco/swift-composable-architecture)

## **Key Improvements**
1. **Grid View or CollectionVieew**: Create a `Grid View` or `CollectionView` to efficiently display resources (e.g., comics).
2. **Encryption Module**: Implement an encryption module using the Arkana library and MD5, or any other suitable encryption technique.

---

## **Dependencies**
- `SwiftUI`: For building the UI.
- `URLSession`: For API communication.
- `Kingfisher`: For image downloading and caching.
- `Snapshot-Testing`: For snapshot views.
- `Netfox`: For debugging network requests.
- `SwiftLintPlugin`:  A tool to enforce Swift style and conventions within your project. 
- `TCA Framework`: A Swift framework for managing state, side effects, and app architecture in a modular and testable way

---

## **API Integration**

The app fetches data from the **Marvel API**.

### **Endpoints**
### 🔗 Marvel API Authentication

To fetch characters from the Marvel API, use the following URL format:

```
https://gateway.marvel.com/v1/public/characters?limit={Int}&offset={Int}&ts={Int}&apikey={String}&hash={String}
```

#### 🧩 Required Parameters

| Parameter        | Description                                                                                                                             |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `limit`          | Number of results to return.                                                                                                            |
| `offset`         | Pagination offset.                                                                                                                      |
| `ts` (timestamp) | A unique timestamp. Usually the current time in seconds:<br>`String(Int(Date().timeIntervalSince1970))`                                 |
| `apikey`         | Your **public** API key from [Marvel Developer Portal](https://developer.marvel.com).                                                   |
| `hash`           | An MD5 hash of: <br>`timestamp + privateKey + publicKey`<br>For example:<br>`"\(timestamp)\(privateKey)\(publicKey)"` hashed using MD5. |
| `privateKey`     | Your **private** API key (keep this secret). Available after registering on Marvel Developer Portal.                                    |
| `name` (Optional)     | Name of the hero you want to search for.                                    |

#### 🔐 Hash Generation (Swift Example)

```swift
let timestamp = String(Int(Date().timeIntervalSince1970))
let input = "\(timestamp)\(privateKey)\(publicKey)"
let hash = input.md5() // Use an MD5 hashing function
```

> ✅ The `hash` is required for authenticating API requests and must be computed for every call.
1. **Fetch All Characters**  
   - URL: `https://gateway.marvel.com/v1/public/characters?limit={Int}&offset={Int}&ts={Int}&apikey={String}&hash={String}`
2. **Character Search**  
   - URL: `https://gateway.marvel.com/v1/public/characters?limit={Int}&offset={Int}&ts={Int}&apikey={String}&hash={String}&name={String}`
3. **Fetch Resources**  
   - URL: `https://gateway.marvel.com/v1/public/characters/{character_Id}/{resourceType}?limit={Int}&offset={Int}&ts={Int}&apikey={String}&hash={String}`
   - Resource Type:  `comics`, `series`, or `stories`.  

---

## **Future Enhancements**
- 🌎 **Connectivity Check**: Show a "No Internet" alert automatically when the device is offline.
- 🔥 **Caching**: Implement API caching using an appropriate technique to improve performance and reduce network usage.
- 📊 **Statistics**: Display stats for the number of alive, dead, and unknown characters.

---
## **Issues**
- [Duplicated Id](https://github.com/knight6700/WallaMarvel/issues/6):
 The API was returning duplicate heroes with the same ID, so we resolved it by using a unique id (generated with UUID().uuidString) alongside the original heroId (Int) from the API.
---

## **Contributing**

Contributions are welcome! Follow these steps to contribute:
1. Fork the repository.
2. Create a feature branch:  
   ```bash
   git checkout -b feature-branch
   ```
3. Commit your changes:  
   ```bash
   git commit -m "Add new feature"
   ```
4. Push to the branch:  
   ```bash
   git push origin feature-branch
   ```
5. Create a pull request.

---

## **License**

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for more details.
---
