# PhotoGallery iOS App

A modern iOS application that fetches photos from a REST API, displays them in a paginated list, persists data using Core Data, and provides full CRUD operations (edit titles and delete records). Built with **SwiftUI** and following the **MVVM** architecture pattern.

---

## 📱 Features

- ✅ **Fetch Photos** from JSONPlaceholder REST API
- ✅ **Paginated Loading** — loads 50 items at a time for smooth performance with 5000+ records
- ✅ **Image Caching** — custom `ImageCache` using `NSCache` to avoid re-downloading on scroll
- ✅ **Core Data Persistence** — local storage with no duplicates on re-fetch
- ✅ **Offline-First** — loads from Core Data first; falls back to API only when empty
- ✅ **Edit Title** — tap a photo to open a detail screen, edit, and save
- ✅ **Swipe-to-Delete** — with confirmation alert
- ✅ **Detail Screen Delete** — alternative delete via the detail view
- ✅ **Empty State View** — shown when no records exist
- ✅ **Loading Indicators** — during fetch and pagination
- ✅ **Error Handling** — graceful Core Data error messages

---

## 🏗️ Architecture

The project follows the **MVVM (Model-View-ViewModel)** architecture with a **Repository Pattern** for clean separation of concerns.

```
┌─────────────────────────────────────────────────┐
│                   Views (SwiftUI)               │
│  PhotoListView, PhotoDetailView, PhotoRowView   │
└────────────────────┬────────────────────────────┘
                     │ @StateObject / @ObservedObject
┌────────────────────▼────────────────────────────┐
│              ViewModels                          │
│           PhotoListViewModel                     │
└────────────────────┬────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────┐
│              Repository                          │
│           PhotoRepository                        │
└────────────┬─────────────────────┬───────────────┘
             │                     │
┌────────────▼────────┐  ┌─────────▼──────────────┐
│    APIService       │  │   CoreDataManager     │
│   (URLSession)      │  │     (Core Data)       │
└─────────────────────┘  └───────────────────────┘
```

### Layer Responsibilities

| Layer | Responsibility |
|-------|---------------|
| **Views** | UI rendering, user input handling, navigation |
| **ViewModels** | Business logic, state management, data transformation |
| **Repository** | Single source of truth; orchestrates API + Core Data |
| **APIService** | Network calls using `URLSession` |
| **CoreDataManager** | Core Data stack and CRUD operations |
| **ImageCache** | In-memory image caching via `NSCache` |

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| **Language** | Swift 5+ |
| **Minimum iOS** | iOS 15.0 |
| **UI Framework** | SwiftUI |
| **Architecture** | MVVM + Repository Pattern |
| **Networking** | URLSession (no third-party) |
| **Persistence** | Core Data |
| **Image Caching** | NSCache (custom implementation) |
| **Dependency Manager** | None (no third-party libs) |
| **Version Control** | Git |

---

## 📂 Project Structure

```
PhotoGallery/
├── App/
│   ├── Persistence/          # Core Data stack configuration
│   │   └── PersistenceController.swift
│   └── PhotoGalleryApp/      # App entry point (@main)
│       └── PhotoGalleryApp.swift
│
├── CoreData/
│   └── CoreDataManager/      # Core Data CRUD operations
│       └── CoreDataManager.swift
│
├── Helpers/
│   └── ImageCache/           # NSCache-based image caching
│       └── ImageCache.swift
│
├── Models/
│   └── PhotoDTO/             # Data Transfer Object for API decoding
│       └── PhotoDTO.swift
│
├── Networking/
│   └── APIService/           # URLSession-based API client
│       └── APIService.swift
│
├── Repository/
│   └── PhotoRepository/      # Combines API + Core Data logic
│       └── PhotoRepository.swift
│
├── Utilities/
│   ├── CachedAsyncImage/     # SwiftUI view with built-in caching
│   ├── GrowingTextEditor/    # Multi-line growing text field
│   └── ToastView/            # Custom toast notifications
│
├── ViewModels/
│   └── PhotoListViewModel/   # State + business logic
│       └── PhotoListViewModel.swift
│
├── Views/
│   ├── EmptyStateView/       # Shown when no photos exist
│   ├── PhotoDetailView/      # Detail + edit screen
│   ├── PhotoListView/        # Main list view
│   └── PhotoRowView/         # Single row in the list
│
├── Assets.xcassets           # Images, app icons
├── Info.plist                # App configuration
└── PhotoGallery.xcdatamodeld # Core Data model
```

---

## 🚀 Setup Instructions

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/krunalRupyz/PhotoGallery.git
   cd PhotoGallery
   ```

2. **Open in Xcode**
   ```bash
   open PhotoGallery.xcodeproj
   ```

3. **Select a target device/simulator**
   - Choose any iPhone simulator running iOS 15.0+

4. **Build and Run**
   - Press `⌘ + R` or click the **Run** button

5. **(Optional) Reset Core Data**
   - Delete and reinstall the app to clear all persisted data.

> **Note:** No external dependencies are used. No `pod install` or `swift package resolve` is required.

---

## 🔌 API Reference

**Endpoint:** `https://jsonplaceholder.typicode.com/photos`

**Method:** `GET`

**Response:** Array of 5000 photo objects

**Sample Object:**
```json
{
  "albumId": 1,
  "id": 1,
  "title": "accusamus beatae ad facilis cum similique qui sunt",
  "url": "https://via.placeholder.com/600/92c952",
  "thumbnailUrl": "https://via.placeholder.com/150/92c952"
}
```

---

## 💾 Core Data Model

**Entity:** `Photo`

| Attribute    | Type    | Description                          |
|--------------|---------|--------------------------------------|
| `id`         | Int64   | Unique photo ID (Primary Key)        |
| `albumId`    | Int64   | Album ID                             |
| `title`      | String  | Photo title                          |
| `url`        | String  | Full-size image URL                  |
| `thumbnailUrl` | String | Thumbnail image URL                  |

**Duplicate Prevention:** On every fetch, existing `id`s are checked before insert.

---

## 🖼️ Screenshots

> Add screenshots of your running app here. Recommended shots:
> - Photo list with thumbnails
> - Detail/Edit screen
> - Swipe-to-delete action
> - Empty state view
> - Loading state

| List View | Detail View | Edit Mode |
|-----------|-------------|-----------|
| *(add screenshot)* | *(add screenshot)* | *(add screenshot)* |

---

1. first time installing the application

https://github.com/user-attachments/assets/44ce20d9-4b46-42a6-9dbf-07c4654c40bb

2. After the user can kill the app and load data from the coredata

https://github.com/user-attachments/assets/78a18114-13d3-42a0-92b1-1add75a56ac2


## 🔄 Data Flow

1. **App Launch**
   - `PhotoRepository` checks Core Data first
   - If empty → calls `APIService.fetchPhotos()` → saves to Core Data → returns data
   - If non-empty → returns Core Data records

2. **Pagination (Load More)**
   - User scrolls near the bottom
   - `onAppear` of last row triggers `loadMore()`
   - Fetches next batch of 50 from API → saves to Core Data → appends to list

3. **Edit Title**
   - User taps row → `PhotoDetailView` opens
   - Edits title → taps **Save** → updates Core Data → updates list immediately

4. **Delete**
   - User swipes left → confirms in alert → deletes from Core Data → removes from list

---


