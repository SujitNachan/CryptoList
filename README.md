🪙 Crypto Watchlist 

A scalable, production-grade iOS application built with SwiftUI that allows users to browse, search, and filter cryptocurrency coins. The app features an offline-first persistence layer, ensuring a seamless user experience regardless of network connectivity.  

🏗 Architecture Overview

The project follows Clean Architecture principles combined with MVVM, ensuring high testability and a strict separation of concerns.  

The 5-Layer Flow:

View (SwiftUI): Declarative UI components that observe the ViewModel.  

ViewModel: Manages UI state, handles search/filter logic, and coordinates with UseCases.  

UseCase: Contains the business logic (e.g., "Get filtered coins").  

Repository: The "Single Source of Truth." It decides whether to serve data from the local cache or the remote API.  

Data Sources:

API Client: Handles networking using URLSession.  

Database Service: Handles persistence using SwiftData (or local storage).  

🚀 Key Features
1. Crypto Coins List
Displays comprehensive coin data including Name, Symbol, and Type.  

Dynamic State Handling: Inactive coins (is_active = false) appear visually disabled with reduced opacity and are non-interactive.  

2. Advanced Search & Filtering
Real-time Search: Case-insensitive filtering by Name or Symbol as you type.  

Multi-select Filters: Combined filtering support for:

Active Status: Toggle between Active and Inactive coins.  

Coin Type: Filter by "Coin", "Token", etc.  

New Coins: Quickly identify newly listed coins (is_new = true).  

3. Offline-First Watchlist
Instant Load: On cold start, the app displays cached data immediately, eliminating blocking loading spinners.  

Background Sync: Data refreshes from the network in the background once the UI is visible.  

Persistence: Watch/Unwatch actions persist across app launches and process terminations.  

Optimistic UI: Star icons update instantly when tapped, with synchronization occurring across both the "All Coins" and "Watchlist" views without manual refreshes.  

🛠 Technical Specifications
UI Framework: SwiftUI.  

Concurrency: Swift Concurrency (async/await).  

Persistence: SwiftData / LocalStorage for offline-first capabilities.  

Theming: Centralized design system using AppConstants for consistent padding, spacing, and animations.  

Dependency Management: Zero heavy third-party dependencies to keep the binary lightweight and maintainable.  

<img width="725" height="457" alt="Screenshot 2026-05-01 at 7 48 24 PM" src="https://github.com/user-attachments/assets/51fd3557-bb78-488c-a1b2-40aae537283e" />


📝 Setup & Installation
Clone the repository: git clone git@github.com:username/CryptoWatchlist.git.  

Open CryptoCoins.xcodeproj in Xcode 15+.

Ensure your target is set to an iPhone simulator or device.

Build and Run (Cmd + R).

📡 API Endpoint

Data is fetched from the following endpoint:

[https://api.jsonbin.io/v3/b/69f046e8856a6821897f1741](https://api.jsonbin.io/v3/b/69f046e8856a6821897f1741)



<img width="350" height="750" alt="Simulator Screenshot - iPhone 16 Pro - 2026-05-01 at 19 51 26" src="https://github.com/user-attachments/assets/05ad2396-4666-4152-b9e6-124d0dc6320d" />
