import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @EnvironmentObject private var favouriteViewModel: FavouriteViewModel
    @State private var selectedTab: Int = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                NavigationLink(destination: SearchView()){
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        Text("Search for stocks")
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top)
                }
                
                ScrollView {
                    VStack(spacing: 0) {
                        HStack {
                            Text("Favourites")
                                .font(.title2)
                                .bold()
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        .padding(.bottom, 5)

                        if homeViewModel.isLoadingFavourites {
                            ProgressView("Loading Favourites...")
                                .padding()
                                .frame(maxWidth: .infinity, minHeight: 100)
                        } else if let errorMessage = homeViewModel.favouritesErrorMessage {
                            VStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                    .font(.title)
                                Text(errorMessage)
                                    .foregroundColor(.secondary)
                                    .font(.callout)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                Button("Retry") {
                                    Task {
                                        await homeViewModel.fetchFavouriteStockDetails(favouriteTickers: favouriteViewModel.getFavouriteTickers())
                                    }
                                }
                                .buttonStyle(.bordered)
                                .padding(.top, 5)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 100)
                        } else if homeViewModel.favouriteStocks.isEmpty {
                            Text("No favourites added yet.\nSearch for a stock and tap the star to add it to your watchlist.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(maxWidth: .infinity, minHeight: 100)
                        } else {
                            List {
                                ForEach(homeViewModel.favouriteStocks) { stock in
                                    FavouriteStockRowView(stock: stock)
                                }
                            }
                            .listStyle(.plain)
                            .frame(minHeight: 70, maxHeight: 250)
                        }
                        
                        Divider()
                            .padding(.vertical, 10)

                        HStack {
                             Text("Latest News")
                                .font(.title2)
                                .bold()
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                        
                        if homeViewModel.isLoadingNews {
                            ProgressView("Loading News...")
                                .padding()
                                .frame(maxWidth: .infinity, minHeight: 100)
                        } else if let errorMessage = homeViewModel.newsErrorMessage {
                            VStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                    .font(.title)
                                Text(errorMessage)
                                    .foregroundColor(.secondary)
                                    .font(.callout)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                Button("Retry News") {
                                    Task {
                                        let tickerForNews = homeViewModel.favouriteStocks.first?.ticker ?? "SPY"
                                        await homeViewModel.fetchLatestNews(ticker: tickerForNews)
                                    }
                                }
                                .buttonStyle(.bordered)
                                .padding(.top, 5)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 100)
                        } else if homeViewModel.latestNews.isEmpty {
                            Text("No news available at the moment.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(maxWidth: .infinity, minHeight: 100)
                        } else {
                            VStack(spacing: 0) {
                                ForEach(homeViewModel.latestNews) { article in
                                    NewsRowView(article: article)
                                    Divider().padding(.horizontal)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom)
                }

                Spacer()

                Divider()
                   .padding(.top, 5)

                HStack {
                    TabBarButton(iconName: "house.fill", text: "Home", isSelect: selectedTab == 0) {
                        selectedTab = 0
                    }
                    Spacer()
                    TabBarButton(iconName: "star.fill", text: "Watchlist", isSelect: selectedTab == 1) {
                        selectedTab = 1
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .first?.windows.first?.safeAreaInsets.bottom == 0 ? 10 : 0)
                .padding(.top, 10)
                .background(Color(.systemGray6).edgesIgnoringSafeArea(.bottom))
            }
            .navigationTitle("Home")
            .navigationBarHidden(true)
            .onAppear {
                let favTickers = favouriteViewModel.getFavouriteTickers()
                 print("[HomeView onAppear] Tickers from FavouriteViewModel: \(favTickers)")
                Task {
                    await homeViewModel.fetchFavouriteStockDetails(favouriteTickers: favTickers)
                    
                    var tickerForNews: String
                    if let firstFavTicker = favTickers.first {
                        tickerForNews = firstFavTicker
                    } else {
                        tickerForNews = "SPY"
                    }
                    print("[HomeView onAppear] Fetching news for: \(tickerForNews)")
                    await homeViewModel.fetchLatestNews(ticker: tickerForNews)
                }
            }
            .onChange(of: favouriteViewModel.favouriteTickers) { oldTickers, newTickers in
                 print("[HomeView onChange] Favourite tickers changed.")
                 print("[HomeView onChange] Old tickers: \(oldTickers)")
                print("[HomeView onChange] New tickers: \(newTickers)")

                let addedTickers = newTickers.subtracting(oldTickers)
                let removedTickers = oldTickers.subtracting(newTickers)

                if !addedTickers.isEmpty {
                     print("[HomeView onChange] Tickers were ADDED. Re-fetching details for all favourites.")
                    Task {
                        await homeViewModel.fetchFavouriteStockDetails(favouriteTickers: Array(newTickers))
                        var tickerForNewsUpdate: String
                        if let firstFavTicker = newTickers.first {
                            tickerForNewsUpdate = firstFavTicker
                        } else {
                            tickerForNewsUpdate = "SPY"
                        }
                        await homeViewModel.fetchLatestNews(ticker: tickerForNewsUpdate)
                    }
                } else if !removedTickers.isEmpty {
                    
                     Task {
                        var tickerForNewsUpdate: String
                        if let firstFavTicker = newTickers.first {
                            tickerForNewsUpdate = firstFavTicker
                        } else {
                            tickerForNewsUpdate = "SPY"
                        }
                        await homeViewModel.fetchLatestNews(ticker: tickerForNewsUpdate)
                     }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let favouriteVM = FavouriteViewModel()
        favouriteVM.toggleFavourite(ticker: "AAPL")
        favouriteVM.toggleFavourite(ticker:"MSFT")
        
        let homeVM = HomeViewModel()

        return HomeView()
            .environmentObject(favouriteVM)
            .environmentObject(homeVM)
            .previewDevice("iPhone 15 Pro")
    }
}
