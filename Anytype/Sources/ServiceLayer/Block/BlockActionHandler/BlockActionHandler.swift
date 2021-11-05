import UIKit
import BlocksModels
import Combine
import AnytypeCore

final class BlockActionHandler: BlockActionHandlerProtocol {
    private let document: BaseDocumentProtocol
    
    private let service: BlockActionServiceProtocol
    private let listService = BlockListService()
    private let textBlockActionHandler: TextBlockActionHandler
    private let markupChanger: BlockMarkupChangerProtocol
    
    private weak var modelsHolder: BlockViewModelsHolder?
    
    private let fileUploadingDemon = MediaFileUploadingDemon.shared
    
    init(
        modelsHolder: BlockViewModelsHolder,
        document: BaseDocumentProtocol,
        markupChanger: BlockMarkupChangerProtocol
    ) {
        self.modelsHolder = modelsHolder
        self.service = BlockActionService(documentId: document.objectId)
        self.document = document
        self.markupChanger = markupChanger
        
        self.textBlockActionHandler = TextBlockActionHandler(
            contextId: document.objectId,
            service: service,
            modelsHolder: modelsHolder
        )
    }

    
    // MARK: - Service proxy
    func turnIntoPage(blockId: BlockId) -> BlockId? {
        return service.turnIntoPage(blockId: blockId)
    }
    
    func upload(blockId: BlockId, filePath: String) {
        service.upload(blockId: blockId, filePath: filePath)
    }
    
    func setObjectTypeUrl(_ objectTypeUrl: String) {
        service.setObjectTypeUrl(objectTypeUrl)
    }
    
    func turnInto(_ style: BlockText.Style, blockId: BlockId) {
        let textBlockContentType = BlockContent.text(BlockText(contentType: style))
        service.turnInto(blockId: blockId, type: textBlockContentType.type)
    }
    
    func setTextColor(_ color: BlockColor, blockId: BlockId) {
        listService.setBlockColor(contextId: document.objectId, blockIds: [blockId], color: color.middleware)
    }
    
    func setBackgroundColor(_ color: BlockBackgroundColor, blockId: BlockId) {
        service.setBackgroundColor(blockId: blockId, color: color)
    }
    
    func duplicate(blockId: BlockId) {
        service.duplicate(blockId: blockId)
    }
    
    func setFields(_ fields: [BlockFields], blockId: BlockId) {
        service.setFields(contextID: document.objectId, blockFields: fields)
    }
    
    // MARK: - Public methods
    func changeCaretPosition(range: NSRange) {
        UserSession.shared.focus.value = .at(range)
    }
    
    func handleKeyboardAction(_ action: CustomTextView.KeyboardAction, info: BlockInformation) {
        textBlockActionHandler.handleKeyboardAction(info: info, action: action)
    }
    
    func changeTextStyle(
        text: NSAttributedString, attribute: BlockHandlerActionType.TextAttributesType, range: NSRange, blockId: BlockId
    ) {
        handleAction(.toggleFontStyle(text, attribute, range), blockId: blockId)
    }
    
    func changeText(_ text: NSAttributedString, info: BlockInformation) {
        textBlockActionHandler.changeText(info: info, text: text)
    }
    
