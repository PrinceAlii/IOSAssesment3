//
//  AlertConfigView.swift
//  SVB-App
//
//  Created by Savya Rai on 10/5/2025.
//

import SwiftUI
import SwiftData

struct AlertConfigView: View {
    let ticker: String
    let companyName: String?
    @StateObject private var viewModel: AlertViewModel

    init(ticker: String, companyName: String?, context: ModelContext) {
        self.ticker = ticker
        self.companyName = companyName
        _viewModel = StateObject(
            wrappedValue: AlertViewModel(ticker: ticker, context: context)
        )
    }

    var body: some View {
        VStack(alignment: .leading) {
            // Input section
            Text("Set Target Price")
                .font(.headline)
                .padding(.horizontal)

            HStack {
                TextField("Target Price", text: $viewModel.targetPriceString)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                Button("Confirm") {
                    viewModel.addAlert()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)

            Divider()
                .padding(.vertical, 8)

            // Existing alerts
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.alerts) { alert in
                        HStack {
                            Text("Alert when price ≥ \(String(format: "%.2f", alert.targetPrice))")
                            Spacer()
                            Button(role: .destructive) {
                                viewModel.deleteAlert(alert)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                        .padding(.horizontal)
                        Divider()
                    }
                }
            }
        }
    }
}

struct AlertConfigView_Previews: PreviewProvider {
    static var previewContainer: ModelContainer = {
        let schema = Schema([Alert.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        do {
            let container = try ModelContainer(for: schema, configurations: [config])
            let ctx = container.mainContext
            // Sample data for the preview.
            ctx.insert(Alert(ticker: "AAPL", targetPrice: 150.00))
            ctx.insert(Alert(ticker: "AAPL", targetPrice: 155.00))
            try ctx.save()
            return container
        } catch {
            fatalError("Could not create container: \(error)")
        }
    }()

    static var previews: some View {
        AlertConfigView(
            ticker: "AAPL",
            companyName: "Apple Inc.",
            context: previewContainer.mainContext
        )
        .modelContainer(previewContainer)
        .previewDevice("iPhone 16 Pro Max")
    }
}
