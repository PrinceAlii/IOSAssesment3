PERSON 1
SVBApp.swift
Models/
 └── Stock.swift
ViewModels/
 ├── HomeViewModel.swift
 └── FavoritesViewModel.swift
Views/
 ├── HomeView.swift
 └── StockRowView.swift
Services/
 └── PersistenceService.swift   // save/load favourites


PERSON 2
Models/
 └── Stock.swift                 // same model for search results
ViewModels/
 └── SearchViewModel.swift
Views/
 └── SearchView.swift
Services/
 └── StockService.swift          // implement func searchStocks(query:)
Utilities/
 └── NetworkManager.swift        // generic HTTP + JSON decoding


PERSON 3
Models/
 └── NewsArticle.swift
ViewModels/
 └── StockDetailViewModel.swift
Views/
 ├── StockDetailView.swift
 └── NewsRowView.swift
Services/
 ├── StockService.swift          // add fetchChartData(ticker:)
 └── NewsService.swift           // fetch articles for a ticker


PERSON 4
Models/
 └── Alert.swift
ViewModels/
 └── (incorporate alert logic into StockDetailViewModel or create AlertViewModel.swift)
Views/
 └── AlertConfigView.swift
Services/
 ├── AlertService.swift          // schedule local notifications
 └── PersistenceService.swift    // save/load alerts
Views/Shared/
 ├── LoadingView.swift
 └── ErrorView.swift
Utilities/
 └── ImageCache.swift
