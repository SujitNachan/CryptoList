import SwiftUI

struct CoinListView: View {

    @StateObject var viewModel: CoinListViewModel
    @State private var showFilterSheet = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tab picker
                Picker(Strings.CoinList.tabPickerTitle, selection: $viewModel.selectedTab) {
                    ForEach(CoinTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 8)

                // Search bar
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                    .padding(.bottom, 4)

                // Filter chips
                FilterChipsView(filter: $viewModel.filter)
                    .padding(.horizontal)
                    .padding(.bottom, 8)

                // Status label
                if let label = viewModel.lastUpdatedLabel {
                    Text(label)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal)
                        .padding(.bottom, 4)
                }

                Divider()

                // Coin list
                Group {
                    switch viewModel.selectedTab {
                    case .all:
                        CoinScrollList(
                            coins: viewModel.filteredAllCoins,
                            emptyMessage: viewModel.allCoins.isEmpty ? Strings.EmptyState.loadingCoins : Strings.EmptyState.noCoinsMatch,
                            onToggleWatch: { viewModel.toggleWatchlist(for: $0) }
                        )
                    case .watchlist:
                        CoinScrollList(
                            coins: viewModel.filteredWatchlist,
                            emptyMessage: viewModel.watchedCoins.isEmpty
                            ? Strings.EmptyState.emptyWatchlist
                            : Strings.EmptyState.noWatchlistMatch,
                            onToggleWatch: { viewModel.toggleWatchlist(for: $0) }
                        )
                    }
                }
            }
            .navigationTitle(Strings.CoinList.navigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showFilterSheet = true
                    } label: {
                        Label(Strings.CoinList.filterLabel, systemImage: Strings.Icons.filterIcon)
                            .symbolVariant(viewModel.activeFilterCount > 0 ? .fill : .none)
                    }
                    .overlay(alignment: .topTrailing) {
                        if viewModel.activeFilterCount > 0 {
                            Text("\(viewModel.activeFilterCount)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(width: 16, height: 16)
                                .background(.red, in: Circle())
                                .offset(x: 6, y: -6)
                        }
                    }
                }
            }
            .refreshable { await viewModel.refresh() }
            .sheet(isPresented: $showFilterSheet) {
                FilterSheetView(filter: $viewModel.filter)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
            .onAppear { viewModel.onAppear() }
        }
    }
}