    func handleAction(_ action: BlockHandlerActionType, blockId: BlockId) {
        switch action {
        case let .toggleWholeBlockMarkup(markup):
            markupChanger.toggleMarkup(markup, for: blockId)
            
        case let .toggleFontStyle(attrText, fontAttributes, range):
            markupChanger.toggleMarkup(
                fontAttributes,
                attributedText: attrText,
                for: blockId,
                in: range
            )
            
        case let .setAlignment(alignment):
            setAlignment(blockId: blockId, alignment: alignment)
            
        case let .setLink(attrText, url, range):
            markupChanger.setLink(url, attributedText: attrText, for: blockId, in: range)

        case let .setLinkToObject(linkBlockId: linkBlockId, attrText, range):
            markupChanger.setLinkToObject(id: linkBlockId, attributedText: attrText, for: blockId, in: range)

        case .delete:
            delete(blockId: blockId)
            
        case let .addBlock(type):
            addBlock(blockId: blockId, type: type)
            
        case let .addLink(targetBlockId):
            service.add(
                info: BlockBuilder.createNewLink(targetBlockId: targetBlockId),
                targetBlockId: blockId,
                position: .bottom,
                shouldSetFocusOnUpdate: false
            )
            
        case let .turnIntoBlock(type):
            service.turnInto(blockId: blockId, type: type)
            
        case let .fetch(url: url):
            service.bookmarkFetch(blockId: blockId, url: url.absoluteString)
            
        case .toggle:
            service.receivelocalEvents([.setToggled(blockId: blockId)])
            
        case .checkbox(selected: let selected):
            service.checked(blockId: blockId, newValue: selected)
            
        case .createEmptyBlock(let parentId):
            service.addChild(
                info: BlockBuilder.createDefaultInformation(),
                parentBlockId: parentId
            )
            
        case .moveTo(targetId: let targetId):
            moveTo(targetId: targetId, blockId: blockId)
        }
    }
    
    
    func onEmptySpotTap() {
        guard let block = document.blocksContainer.model(id: document.objectId) else {
            return
        }
        handleAction(
            .createEmptyBlock(parentId: document.objectId),
            blockId: block.information.id
        )
    }
    
    func uploadMediaFile(itemProvider: NSItemProvider, type: MediaPickerContentType, blockId: BlockId) {
        EventsBunch(
            objectId: document.objectId,
            localEvents: [.setLoadingState(blockId: blockId)]
        ).send()
        
        let operation = MediaFileUploadingOperation(
            itemProvider: itemProvider,
            worker: BlockMediaUploadingWorker(
                objectId: document.objectId,
                blockId: blockId,
                contentType: type
            )
        )
        fileUploadingDemon.addOperation(operation)
    }
    
    func uploadFileAt(localPath: String, blockId: BlockId) {
        EventsBunch(
            objectId: document.objectId,
            localEvents: [.setLoadingState(blockId: blockId)]
        ).send()
        
        upload(blockId: blockId, filePath: localPath)
    }
    
    func createPage(targetId: BlockId, type: ObjectTemplateType) -> BlockId? {
        guard let block = document.blocksContainer.model(id: targetId) else { return nil }
        var position: BlockPosition
        if case .text(let blockText) = block.information.content, blockText.text.isEmpty {
            position = .replace
        } else {
            position = .bottom
        }
        
        return service.createPage(targetId: targetId, type: type, position: position)
    }
}

private extension BlockActionHandler {
    func setAlignment(blockId: BlockId, alignment: LayoutAlignment) {
        listService.setAlign(contextId: document.objectId, blockIds: [blockId], alignment: alignment)
    }
    
    func delete(blockId: BlockId) {
        let previousModel = modelsHolder?.findModel(beforeBlockId: blockId)
        service.delete(blockId: blockId, previousBlockId: previousModel?.blockId)
    }
    
    func addBlock(blockId: BlockId, type: BlockContentType) {
        switch type {
        case .smartblock(.page):
            anytypeAssertionFailure("Use createPage func instead")
            _ = service.createPage(targetId: blockId, type: .bundled(.page), position: .bottom)
        default:
            guard
                let newBlock = BlockBuilder.createNewBlock(type: type),
                let info = document.blocksContainer.model(
                    id: blockId
                )?.information
            else {
                return
            }
            
            let shouldSetFocusOnUpdate = newBlock.content.isText ? true : false
            let position: BlockPosition = info.isTextAndEmpty ? .replace : .bottom
            
            service.add(
                info: newBlock,
                targetBlockId: info.id,
                position: position,
                shouldSetFocusOnUpdate: shouldSetFocusOnUpdate
            )
        }
    }
    
    func moveTo(targetId: BlockId, blockId: BlockId) {
        listService.moveTo(contextId: document.objectId, blockId: blockId, targetId: targetId)
    }
}
