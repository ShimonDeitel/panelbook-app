import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false
    @State private var editingItem: Panel?

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    ForEach(store.items) { item in
                        Button {
                            editingItem = item
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.title.isEmpty ? "Untitled" : item.title)
                                    .font(Theme.titleFont)
                                    .foregroundStyle(.white)
                                Text("\(item.pieceCount)")
                                    .font(Theme.bodyFont)
                                    .foregroundStyle(Theme.accent2)
                            }
                            .padding(.vertical, 6)
                        }
                        .listRowBackground(Theme.card)
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets)
                    }
                }
                .scrollContentBackground(.hidden)
                .accessibilityIdentifier("itemList")
            }
            .navigationTitle("Panel Book")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                EditItemView(item: nil) { newItem in
                    store.add(newItem)
                }
            }
            .sheet(item: $editingItem) { item in
                EditItemView(item: item) { updated in
                    store.update(updated)
                }
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
        .tint(Theme.accent)
    }
}

struct EditItemView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var draft: Panel
    let onSave: (Panel) -> Void
    private let isNew: Bool

    init(item: Panel?, onSave: @escaping (Panel) -> Void) {
        _draft = State(initialValue: item ?? Panel())
        self.onSave = onSave
        self.isNew = item == nil
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Panel title", text: $draft.title)
                        .accessibilityIdentifier("field_title")
                    HStack {
                        Text("Piece count")
                        Spacer()
                        TextField("Piece count", value: $draft.pieceCount, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .accessibilityIdentifier("field_pieceCount")
                    }
                    TextField("Glass colors", text: $draft.glassColors)
                        .accessibilityIdentifier("field_glassColors")
                    HStack {
                        Text("Came footage (ft)")
                        Spacer()
                        TextField("Came footage (ft)", value: $draft.cameFootage, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .accessibilityIdentifier("field_cameFootage")
                    }
                    TextField("Pattern source", text: $draft.patternSource)
                        .accessibilityIdentifier("field_patternSource")
                }
            }
            .navigationTitle(isNew ? "New Panel" : "Edit Panel")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("cancelButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(draft)
                        dismiss()
                    }
                    .accessibilityIdentifier("saveButton")
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
