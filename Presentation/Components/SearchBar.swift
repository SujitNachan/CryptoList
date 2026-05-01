import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: AppConstants.Spacing.small) { // Refactored
            Image(systemName: Strings.Icons.searchIcon)
                .foregroundStyle(.secondary)

            TextField(Strings.CoinList.searchPlaceholder, text: $text)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .focused($isFocused)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: Strings.Icons.clearIcon)
                        .foregroundStyle(.secondary)
                }
                .transition(.scale)
            }
        }
        .padding(AppConstants.Layout.searchBarPadding) // Refactored
        .background(
            Color(.systemGray6),
            in: RoundedRectangle(cornerRadius: AppConstants.Design.cornerRadius) // Refactored
        )
        .animation(
            .easeInOut(duration: AppConstants.Design.animationDuration), // Refactored
            value: text.isEmpty
        )
    }
}
