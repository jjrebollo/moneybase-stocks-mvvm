//
//  StocksListView.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 04/06/2026.
//

import SwiftUI

struct StocksListView: View {
    @StateObject private var viewModel: StocksListViewModel
    private let onSelectStock: (String, String) -> Void

    init(
        viewModel: StocksListViewModel,
        onSelectStock: @escaping (String, String) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onSelectStock = onSelectStock
    }

    var body: some View {
        Group {
            
            if let errorMessage = viewModel.errorMessage,
                      viewModel.stocks.isEmpty {
                errorView(errorMessage)
            } else if viewModel.filteredStocks.isEmpty {
                noStockView
            } else {
                loadedView
            }
        }
        .navigationTitle("Stocks")
        .searchable(text: $viewModel.searchText, prompt: "Search by name or symbol")
        .refreshable {
            await viewModel.refresh()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.showRefreshAvailableCTA {
                    Button("Refresh") {
                        Task { await viewModel.refreshFromCTA() }
                    }
                }
            }
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
        ScrollViewReader { proxy in
            List {
                ForEach(Array(viewModel.filteredStocks.enumerated()), id: \.element.id) { index, stock in
                    Button {
                        onSelectStock(stock.symbol, stock.name)
                    } label: {
                        StockRowView(stock: stock)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                    .id(index)
                    .buttonStyle(.plain)
                    .onAppear {
                        let isFirst = stock.id == viewModel.filteredStocks.first?.id
                        viewModel.setUserAtTop(isFirst)

                        Task {
                            await viewModel.loadNextPageIfNeeded(currentItem: stock)
                        }
                    }
                }

                if viewModel.isLoadingNextPage {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .onChange(of: viewModel.scrollToTopTrigger) {
                withAnimation {
                    proxy.scrollTo(0, anchor: .top)
                }
            }
        }
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

#if DEBUG
#Preview {
    let previewContainer = AppDIContainer(repository: PreviewStocksRepository())

    StocksListView(
        viewModel: previewContainer.makeStocksListViewModel(shouldAutoRefresh: false),
        onSelectStock: { _, _ in }
    )
}
#endif
