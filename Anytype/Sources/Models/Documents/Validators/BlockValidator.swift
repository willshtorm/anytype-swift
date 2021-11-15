
import BlocksModels

struct BlockValidator {    
    func validated(information info: BlockInformation) -> BlockInformation {
        let restrictions = BlockRestrictionsBuilder.build(content: info.content)
        
        let content: BlockContent
        if case let .text(text) = info.content {
            content = .text(
                validatedTextContent(
                    content: text,       
                    restrictions: restrictions
                )
            )
        } else {
            content = info.content
        }
        
        let backgroundColor = restrictions.canApplyBackgroundColor ? info.backgroundColor : nil
        let alignment = validatedAlignment(alignment: info.alignment, restrictions: restrictions)
        
        return BlockInformation(
            id: info.id,
            content: content,
            backgroundColor: backgroundColor,
            alignment: alignment,
            childrenIds: info.childrenIds,
            fields: info.fields
        )
    }
    
    func validatedAlignment(alignment: LayoutAlignment, restrictions: BlockRestrictions) -> LayoutAlignment {
        guard !restrictions.availableAlignments.contains(alignment) else {
            return alignment
        }
        
        return restrictions.availableAlignments.first ?? .left
    }
    
    func validatedTextContent(content: BlockText, restrictions: BlockRestrictions) -> BlockText {
        let filteredMarks = content.marks.marks.filter { mark in
            switch mark.type {
            case .strikethrough, .keyboard, .underscored, .link, .object:
                return restrictions.canApplyOtherMarkup
            case .bold:
                return restrictions.canApplyBold
            case .italic:
                return restrictions.canApplyItalic
            case .textColor:
                return restrictions.canApplyBlockColor
            case .backgroundColor:
                return restrictions.canApplyBackgroundColor
            case .mention:
                return restrictions.canApplyMention
            case .UNRECOGNIZED:
                return false
            case .emoji:
                return false
            }
        }
        
        return BlockText(
            text: content.text,
            marks: .init(marks: filteredMarks),
            color: content.color,
            contentType: content.contentType,
            checked: content.checked,
            number: content.number
        )
    }
}