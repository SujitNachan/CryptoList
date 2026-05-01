import Foundation
import SwiftUI
import CoreGraphics

enum Strings {
    
    enum Filter {
        static let navigationTitle  = "Filters"
        static let doneButton       = "Done"
        static let resetAllFilters  = "Reset All Filters"

        enum ActiveStatus {
            static let sectionTitle = "Active Status"
            static let pickerLabel  = "Status"
            static let all          = "All"
            static let activeOnly   = "Active only"
            static let inactiveOnly = "Inactive only"
        }

        enum CoinType {
            static let sectionTitle = "Coin Type"
        }

        enum Other {
            static let sectionTitle    = "Other"
            static let showNewCoinsOnly = "Show new coins only"
        }
    }

    enum FilterChip {
        static let active   = "Active ✓"
        static let inactive = "Inactive"
        static let new      = "🆕 New"
        static let reset    = "Reset"
    }

    enum CoinList {
        static let tabPickerTitle  = "Tab"
        static let navigationTitle  = "Crypto List"
        static let searchPlaceholder = "Search by name or symbol…"
        static let allCoins         = "All Coins"
        static let watchlist        = "Watchlist"
        static let filterLabel      = "Filter"
        static let lastUpdatedJustNow = "Last updated just now"
        static let lastUpdatedMinAgo  = "Last updated %d min ago"
        static let lastUpdatedHoursAgo = "Last updated %dh ago"
        static let offline            = "Offline"
        static let offlineSuffix      = " · Offline"
    }

    enum CoinRow {
        static let newBadge = "NEW"
    }

    enum EmptyState {
        static let noCoins          = "No Coins"
        static let loadingCoins     = "Loading coins…"
        static let noCoinsMatch     = "No coins match your search."
        static let emptyWatchlist   = "No coins in your watchlist yet.\nTap ★ on any coin to add it."
        static let noWatchlistMatch = "No watched coins match your search."
    }

    enum Icons {
        static let filterIcon       = "line.3.horizontal.decrease.circle"
        static let coinIcon         = "bitcoinsign.circle.fill"
        static let tokenIcon        = "circle.hexagongrid.fill"
        static let watchedStar      = "star.fill"
        static let unwatchedStar    = "star"
        static let checkmark        = "checkmark"
        static let searchIcon       = "magnifyingglass"
        static let clearIcon        = "xmark.circle.fill"
        static let emptyStateIcon   = "bitcoinsign.circle"
    }

    enum Database {
        static let lastFetchKey = "lastFetch"
    }
}


enum AppConstants {
    enum Spacing {
        static let standard: CGFloat = 12
        static let divider: CGFloat = 2
        static let extraSmall: CGFloat = 6
        static let small: CGFloat = 8
        static let medium: CGFloat = 10
        static let large: CGFloat = 16
    }
    
    enum Padding {
        /// Horizontal padding for chips (e.g., 12)
        static let chipHorizontal: CGFloat = 12
        /// Vertical padding for chips (e.g., 6)
        static let chipVertical: CGFloat = 6
    }
    
    enum Animation {
        /// Short duration for UI state changes like selection (e.g., 0.15s)
        static let swift: Double = 0.15
        /// Standard duration for list or view transitions (e.g., 0.2s)
        static let standard: Double = 0.2
    }
    
    enum Font {
        static let chipLabel = SwiftUI.Font.caption
    }
    
    enum Design {
            static let cornerRadius: CGFloat = 10
            static let animationDuration: Double = 0.15
        }
        
    enum Layout {
        static let searchBarPadding: CGFloat = 10
    }
}
