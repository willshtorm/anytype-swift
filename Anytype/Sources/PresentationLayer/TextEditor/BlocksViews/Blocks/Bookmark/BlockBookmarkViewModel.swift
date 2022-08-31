import Combine
import BlocksModels
import UIKit
import AnytypeCore

// https://www.figma.com/file/3lljgCRXYLiUeefJSxN1aC/Components?node-id=106%3A745
struct BlockBookmarkViewModel: BlockViewModelProtocol {    
    var hashable: AnyHashable { [ info, objectDetails ] as [AnyHashable] }
    
    let info: BlockInformation
    let bookmarkData: BlockBookmark
    let objectDetails: ObjectDetails?
    
    let showBookmarkBar: (BlockInformation) -> ()
    let openUrl: (URL) -> ()
    
    func makeContentConfiguration(maxWidth _: CGFloat) -> UIContentConfiguration {
        let backgroundColor = info.backgroundColor.map(UIColor.Background.uiColor(from:)) ?? nil

        let payload = BlockBookmarkPayload(bookmarkData: bookmarkData, objectDetails: objectDetails)

        if FeatureFlags.bookmarksFlowP2 {
            switch bookmarkData.state {
            case .empty:
                return emptyViewConfiguration(text: Loc.Content.Bookmark.add, state: .default)
            case .fetching:
                return emptyViewConfiguration(text: Loc.Content.Bookmark.loading, state: .uploading)
            case .done:
                return BlockBookmarkConfiguration(
                    payload: payload,
                    backgroundColor: backgroundColor
                )
                    .cellBlockConfiguration(
                    indentationSettings: .init(with: info.configurationData),
                    dragConfiguration: .init(id: info.id)
                )
            case .error:
                return emptyViewConfiguration(text: Loc.Content.Common.error, state: .error)
            }
        } else {
            switch bookmarkData.state {
            case .empty, .fetching, .error:
                return emptyViewConfiguration(text: Loc.Content.Bookmark.add, state: .default)
            case .done:
                return BlockBookmarkConfiguration(
                    payload: payload,
                    backgroundColor: backgroundColor
                )
                    .cellBlockConfiguration(
                    indentationSettings: .init(with: info.configurationData),
                    dragConfiguration: .init(id: info.id)
                )
            }
        }
    }
    
    func didSelectRowInTableView(editorEditingState: EditorEditingState) {
        
        switch bookmarkData.state {
        case .empty, .error:
            guard case .editing = editorEditingState else { return }
            showBookmarkBar(info)
        case .fetching:
            break
        case .done:
            guard let url = URL(string: bookmarkData.url) else { return }
            openUrl(url)
        }
    }
    
    private func emptyViewConfiguration(text: String, state: BlocksFileEmptyViewState) -> UIContentConfiguration {
        BlocksFileEmptyViewConfiguration(
            imageAsset: .TextEditor.BlockFile.Empty.bookmark,
            text: text,
            state: state
        ).cellBlockConfiguration(
                indentationSettings: .init(with: info.configurationData),
                dragConfiguration: .init(id: info.id)
            )
    }
}
