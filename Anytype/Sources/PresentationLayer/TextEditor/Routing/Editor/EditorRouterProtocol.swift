import BlocksModels
import AnytypeCore
import UIKit

protocol AttachmentRouterProtocol {
    func openImage(_ imageContext: BlockImageViewModel.ImageOpeningContext)
}

protocol EditorRouterProtocol: AnyObject, AttachmentRouterProtocol {
    func showAlert(alertModel: AlertModel)

    func showPage(data: EditorScreenData)
    func openUrl(_ url: URL)
    func showBookmarkBar(completion: @escaping (AnytypeURL) -> ())
    func showLinkMarkup(url: AnytypeURL?, completion: @escaping (AnytypeURL?) -> Void)
    
    func showFilePicker(model: Picker.ViewModel)
    func showImagePicker(contentType: MediaPickerContentType, onSelect: @escaping (NSItemProvider?) -> Void)
    
    func saveFile(fileURL: URL, type: FileContentType)
    
    func showCodeLanguageView(languages: [CodeLanguage], completion: @escaping (CodeLanguage) -> Void)
    
    func showStyleMenu(
        information: BlockInformation,
        restrictions: BlockRestrictions,
        didShow: @escaping (UIView) -> Void,
        onDismiss: @escaping () -> Void
    )

    func showMarkupBottomSheet(
        selectedMarkups: [MarkupType : AttributeState],
        selectedHorizontalAlignment: [LayoutAlignment : AttributeState],
        onMarkupAction: @escaping (MarkupViewModelAction) -> Void,
        viewDidClose: @escaping () -> Void
    )
    
    func showSettings()
    func showCoverPicker()
    func showIconPicker()
    func showLayoutPicker()
    func showTextIconPicker(contextId: BlockId, objectId: BlockId)
    func presentUndoRedo()
    
    func showMoveTo(onSelect: @escaping (BlockId) -> ())
    func showLinkTo(onSelect: @escaping (BlockId, _ typeId: String) -> ())
    func showLinkToObject(
        currentLink: Either<URL, BlockId>?,
        onSelect: @escaping (LinkToObjectSearchViewModel.SearchKind) -> ()
    )
    func showSearch(onSelect: @escaping (EditorScreenData) -> ())
    func showTypesSearch(onSelect: @escaping (BlockId) -> ())
    func showObjectPreview(blockLinkAppearance: BlockLink.Appearance, onSelect: @escaping (BlockLink.Appearance) -> Void)
    
    func showRelationValueEditingView(key: String, source: RelationSource)
    func showRelationValueEditingView(objectId: BlockId, source: RelationSource, relation: Relation)
    func showAddNewRelationView(onSelect: ((RelationInfo, _ isNew: Bool) -> Void)?)

    func showLinkContextualMenu(inputParameters: TextBlockURLInputParameters)

    func showWaitingView(text: String)
    func hideWaitingView()
    
    func goBack()
    
    func presentSheet(_ vc: UIViewController)
    func presentFullscreen(_ vc: UIViewController)
    func setNavigationViewHidden(_ isHidden: Bool, animated: Bool)
    func showTemplatesAvailabilityPopupIfNeeded(
        document: BaseDocumentProtocol,
        templatesTypeId: ObjectTypeId
    )
    
    func showViewPicker(setModel: EditorSetViewModel)

    func showCreateObject(pageId: BlockId)
    func showCreateBookmarkObject()
    
    func showSetSettings(setModel: EditorSetViewModel)
    func showViewSettings(setModel: EditorSetViewModel, dataviewService: DataviewServiceProtocol)
    func dismissSetSettingsIfNeeded()
    func showSorts(setModel: EditorSetViewModel, dataviewService: DataviewServiceProtocol)
    func showRelationSearch(relations: [RelationMetadata], onSelect: @escaping (String) -> Void)
    func showFilterSearch(filter: SetFilter, onApply: @escaping (SetFilter) -> Void)
    
    func showFilters(setModel: EditorSetViewModel, dataviewService: DataviewServiceProtocol)
    func showColorPicker(
        onColorSelection: @escaping (ColorView.ColorItem) -> Void,
        selectedColor: UIColor?,
        selectedBackgroundColor: UIColor?
    )
    
    func showCardSizes(size: DataviewViewSize, onSelect: @escaping (DataviewViewSize) -> Void)
    func showCovers(setModel: EditorSetViewModel, onSelect: @escaping (String) -> Void)
}
