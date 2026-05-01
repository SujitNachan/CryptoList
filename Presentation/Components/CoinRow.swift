import SwiftUI

struct CoinRow: View {

    let coin: Coin
    let onToggleWatch: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            CoinIcon(type: coin.type, symbol: coin.symbol)

            // Name + symbol
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(coin.name)
                        .font(.body)
                        .fontWeight(.semibold)
                    if coin.isNew {
                        NewBadge()
                    }
                }
                Text(coin.symbol)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Type tag
            TypeTag(type: coin.type)

            // Watchlist star
            Button(action: onToggleWatch) {
                Image(systemName: coin.isWatched ? Strings.Icons.watchedStar : Strings.Icons.unwatchedStar)
                    .foregroundStyle(coin.isWatched ? .yellow : .secondary)
                    .font(.system(size: 20))
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .contentShape(Rectangle())
        .opacity(coin.isActive ? 1 : 0.4)
        .allowsHitTesting(coin.isActive)
    }
}

// MARK: - Coin Icon

struct CoinIcon: View {
    let type: CoinType
    let symbol: String

    private var background: Color {
        switch type {
        case .coin:  return Color.orange
        case .token: return Color(red: 0.2, green: 0.6, blue: 0.2)
        }
    }

    private var iconName: String {
        switch type {
        case .coin:  return Strings.Icons.coinIcon
        case .token: return Strings.Icons.tokenIcon
        }
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(background)
                .frame(width: 40, height: 40)
            Image(systemName: iconName)
                .foregroundStyle(.white)
                .font(.system(size: 20))
        }
    }
}

// MARK: - Type Tag

struct TypeTag: View {
    let type: CoinType

    var body: some View {
        Text(type.displayName)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(
                Capsule().fill(type == .coin ? Color.orange.opacity(0.15) : Color.green.opacity(0.15))
            )
            .foregroundStyle(type == .coin ? .orange : .green)
    }
}

// MARK: - New Badge

struct NewBadge: View {
    var body: some View {
        Text(Strings.CoinRow.newBadge)
            .font(.system(size: 9, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .background(Color.blue, in: Capsule())
    }
}

// MARK: - Scroll list helper

struct CoinScrollList: View {
    let coins: [Coin]
    let emptyMessage: String
    let onToggleWatch: (Coin) -> Void

    var body: some View {
        if coins.isEmpty {
            if #available(iOS 17.0, *) {
                ContentUnavailableView(
                    label: { Label(Strings.EmptyState.noCoins, systemImage: Strings.Icons.emptyStateIcon) },
                    description: { Text(emptyMessage).multilineTextAlignment(.center) }
                )
            } else {
                // Fallback on earlier versions
            }
        } else {
            List(coins) { coin in
                CoinRow(coin: coin) { onToggleWatch(coin) }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.visible)
            }
            .listStyle(.plain)
            .animation(.default, value: coins)
        }
    }
}
