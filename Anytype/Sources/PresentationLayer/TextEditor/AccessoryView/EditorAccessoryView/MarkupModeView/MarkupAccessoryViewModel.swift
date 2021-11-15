//
//  MarkupAccessoryViewModel.swift
//  Anytype
//
//  Created by Denis Batvinkin on 05.11.2021.
//  Copyright © 2021 Anytype. All rights reserved.
//

import BlocksModels
import SwiftUI
import Combine

struct MarkupItem: Identifiable, Equatable {
    let id = UUID()
    let markupItem: MarkupAccessoryViewModel.MarkupKind

    static func == (lhs: MarkupItem, rhs: MarkupItem) -> Bool {
        lhs.id == rhs.id
    }

    static var allItems: [MarkupItem] {
        MarkupAccessoryViewModel.MarkupKind.allCases.map {
            MarkupItem(markupItem: $0)
        }
    }
}

final class MarkupAccessoryViewModel: ObservableObject {
    let markupItems: [MarkupItem] = MarkupItem.allItems

    private(set) var restrictions: BlockRestrictions?
    private(set) var actionHandler: BlockActionHandlerProtocol
    private(set) var blockId: BlockId = ""
    private let router: EditorRouterProtocol
    private let pageService = PageService()
    private let document: BaseDocumentProtocol

    @Published private(set) var range: NSRange = .zero
    @Published private(set) var currentText: NSAttributedString?
    @Published var showColorView: Bool = false

    var colorButtonFrame: CGRect?

    private var cancellables = [AnyCancellable]()

    init(document: BaseDocumentProtocol,
         actionHandler: BlockActionHandlerProtocol,
         router: EditorRouterProtocol
    ) {
        self.actionHandler = actionHandler
        self.router = router
        self.document = document
        self.subscribeOnBlocksChanges()
    }

    func selectBlock(_ block: BlockModelProtocol, text: NSAttributedString, range: NSRange) {
        restrictions = BlockRestrictionsBuilder.build(contentType: block.information.content.type)
        blockId = block.information.id
        currentText = text

        updateRange(range: range)
    }

    func updateRange(range: NSRange) {
        self.range = range
    }

    func action(_ markup: MarkupKind) {
        switch markup {
        case .link:
            showLinkToSearch(blockId: blockId, range: range)
        case .color:
            showColorView.toggle()
        case let .fontStyle(fontMarkup):
            actionHandler.changeTextStyle(fontMarkup.markupType, range: range, blockId: blockId)
        }
    }

    func iconColor(for markup: MarkupKind) -> Color {
        let state = attributeState(for: markup)

        switch state {
        case .disabled:
            return .buttonInactive
        case .applied:
            return .buttonSelected
        case .notApplied:
            return .buttonActive
        }
    }

    private func attributeState(for markup: MarkupKind) -> AttributeState {
        guard let currentText = currentText else { return .disabled }
        guard let restrictions = restrictions else { return .disabled }

        switch markup {
        case .fontStyle(let fontStyle):
            guard restrictions.isMarkupAvailable(fontStyle.markupType) else { return .disabled }
        case .link, .color:
            guard restrictions.canApplyOtherMarkup else { return .disabled }
        }

        if markup.hasMarkup(for: currentText, range: range) {
            return .applied
        }
        return .notApplied
    }

    private func showLinkToSearch(blockId: BlockId, range: NSRange) {
        router.showLinkToObject { [weak self] searchKind in
            switch searchKind {
            case let .object(linkBlockId):
                self?.actionHandler.setLinkToObject(linkBlockId: linkBlockId, range: range, blockId: blockId)
            case let .createObject(name):
                if let linkBlockId = self?.pageService.createPage(name: name) {
                    self?.actionHandler.setLinkToObject(linkBlockId: linkBlockId, range: range, blockId: blockId)
                }
            case let .web(url):
                self?.actionHandler.setLink(url: URL(string: url), range: range, blockId: blockId)
            }
        }
    }

    private func subscribeOnBlocksChanges() {
        document.updatePublisher.sink { [weak self] update in
            guard let self = self else { return }
            guard case let .blocks(blocks) = update else { return }

            let isCurrentBlock = blocks.contains(where: { blockId in
                blockId == self.blockId
            })

            guard isCurrentBlock, let (block, textBlockContent) = self.blockData(blockId: self.blockId) else { return }

            let currentText = textBlockContent.anytypeText(using: self.document.detailsStorage).attrString
            self.selectBlock(block, text: currentText, range: self.range)
        }.store(in: &cancellables)
    }

    private func blockData(blockId: BlockId) -> (BlockModelProtocol, BlockText)? {
        guard let model = document.blocksContainer.model(id: blockId) else {
            return nil
        }
        guard case let .text(content) = model.information.content else {
            return nil
        }
        return (model, content)
    }
}