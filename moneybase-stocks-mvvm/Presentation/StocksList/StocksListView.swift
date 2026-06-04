//
//  StocksListView.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 04/06/2026.
//

import SwiftUI

struct StocksListView: View {
    @StateObject private var viewModel: StocksListViewModel
    private let makeStockDetailViewModel: (String) -> StockDetailViewModel

    init(
        viewModel: StocksListViewModel,
        makeStockDetailViewModel: @escaping (String) -> StockDetailViewModel
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.makeStockDetailViewModel = makeStockDetailViewModel
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.stocks.isEmpty {
                    ProgressView("Loading stocks...")
                } else if let errorMessage = viewModel.errorMessage, viewModel.stocks.isEmpty {
                    ContentUnavailableView(
                        "Failed to load stocks",
                        systemImage: "wifi.exclamationmark",
                        description: Text(errorMessage)
                    )
                } else {
                    List(viewModel.filteredStocks) { stock in
                        NavigationLink {
                            StockDetailView(viewModel: makeStockDetailViewModel(stock.symbol))
                        } label: {
                            StockRowView(stock: stock)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Stocks")
            .searchable(text: $viewModel.searchText, prompt: "Search by name or symbol")
            .refreshable {
                await viewModel.refresh()
            }
            .task {
                await viewModel.onAppear()
            }
            .onDisappear {
                viewModel.onDisappear()
            }
        }
    }
}

private struct StockRowView: View {
    let stock: StockQuote

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(stock.symbol)
                    .font(.headline)
                Text(stock.name)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(stock.lastPriceText)
                    .font(.headline)
                Text(stock.percentChangeText)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(stock.isPositiveChange ? .green : .red)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let container = AppDIContainer()

    StocksListView(
        viewModel: container.makeStocksListViewModel(),
        makeStockDetailViewModel: container.makeStockDetailViewModel(symbol:)
    )
}
