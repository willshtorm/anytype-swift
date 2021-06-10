import BlocksModels
import os


final class ToolbarBlockActionHandler {
    private let service: BlockActionServiceProtocol
    private var indexWalker: LinearIndexWalker?

    init(service: BlockActionServiceProtocol, indexWalker: LinearIndexWalker?) {
        self.service = service
        self.indexWalker = indexWalker
    }

    func model(beforeModel: BlockActiveRecordModelProtocol, includeParent: Bool) -> BlockActiveRecordModelProtocol? {
        //        TopLevel.BlockUtilities.IndexWalker.model(beforeModel: beforeModel, includeParent: includeParent)
        self.indexWalker?.renew()
        return self.indexWalker?.model(beforeModel: beforeModel, includeParent: includeParent)
    }

    func handlingToolbarAction(_ block: BlockActiveRecordModelProtocol, _ action: BlocksViews.Toolbar.UnderlyingAction) {
        switch action {
        case let .addBlock(value):
            switch value {
            case .objects(.page):
                self.service.createPage(afterBlock: block.blockModel.information)
            default:
                if let newBlock = BlockBuilder.createInformation(block: block, action: action) {
                    /// Business logic.
                    /// If we create block that can capture focus ( text block in our case )
                    /// Do it!
                    var shouldSetFocusOnUpdate = false
                    if case .text = newBlock.content {
                        shouldSetFocusOnUpdate = true
                    }
                    self.service.add(newBlock: newBlock, afterBlockId: block.blockId, shouldSetFocusOnUpdate: shouldSetFocusOnUpdate)
                }
            }
        case let .turnIntoBlock(value):
            // TODO: Add turn into
            switch value {
            case let .text(value): // Set Text Style
                let type: BlockContent
                switch value {
                case .text: type = .text(.empty())
                case .h1: type = .text(.init(contentType: .header))
                case .h2: type = .text(.init(contentType: .header2))
                case .h3: type = .text(.init(contentType: .header3))
                case .highlighted: type = .text(.init(contentType: .quote))
                }
                self.service.turnInto(block: block.blockModel.information, type: type, shouldSetFocusOnUpdate: false)

            case let .list(value): // Set Text Style
                let type: BlockContent
                switch value {
                case .bulleted: type = .text(.init(contentType: .bulleted))
                case .checkbox: type = .text(.init(contentType: .checkbox))
                case .numbered: type = .text(.init(contentType: .numbered))
                case .toggle: type = .text(.init(contentType: .toggle))
                }
                self.service.turnInto(block: block.blockModel.information, type: type, shouldSetFocusOnUpdate: false)

            case let .other(value): // Change divider style.
                let type: BlockContent
                switch value {
                case .lineDivider: type = .divider(.init(style: .line))
                case .dotsDivider: type = .divider(.init(style: .dots))
                case .code: return
                }
                self.service.turnInto(block: block.blockModel.information, type: type, shouldSetFocusOnUpdate: false)

            case .objects(.page):
                let type: BlockContent = .smartblock(.init(style: .page))
                self.service.turnInto(block: block.blockModel.information, type: type, shouldSetFocusOnUpdate: false)

            default:
                assertionFailure("TurnInto for that style is not implemented \(String(describing: action))")
            }

        case let .editBlock(value):
            switch value {
            case .delete:
                // TODO: think how to manage duplicated coded in diff handlers
                // self.handlingKeyboardAction(block, .pressKey(.delete))
                self.service.delete(block: block.blockModel.information) { value in
                    guard let previousModel = self.model(beforeModel: block, includeParent: true) else {
                        return .init(contextId: value.contextID, events: value.messages, ourEvents: [])
                    }
                    let previousBlockId = previousModel.blockId
                    return .init(contextId: value.contextID, events: value.messages, ourEvents: [
                        .setFocus(.init(blockId: previousBlockId, position: .end))
                    ])
                }
            case .duplicate: self.service.duplicate(block: block.blockModel.information)
            }
        case let .bookmark(value):
            switch value {
            case let .fetch(value): self.service.bookmarkFetch(block: block.blockModel.information, url: value.absoluteString)
            }
        default: return
        }
    }
}
