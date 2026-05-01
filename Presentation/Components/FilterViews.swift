import SwiftUI

// MARK: - Quick filter chips (inline)

struct FilterChipsView: View {
    @Binding var filter: CoinFilter

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // Type chips
                ForEach(CoinType.allCases, id: \.self) { type in
                    FilterChip(
                        label: type.displayName,
                        isSelected: filter.types.contains(type)
                    ) {
                        if filter.types.contains(type) {
                            filter.types.remove(type)
                        } else {
                            filter.types.insert(type)
                        }
                    }
                }

                // Active chip
                FilterChip(
                    label: Strings.FilterChip.active,
                    isSelected: filter.showActive == true
                ) {
                    filter.showActive = (filter.showActive == true) ? nil : true
                }

                // Inactive chip
                FilterChip(
                    label: Strings.FilterChip.inactive,
                    isSelected: filter.showActive == false
                ) {
                    filter.showActive = (filter.showActive == false) ? nil : false
                }

                // New chip
                FilterChip(
                    label: Strings.FilterChip.new,
                    isSelected: filter.showNewOnly
                ) {
                    filter.showNewOnly.toggle()
                }

                // Reset
                if !filter.isDefault {
                    Button(Strings.FilterChip.reset) { filter = .default }
                        .font(.caption)
                        .foregroundStyle(.red)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: filter)
        }
    }
}

// MARK: - Single chip

struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    isSelected
                        ? Color.accentColor
                        : Color(.systemGray5),
                    in: Capsule()
                )
                .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

// MARK: - Full filter sheet

struct FilterSheetView: View {
    @Binding var filter: CoinFilter
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                activeStatusSection
                coinTypeSection
                otherSection
                if !filter.isDefault { resetSection }
            }
            .navigationTitle(Strings.Filter.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(Strings.Filter.doneButton) { dismiss() }
                }
            }
        }
    }

    private var activeStatusSection: some View {
        Section(Strings.Filter.ActiveStatus.sectionTitle) {
            Picker(Strings.Filter.ActiveStatus.pickerLabel, selection: $filter.showActive) {
                Text(Strings.Filter.ActiveStatus.all).tag(Optional<Bool>.none)
                Text(Strings.Filter.ActiveStatus.activeOnly).tag(Optional<Bool>.some(true))
                Text(Strings.Filter.ActiveStatus.inactiveOnly).tag(Optional<Bool>.some(false))
            }
            .pickerStyle(.inline)
            .labelsHidden()
        }
    }

    private var coinTypeSection: some View {
        Section(Strings.Filter.CoinType.sectionTitle) {
            ForEach(CoinType.allCases, id: \.self) { type in
                coinTypeRow(for: type)
            }
        }
    }

    private func coinTypeRow(for type: CoinType) -> some View {
        HStack {
            Text(type.displayName)
            Spacer()
            if filter.types.contains(type) {
                Image(systemName: Strings.Icons.checkmark)
                    .foregroundStyle(Color.accentColor)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if filter.types.contains(type) {
                filter.types.remove(type)
            } else {
                filter.types.insert(type)
            }
        }
    }

    private var otherSection: some View {
        Section(Strings.Filter.Other.sectionTitle) {
            Toggle(Strings.Filter.Other.showNewCoinsOnly, isOn: $filter.showNewOnly)
        }
    }

    private var resetSection: some View {
        Section {
            Button(role: .destructive) {
                filter = .default
            } label: {
                Text(Strings.Filter.resetAllFilters)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}
