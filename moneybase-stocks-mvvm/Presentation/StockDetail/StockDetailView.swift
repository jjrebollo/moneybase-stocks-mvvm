import SwiftUI

struct StockDetailView: View {
    @StateObject private var viewModel: StockDetailViewModel

    init(viewModel: StockDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.profile == nil {
                ProgressView("Loading details...")
            } else if let errorMessage = viewModel.errorMessage, viewModel.profile == nil {
                ContentUnavailableView(
                    "Failed to load details",
                    systemImage: "exclamationmark.triangle",
                    description: Text(errorMessage)
                )
            } else if let profile = viewModel.profile {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Group {
                            Text(profile.companyName)
                                .font(.title2.bold())
                            Text(profile.symbol)
                                .font(.headline)
                                .foregroundStyle(.secondary)
                        }

                        Group {
                            DetailRow(title: "Sector", value: profile.sector)
                            DetailRow(title: "Industry", value: profile.industry)
                            DetailRow(title: "Employees", value: "\(profile.fullTimeEmployees)")
                            DetailRow(title: "Website", value: profile.website)
                        }

                        Text("Business Summary")
                            .font(.headline)
                        Text(profile.summary)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(viewModel.symbol)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadIfNeeded()
        }
    }
}

private struct DetailRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.subheadline.weight(.semibold))
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    StockDetailView(
        viewModel: AppDIContainer().makeStockDetailViewModel(symbol: "AAPL")
    )
}
