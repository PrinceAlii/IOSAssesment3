SVB/
├── SVBApp.swift
│   // Entry point for SVB; sets up the initial HomeView and injection of environment objects.
│
├── Models/
│   ├── Stock.swift
│   │   // Represents a stock (ticker, name, current price, chart data).
│   │
│   ├── NewsArticle.swift
│   │   // Represents a single news item (headline, source, date, url).
│   │
│   └── Alert.swift
│       // Represents a user-configured alert (stock ticker, condition, threshold).
│
├── ViewModels/
│   ├── HomeViewModel.swift
│   │   // Publishes list of favourite stocks & their latest chart snapshots to HomeView.
│   │
│   ├── StockDetailViewModel.swift
│   │   // Publishes detailed stock info, news list & alert logic to StockDetailView.
│   │
│   └── FavoritesViewModel.swift
│   |   // Manages add/remove of favourites and persists them locally.
|   └── SearchViewModel.swift
│       // Manages the search-bar text, invokes StockService.searchStocks(query:),
│       // and publishes an array of Stocks matching the user’s input.
│
├── Views/
│   ├── HomeView.swift
│   │   // Shows grid/list of favourited stocks with mini-charts and star toggles.
│   │
│   ├── StockRowView.swift
│   │   // Single row in HomeView: shows stock symbol, current price & star icon.
│   │
│   ├── StockDetailView.swift
│   │   // Detailed view: big chart, news feed & “create/edit alert” button.
│   │
│   ├── NewsRowView.swift
│   │   // Single news entry: headline, date & tap-to-open link.
│   │
│   ├── AlertConfigView.swift
│   │   // Form UI for setting a new alert (price above/below, date/time).
|   |
│   ├── SearchView.swift
│   │   // Contains a search bar + List of matching stocks; tap result → StockDetailView
│   │
│   └── Shared/ 
│       ├── LoadingView.swift
│       │   // A simple spinner/placeholder while data’s loading.
│       │
│       └── ErrorView.swift
│           // Displays an error message with retry action.
│
├── Services/
│   ├── StockService.swift
│   │   // Fetches stock quotes & chart data from your chosen API.
│   │
│   ├── NewsService.swift
│   │   // Fetches news articles related to a given ticker symbol.
│   │
│   ├── AlertService.swift
│   │   // Schedules & manages local notifications for price/time alerts.
│   │
│   └── PersistenceService.swift
│       // Reads/writes favourites & alerts (UserDefaults or CoreData).
│
├── Utilities/
│   ├── NetworkManager.swift
│   │   // Generic HTTP client for GET/POST requests & JSON decoding.
│   │
│   └── ImageCache.swift
│       // In-memory cache for any downloaded images.
│
└── Resources/
    ├── Assets.xcassets
    │   // App icons, star-filled & star-empty SF Symbols, placeholder images.
    │
    ├── LaunchScreen.storyboard
    │   // Default launch screen UI.
    │
    └── Info.plist
        // App configuration (permissions, URL schemes, etc.).
