import SwiftUI
import AnytypeCore

struct DebugMenu: View {
    @State private var flags = FeatureFlags.features.sorted { $0.0.rawValue < $1.0.rawValue }
    @State private var showLogs = false
    @State private var showTypography = false
    
    var body: some View {
        VStack {
            DragIndicator()
            AnytypeText("Debug menu 👻".localized, style: .title, color: .textPrimary)
            buttons
            setPageCounter
            toggles
        }
        .ignoresSafeArea()
        .embedInNavigation()
        .navigationBarHidden(true)
    }
    
    @State var rowsPerPageInSet = "\(UserDefaultsConfig.rowsPerPageInSet)"
    private var setPageCounter: some View {
        HStack {
            AnytypeText("Number of rows per page in set", style: .body, color: .textPrimary)
                .frame(maxWidth: .infinity)
            TextField("Pages", text: $rowsPerPageInSet)
                .textFieldStyle(.roundedBorder)
                .frame(width: 100)
        }
        .padding(20)
        .onChange(of: rowsPerPageInSet) { count in
            guard let count = Int64(count) else { return }
            UserDefaultsConfig.rowsPerPageInSet = count
        }
    }
    
    private var buttons: some View {
        VStack {
            HStack {
                StandardButton(text: "Logs 🧻", style: .secondary) {
                    showLogs.toggle()
                }
                StandardButton(text: "Typography 🦭", style: .secondary) {
                    showTypography.toggle()
                }
            }
            HStack {
                StandardButton(text: "Crash 🔥", style: .primary) {
                    let crash: [Int] = []
                    _ = crash[1]
                }
                StandardButton(text: "Assert 🥲", style: .secondary) {
                    anytypeAssertionFailure("Test assert", domain: .debug)
                }
            }
        }
        .padding(.horizontal)
        .padding()
        .sheet(isPresented: $showLogs) { EventsLogView(viewModel: .init()) }
        .sheet(isPresented: $showTypography) { TypographyExample() }
    }
    
    var toggles: some View {
        List(flags.indices) { index in
            Toggle(
                isOn: $flags[index].onChange(FeatureFlags.update).value
            ) {
                AnytypeText(flags[index].key.rawValue, style: .body, color: .textPrimary)
            }
            .padding()
        }
    }
}


struct FeatureFlagsView_Previews: PreviewProvider {
    static var previews: some View {
        DebugMenu()
    }
}
