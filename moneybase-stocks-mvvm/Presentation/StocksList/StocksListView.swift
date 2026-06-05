//
//  StocksListView.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 04/06/2026.
//

import SwiftUI

struct StocksListView: View {
    @StateObject private var viewModel: StocksListViewModel
    private let onSelectStock: (String) -> Void

    init(
        viewModel: StocksListViewModel,
        onSelectStock: @escaping (String) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onSelectStock = onSelectStock
    }

    var body: some View {
        Group {
            if viewModel.filteredStocks.isEmpty {
                noStockView
            } else if let errorMessage = viewModel.errorMessage,
                        viewModel.stocks.isEmpty {
                errorView(errorMessage)
            } else {
                loadedView
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
    
    @ViewBuilder
    private var noStockView: some View {
        if viewModel.isLoading {
            ProgressView("Loading stocks...")
        } else {
            ContentUnavailableView(
                "No stock with selected criteria",
                systemImage: "wifi.exclamationmark"
            )
        }
    }
    
    private var loadedView: some View {
        List(viewModel.filteredStocks) { stock in
            Button {
                onSelectStock(stock.symbol)
            } label: {
                StockRowView(stock: stock)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .listStyle(.plain)
    }
    
    private func errorView(_ errorMessage: String) -> some View {
        ContentUnavailableView(
            "Failed to load stocks",
            systemImage: "wifi.exclamationmark",
            description: Text(errorMessage)
        )
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 4)
    }
}

#Preview {
    let previewContainer = AppDIContainer(repository: MockStocksRepository())

    StocksListView(
        viewModel: previewContainer.makeStocksListViewModel(shouldAutoRefresh: false),
        onSelectStock: { _ in }
    )
}
