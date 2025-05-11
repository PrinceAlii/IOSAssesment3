//
//  StockRowView.swift
//  SVB-App
//
//  Created by Tomi Nguyen on 11/5/2025.
//

import SwiftUI

struct StockRowView : View {
    
    let stock:Stock
    
    var body: some View {
        HStack {
            VStack(alignment: .leading ) {
                Text(stock.symbol)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(stock.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
            }
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(String(format: "$%.2f",stock.price))
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(String(format: "%.2f%%",stock.changePercentage))
                    .foregroundColor(stock.changePercentage>0 ? .green : .red)
                    .font(.caption)
            }
        }
        .padding()
            }
    }
struct StockRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StockRowView (stock: Stock.sampleStocks[0])
                .previewLayout(.fixed(width: 896, height: 44))
                .padding()
            StockRowView (stock: Stock.sampleStocks[1])
                .previewLayout(.fixed(width: 896, height: 44))
                .padding()
            
                
    }
    }
    
}
