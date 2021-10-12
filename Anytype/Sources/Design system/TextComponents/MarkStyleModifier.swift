import AnytypeCore
import UIKit

final class MarkStyleModifier {
    
    let attributedString: NSMutableAttributedString
    private let anytypeFont: AnytypeFont
    
    init(
        attributedString: NSMutableAttributedString,
        anytypeFont: AnytypeFont
    ) {
        self.attributedString = attributedString
        self.anytypeFont = anytypeFont
    }
    
    convenience init(
        attributedString: NSAttributedString,
        anytypeFont: AnytypeFont
    ) {
        self.init(
            attributedString: NSMutableAttributedString(attributedString: attributedString),
            anytypeFont: anytypeFont
        )
    }
        
    func apply(_ action: MarkStyleAction, range: NSRange) {
        guard attributedString.isRangeValid(range) else {
            anytypeAssertionFailure("Range out of bounds in \(#function)")
            return
        }
        
        switch action {
        case .bold, .italic, .keyboard, .backgroundColor, .textColor, .link, .underscored, .strikethrough:
            apply(action, toAllSubrangesIn: range)
        case .mention:
            apply(action, toWhole: range)
        }
    }
    
    private func apply(_ action: MarkStyleAction, toWhole range: NSRange) {
        let oldAttributes = getAttributes(at: range)
        guard let update = apply(action, to: oldAttributes) else { return }
        
        var newAttributes = mergeAttributes(
            origin: oldAttributes,
            changes: update.changeAttributes
        )
        for key in update.deletedKeys {
            newAttributes.removeValue(forKey: key)
            attributedString.removeAttribute(key, range: range)
        }

        attributedString.addAttributes(newAttributes, range: range)
        if case let .mention(image, _) = action {
            applyMention(image: image, range: range, font: anytypeFont)
        }
    }
    
    private func mergeAttributes(origin: [NSAttributedString.Key : Any], changes: [NSAttributedString.Key : Any]) -> [NSAttributedString.Key : Any] {
        var result = origin
        result.merge(changes) { (source, target) in target }
        return result
    }
    
    private func getAttributes(at range: NSRange) -> [NSAttributedString.Key : Any] {
        switch (attributedString.string.isEmpty, range) {
        // isEmpty & range == zero(0, 0) - assuming that we deleted text. So, we need to apply default typing attributes that are coming from textView.
        case (true, NSRange.zero): return [:]
            
        // isEmpty & range != zero(0, 0) - strange situation, we can't do that. Error, we guess. In that case we need only empty attributes.
        case (true, _): return [:]
        
        // At the end.
        case let (_, value) where value.location == attributedString.length && value.length == 0: return [:]
            
        // Otherwise, return string attributes.
        default: break
        }
        guard attributedString.length >= range.location + range.length else { return [:] }
        return attributedString.attributes(at: range.lowerBound, longestEffectiveRange: nil, in: range)
    }
    
    private func apply(_ action: MarkStyleAction, toAllSubrangesIn range: NSRange) {
        attributedString.enumerateAttributes(in: range) { _, subrange, _ in
            apply(action, toWhole: subrange)
        }
    }
    
    private func applyMention(image: ObjectIconImage?, range: NSRange, font: AnytypeFont) {
        let mentionAttributedString = attributedString.attributedSubstring(from: range)
        let mentionAttachment = MentionAttachment(icon: image, size: font.mentionType)
        let mentionAttachmentString = NSMutableAttributedString(attachment: mentionAttachment)
        var currentAttributes = mentionAttributedString.attributes(at: 0, effectiveRange: nil)
        currentAttributes.removeValue(forKey: .localUnderline)
        mentionAttachmentString.addAttributes(
            currentAttributes,
            range: mentionAttachmentString.wholeRange
        )
        attributedString.insert(mentionAttachmentString, at: range.location)
    }
    
    private func apply(_ action: MarkStyleAction, to old: [NSAttributedString.Key : Any]) -> AttributedStringChange? {
        switch action {
        case let .bold(shouldApplyMarkup):
            guard let oldFont = old[.font] as? UIFont else { return nil }

            let newFont = shouldApplyMarkup ? oldFont.bold : oldFont.regular
            return AttributedStringChange(changeAttributes: [.font : newFont])


        case let .italic(shouldApplyMarkup):
            guard let oldFont = old[.font] as? UIFont else { return nil }

            let newFont = shouldApplyMarkup ? oldFont.italic : oldFont.nonItalic
            return AttributedStringChange(changeAttributes: [.font : newFont])

        case let .keyboard(hasStyle):
            return keyboardUpdate(
                with: old,
                shouldHaveStyle: hasStyle
            )

        case let .strikethrough(shouldApplyMarkup):
            return AttributedStringChange(
                changeAttributes: [.strikethroughStyle : shouldApplyMarkup ? NSUnderlineStyle.single.rawValue : 0]
            )

        case let .underscored(shouldApplyMarkup):
            return AttributedStringChange(
                changeAttributes: [.underlineStyle : shouldApplyMarkup ? NSUnderlineStyle.single.rawValue : 0]
            )

        case let .textColor(color):
            return AttributedStringChange(changeAttributes: [.foregroundColor : color as Any])

        case let .backgroundColor(color):
            return AttributedStringChange(changeAttributes: [.backgroundColor : color as Any])

        case let .link(url):
            return AttributedStringChange(
                changeAttributes: [.link : url as Any],
                deletedKeys: url.isNil ? [.link] : []
            )

        case let .mention(_, blockId):
            return AttributedStringChange(
                changeAttributes: [
                    .mention: blockId as Any,
                    .localUnderline: true
                ]
            )
        }
    }
    
    private func keyboardUpdate(
        with attributes: [NSAttributedString.Key: Any],
        shouldHaveStyle: Bool
    ) -> AttributedStringChange? {
        guard let font = attributes[.font] as? UIFont else { return nil }
        
        var targetFont: UIFont
        switch (font.isCode, shouldHaveStyle) {
        case (true, true):
            return AttributedStringChange(changeAttributes: [.font: font])
        case (true, false):
            targetFont = anytypeFont.uiKitFont
        case (false, true):
            targetFont = UIFont.code(of: font.pointSize)
        case (false, false):
            return AttributedStringChange(changeAttributes: [.font: font])
        }
        
        var newFontDescriptor = targetFont.fontDescriptor
        newFontDescriptor = newFontDescriptor.withSymbolicTraits(font.fontDescriptor.symbolicTraits) ?? newFontDescriptor

        return AttributedStringChange(changeAttributes: [.font: UIFont(descriptor: newFontDescriptor, size: font.pointSize)])
    }
}
