import SwiftUI

struct SetFiltersTextView: View {
    @ObservedObject var viewModel: SetFiltersTextViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer.fixedHeight(10)
            textField
            Spacer.fixedHeight(10)
            button
        }
        .padding(.horizontal, 20)
    }
    
    var textField: some View {
        AutofocusedTextField(
            placeholder: Loc.EditFilters.Popup.TextView.placeholder,
            text: $viewModel.input
        )
        .keyboardType(viewModel.keyboardType)
        .frame(height: 48)
        .divider()
    }
    
    private var button: some View {
        StandardButton(disabled: viewModel.input.isEmpty, text: Loc.Set.Filters.Search.Button.title, style: .primary) {
            viewModel.handleText()
        }
        .padding(.top, 10)
    }
}
