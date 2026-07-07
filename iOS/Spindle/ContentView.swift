import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false
    @State private var editingItem: SpinSession? = nil

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
                                Text(item.fiberSource.isEmpty ? "Untitled" : item.fiberSource)
                                    .font(Theme.headline)
                                    .foregroundStyle(.primary)
                                Text(String(format: "%.2f", item.yardageOut)).font(Theme.caption).foregroundStyle(Theme.accent2)
                                Text(item.sessionDate.formatted(date: .abbreviated, time: .omitted)).font(Theme.caption).foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                        .accessibilityIdentifier("row_\(item.id.uuidString)")
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets)
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Spindle")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if store.canAddMore {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus")
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
    @State private var draft: SpinSession
    var onSave: (SpinSession) -> Void

    init(item: SpinSession?, onSave: @escaping (SpinSession) -> Void) {
        _draft = State(initialValue: item ?? SpinSession())
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Fiber Source", text: $draft.fiberSource)
                    .accessibilityIdentifier("field_fiberSource")
                TextField("Ply", text: $draft.ply)
                    .accessibilityIdentifier("field_ply")
                TextField("Yardage Out", value: $draft.yardageOut, format: .number)
                    .keyboardType(.decimalPad)
                    .accessibilityIdentifier("field_yardageOut")
                DatePicker("Date", selection: $draft.sessionDate, displayedComponents: .date)
                    .accessibilityIdentifier("field_sessionDate")
                TextField("Notes", text: $draft.notes)
                    .accessibilityIdentifier("field_notes")
            }
            .navigationTitle("SpinSession")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("cancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
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

#Preview {
    ContentView()
        .environmentObject(Store())
        .environmentObject(PurchaseManager())
}
