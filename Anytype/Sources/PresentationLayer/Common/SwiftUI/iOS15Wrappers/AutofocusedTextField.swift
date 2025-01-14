import SwiftUI

struct AutofocusedTextField: View {
    let placeholder: String
    let placeholderFont: AnytypeFont
    let shouldSkipFocusOnFilled: Bool

    @Binding var text: String

    init(
        placeholder: String,
        placeholderFont: AnytypeFont,
        shouldSkipFocusOnFilled: Bool = false,
        text: Binding<String>
    ) {
        self.placeholder = placeholder
        self.placeholderFont = placeholderFont
        self.shouldSkipFocusOnFilled = shouldSkipFocusOnFilled
        self._text = text
    }
    
    var body: some View {
        if #available(iOS 15.0, *) {
            NewAutofocusedTextField(
                placeholder: placeholder,
                placeholderFont: placeholderFont,
                shouldSkipFocusOnFilled: shouldSkipFocusOnFilled,
                text: $text
            )
        } else {
            AnytypeTextField(placeholder: placeholder, placeholderFont: placeholderFont, text: $text)
        }
    }
}

@available(iOS 15.0, *)
private struct NewAutofocusedTextField: View {
    let placeholder: String
    let placeholderFont: AnytypeFont
    let shouldSkipFocusOnFilled: Bool
    @Binding var text: String
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        AnytypeTextField(placeholder: placeholder, placeholderFont: placeholderFont, text: $text)
            .focused($isFocused)
            .task {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isFocused = text.isEmpty || !shouldSkipFocusOnFilled
                }
            }
    }
}
