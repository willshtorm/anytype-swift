import SwiftUI

struct StandardButtonView: View {
    let disabled: Bool
    let inProgress: Bool
    let text: String
    let style: StandardButtonStyle
    
    init(
        disabled: Bool = false,
        inProgress: Bool = false,
        text: String,
        style: StandardButtonStyle
    ) {
        self.disabled = disabled
        self.inProgress = inProgress
        self.text = text
        self.style = style
    }
    
    var body: some View {
        Group {
            if inProgress {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: style.textColor(disabled: disabled)))
            } else {
                AnytypeText(
                    text,
                    style: style.textFont,
                    color: style.textColor(disabled: disabled)
                )
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 48)
        .background(style.backgroundColor(disabled: disabled))
        .cornerRadius(10.0)
        .ifLet(style.borderColor) { view, borderColor in
            view.overlay(
                RoundedRectangle(cornerRadius: 8.0).stroke(borderColor, lineWidth: 1)
            )
        }
    }
}

private extension StandardButtonStyle {
    
    func backgroundColor(disabled: Bool) -> Color {
        switch self {
        case .secondary:
            return .Background.primary
        case .primary:
            return disabled ? .Stroke.primary : Color.System.amber
        case .destructive:
            return disabled ? .Stroke.primary : Color.System.red
        }
    }
    
    func textColor(disabled: Bool) -> Color {
        switch self {
        case .secondary:
            if disabled {
                return .Text.secondary
            } else {
                return .Text.primary
            }
        case .primary, .destructive:
            return .white
        }
    }
    
    var borderColor: Color? {
        switch self {
        case .secondary:
            return .Stroke.primary
        case .primary, .destructive:
            return nil
        }
    }
    
    var textFont: AnytypeFont {
        switch self {
        case .primary, .destructive:
            return .button1Semibold
        case .secondary:
            return .button1Regular
        }
    }
    
}

struct StandardButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            StandardButton(disabled: false, text: "Secondary enabled", style: .secondary, action: {})
            StandardButton(disabled: true ,text: "Secondary disabled", style: .secondary, action: {})
            StandardButton(disabled: false ,text: "Primary enabled", style: .primary, action: {})
            StandardButton(disabled: true ,text: "Primary disabled", style: .primary, action: {})
            HStack {
                StandardButton(disabled: false, text: "Destructive enabled", style: .destructive, action: {})
                StandardButton(disabled: true, inProgress: false, text: "Destructive disabled", style: .destructive, action: {})
            }
        }.padding()
    }
}
