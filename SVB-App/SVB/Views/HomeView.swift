import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @EnvironmentObject private var favouriteViewModel: FavouriteViewModel
    @StateObject private var searchViewModel = SearchViewModel()
    @State private var selectedTab: Int = 0
    
    
    var body: some View {
        
        NavigationView {
            VStack(spacing:0){
                HStack{
                    Image(systemName:"manifyingglass")
                        .foregroundColor(.gray)
                    //uhhh gotta add search func in here dk how
                    TextField("Search", text : $searchViewModel.searchText, onCommit: {
                        Task {
                            searchViewModel.performSearch()
                        }
                    })
                    .textFieldStyle(.plain)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.top)
                //search
                
                
                VStack(alignment: .leading, spacing:10) {
                    Text("Favourites")
                        .font(.title)
                        .bold()
                        .padding(.horizontal)
                }
                
                if !homeViewModel.favouriteStocks.isEmpty {
                    ForEach(homeViewModel.favouriteStocks) {stock in
                        HStack{
                            StocksRowView(stock: stock)
                            Spacer()
                            Button(action: {
                                favouriteViewModel.toggleFavourite(ticker: stock.ticker)
                            }) {
                                Image(systemName:"star.fill")
                                    .foregroundColor(.yellow)
                            }
                        }
                        .padding(.horizontal)
                    }
                } else {
                    Text("No Favourites Added")
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
            }
            .padding(.top,5)
            
        }
    }
    
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
                .environmentObject(FavouriteViewModel())
                .environmentObject(SearchViewModel())
                .previewDevice("iPhone 16 Pro")
        }
    }
    
}
