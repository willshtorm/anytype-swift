import BlocksModels
import UIKit
import FloatingPanel
import AnytypeCore

enum MarkdownChange {
    case turnInto(BlockText.Style, text: NSAttributedString)
    case addBlock(type: BlockContentType, text: NSAttributedString)
}

protocol MarkdownListener {
    func markdownChange(textView: UITextView, replacementText: String, range: NSRange) -> MarkdownChange?
}

final class MarkdownListenerImpl: MarkdownListener {
    func markdownChange(textView: UITextView, replacementText: String, range: NSRange) -> MarkdownChange? {
        guard textView.textChangeType(changeTextRange: range, replacementText: replacementText) == .typingSymbols else {
            return nil
        }
        
        return applyBeginningOfTextShortcuts(textView: textView, replacementText: replacementText, range: range)
    }

    // MARK: - BeginningOfText
    private func applyBeginningOfTextShortcuts(
        textView: UITextView,
        replacementText: String,
        range: NSRange
    ) -> MarkdownChange? {
        
        for shortcut in BeginingOfTextMarkdown.all {
            for shortcutText in shortcut.text {
                if beginingOfTextHaveShortcutAndCarretInsideIt(
                    shortcutText,
                    textView: textView,
                    replacementText: replacementText,
                    range: range
                ) {
                    let replacedText = textView.attributedText.mutable
                    replacedText.replaceCharacters(in: range, with: replacementText)
                    return makeMarkdownChange(
                        type: shortcut.type,
                        string: replacedText,
                        shortcutLength: shortcutText.count
                    )
                }
            }
        }

        return nil
    }
    
    private func beginingOfTextHaveShortcutAndCarretInsideIt(
        _ shortcut: String,
        textView: UITextView,
        replacementText: String,
        range: NSRange
    ) -> Bool {
        guard let offsetToCaretPosition = textView.offsetToCaretPosition() else {
            anytypeAssertionFailure("No caret position for markdown call", domain: .markdownListener)
            return false
        }
        guard let replacedText = (textView.text as NSString?)?.replacingCharacters(in: range, with: replacementText) else {
            return false
        }
        
        return replacedText.hasPrefix(shortcut) && shortcut.count >= offsetToCaretPosition
    }

    private func makeMarkdownChange(
        type: BlockContentType,
        string: NSAttributedString,
        shortcutLength: Int
    ) -> MarkdownChange {
        
        let text = string.mutable
        
        anytypeAssert(
            shortcutLength <= text.string.count,
            "Shortcut length: \(shortcutLength) for type: \(type) is bigger then  string length: \(text.string)",
            domain: .markdownListener
        )
        
        text.mutableString.deleteCharacters(
            in: NSMakeRange(0, min(shortcutLength, text.string.count))
        )
        
        switch type {
        case let .text(style):
            return .turnInto(style, text: text)
        case .divider:
            return .addBlock(type: type, text: text)
        default:
            anytypeAssertionFailure("Markdown change not supported. Type: \(type)", domain: .markdownListener)
            return .turnInto(.text, text: string)
        }
    }
}
