
import BlocksModels
import Combine
import Foundation
import ProtobufMessages
import AnytypeCore
import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var favoritesCellData: [HomeCellData] = []
    var nonArchivedFavoritesCellData: [HomeCellData] {
        favoritesCellData.filter { $0.isArchived == false }
    }
    
    @Published var historyCellData: [HomeCellData] = []
    
    @Published private var _binCellData: [HomeCellData] = []
    @Published var selectedPages: Set<BlockId> = []
    var binCellData: [HomeCellData] {
        _binCellData.map {
            $0.withSelected(selectedPages.contains($0.id))
        }
    }
    var isSelection: Bool { selectedPages.isNotEmpty }
    
    @Published var openedPageData = OpenedPageData.cached
    @Published var showSearch = false
    @Published var snackBarData = SnackBarData(text: "", showSnackBar: false)
    
    let coordinator: HomeCoordinator = ServiceLocator.shared.homeCoordinator()
    
    private let configurationService = MiddlewareConfigurationService.shared
    private let dashboardService: DashboardServiceProtocol = ServiceLocator.shared.dashboardService()
    let objectActionsService: ObjectActionsServiceProtocol = ServiceLocator.shared.objectActionsService()
    let searchService = ServiceLocator.shared.searchService()
    
    let document: BaseDocumentProtocol
    private lazy var cellDataBuilder = HomeCellDataBuilder(document: document)
    
    let bottomSheetCoordinateSpaceName = "BottomSheetCoordinateSpaceName"
    private var animationsEnabled = true
    
    init() {
        let homeBlockId = configurationService.configuration().homeBlockID
        document = BaseDocument(objectId: homeBlockId)
        document.onUpdateReceive = { [weak self] updateResult in
            self?.onDashboardChange(updateResult: updateResult)
        }
        document.open()
    }

    // MARK: - View output

    func viewLoaded() {
        updateBinTab()
        updateHistoryTab()
        animationsEnabled = true
    }

    func updateBinTab() {
        guard let searchResults = searchService.searchArchivedPages() else { return }
        withAnimation(animationsEnabled ? .spring() : nil) {
            _binCellData = cellDataBuilder.buildCellData(searchResults)
        }
    }
    func updateHistoryTab() {
        guard let searchResults = searchService.searchHistoryPages() else { return }
        withAnimation(animationsEnabled ? .spring() : nil) {
            historyCellData = cellDataBuilder.buildCellData(searchResults)
        }
    }
    
    func select(data: HomeCellData) {
        if selectedPages.contains(data.id) {
            selectedPages.remove(data.id)
        } else {
            selectedPages.insert(data.id)
        }
    }
    
    // MARK: - Private methods
    private func onDashboardChange(updateResult: EventsListenerUpdate) {
        withAnimation(animationsEnabled ? .spring() : nil) {
            switch updateResult {
            case .general:
                favoritesCellData = cellDataBuilder.buildFavoritesData(updateResult)
            case .blocks(let blockIds):
                blockIds.forEach { updateFavoritesCellWithTargetId($0) }
            case .details(let detailId):
                updateFavoritesCellWithTargetId(detailId)
            case .syncStatus:
                break
            }
        }
    }
    
    private func updateFavoritesCellWithTargetId(_ blockId: BlockId) {
        guard let newDetails = document.detailsStorage.get(id: blockId) else {
            anytypeAssertionFailure("Could not find object with id: \(blockId)")
            return
        }

        favoritesCellData.enumerated()
            .first { $0.element.destinationId == blockId }
            .flatMap { offset, data in
                favoritesCellData[offset] = cellDataBuilder.updatedCellData(
                    newDetails: newDetails,
                    oldData: data
                )
            }
    }
}

// MARK: - New page
extension HomeViewModel {
    func createNewPage() {
        guard let response = dashboardService.createNewPage() else { return }
        
        EventsBunch(
            objectId: document.objectId,
            middlewareEvents: response.messages
        ).send()

        guard !response.newBlockId.isEmpty else {
            anytypeAssertionFailure("No new block id in create new page response")
            return
        }
        
        showPage(pageId: response.newBlockId)
    }
    
    func startSearch() {
        showSearch = true
    }
    
    func showPage(pageId: BlockId) {
        animationsEnabled = false // https://app.clickup.com/t/1jz5kg4
        openedPageData.pageId = pageId
        openedPageData.showingNewPage = true
    }
}
