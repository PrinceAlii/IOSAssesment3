import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var favouriteViewModel: FavouriteViewModel
    @State private var selectedTab: Int = 0

    init(favouriteViewModel: FavouriteViewModel) {
        _homeViewModel = StateObject(wrappedValue: HomeViewModel(favouriteViewModel: favouriteViewModel))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom Search Bar Area
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search", text: $homeViewModel.searchText, onCommit: {
                        homeViewModel.initiateSearch()
                    })
                        .textFieldStyle(.plain)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top)

                // Main Content List
                List {
                    // Favourites Section
                    Section("Favourites") {
                        // Use the @ViewBuilder computed property
                        favouritesSectionContent
                    }

                    // Latest News Section
                    Section("Latest News") {
                        // Use the @ViewBuilder computed property
                        latestNewsSectionContent
                    }
                }
                .listStyle(.insetGrouped)
                .refreshable {
                    await homeViewModel.fetchHomeData()
                }

                // Custom Tab Bar Area (Placeholder)
                Divider()
                HStack {
                    TabBarButton(iconName: "house.fill", text: "Home", isSelected: selectedTab == 0) {
                        selectedTab = 0
                    }
                    Spacer()
                    TabBarButton(iconName: "list.star", text: "Watchlist", isSelected: selectedTab == 1) {
                        selectedTab = 1
                        print("Watchlist tab tapped - Functionality not implemented")
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 8)
                .padding(.bottom, (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets.bottom ?? 0)

            } // End Main VStack
            .navigationTitle("Home")
            .navigationBarHidden(true)
            .onAppear {
                if homeViewModel.favouriteStocks.isEmpty && homeViewModel.newsArticles.isEmpty {
                     Task {
                         await homeViewModel.fetchHomeData()
                     }
                }
            }
        } // End NavigationView
        .navigationViewStyle(.stack)
    }

    // MARK: - ViewBuilder Computed Properties

    /// Provides the content for the Favourites section using @ViewBuilder.
    @ViewBuilder
    private var favouritesSectionContent: some View {
        if homeViewModel.isLoadingFavourites {
            ProgressView()
                .frame(maxWidth: .infinity, alignment: .center)
        } else if homeViewModel.favouriteStocks.isEmpty {
            Text("No favourites added yet. Tap the star on a stock to add it.")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
        } else {
            ForEach(homeViewModel.favouriteStocks) { stock in
                StockRowView(viewModel: StockRowViewModel(
                    stock: stock,
                    isFavourite: favouriteViewModel.isFavourite(ticker: stock.ticker), favouriteActionHandler: favouriteViewModel as! FavouriteActionHandling
                ))
            }
        }
    }

    /// Provides the content for the Latest News section using @ViewBuilder.
    @ViewBuilder
    private var latestNewsSectionContent: some View {
        if homeViewModel.isLoadingNews {
            ProgressView()
                .frame(maxWidth: .infinity, alignment: .center)
        } else if let errorMessage = homeViewModel.errorMessage, !errorMessage.isEmpty {
            Text("Error: \(errorMessage)")
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .center)
        } else if homeViewModel.newsArticles.isEmpty {
            Text("No news available.")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
        } else {
            ForEach(homeViewModel.newsArticles) { article in
                NewsArticleRowSimple(article: article)
            }
        }
    }
}

struct NewsArticleRowSimple: View {
    let article: NewsArticle

    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 60)
            VStack(alignment: .leading) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(article.publishedUTC)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct TabBarButton: View {
    let iconName: String
    let text: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: iconName)
                    .font(.title2)
                Text(text)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .blue : .gray)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview Provider

struct HomeView_Previews: PreviewProvider {
    @StateObject static var previewFavouriteViewModel = FavouriteViewModel()

    static var previews: some View {
        HomeView(favouriteViewModel: previewFavouriteViewModel)
            .environmentObject(previewFavouriteViewModel)
    }
}
