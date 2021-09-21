
import BlocksModels
import Combine
import Foundation
import ProtobufMessages
import AnytypeCore

extension HomeViewModel {
    struct NewPageData {
        let pageId: String
        var showingNewPage: Bool
    }
    
    struct SnackBarData {
        let text: String
        var showSnackBar: Bool
    }
}

final class HomeViewModel: ObservableObject {
    @Published var favoritesCellData: [HomeCellData] = []
    var nonArchivedFavoritesCellData: [HomeCellData] {
        favoritesCellData.filter { $0.isArchived == false }
    }
    
    @Published var archiveCellData: [HomeCellData] = []
    @Published var recentCellData: [HomeCellData] = []
    
    @Published var newPageData = NewPageData(pageId: "", showingNewPage: false)
    @Published var showSearch = false
    @Published var snackBarData = SnackBarData(text: "", showSnackBar: false)
    
    let coordinator: HomeCoordinator = ServiceLocator.shared.homeCoordinator()

    private let dashboardService: DashboardServiceProtocol = ServiceLocator.shared.dashboardService()
    private let blockActionsService: BlockActionsServiceSingleProtocol = ServiceLocator.shared.blockActionsServiceSingle()
    let objectActionsService: ObjectActionsServiceProtocol = ServiceLocator.shared.objectActionsService()
    let searchService = ServiceLocator.shared.searchService()
    
    private var subscriptions = [AnyCancellable]()
    private var newPageSubscription: AnyCancellable?
            
    let document: BaseDocumentProtocol = BaseDocument()
    private lazy var cellDataBuilder = HomeCellDataBuilder(document: document)
    
    init() {
        fetchDashboardData()
    }

    // MARK: - View output

    func viewLoaded() {
        updateArchiveTab()
        updateRecentTab()
    }

    // MARK: - Private methods

    func updateArchiveTab() {
        searchService.searchArchivedPages { [weak self] searchResults in
            guard let self = self else { return }
            self.archiveCellData = self.cellDataBuilder.buldCellData(searchResults)
        }
    }
    func updateRecentTab() {
        searchService.searchRecentPages { [weak self] searchResults in
            guard let self = self else { return }
            self.recentCellData = self.cellDataBuilder.buldCellData(searchResults)
        }
    }
    
    private func fetchDashboardData() {        
        dashboardService.openDashboard() { [weak self] serviceSuccess in
            self?.onOpenDashboard(serviceSuccess)
        }
    }
    
    private func onOpenDashboard(_ serviceSuccess: ResponseEvent) {
        document.updateBlockModelPublisher.receiveOnMain().sink { [weak self] updateResult in
            self?.onDashboardChange(updateResult: updateResult)
        }.store(in: &self.subscriptions)
        
        document.open(serviceSuccess)
    }
    
    private func onDashboardChange(updateResult: BaseDocumentUpdateResult) {
        switch updateResult.updates {
        case .general:
            favoritesCellData = cellDataBuilder.buldFavoritesData(updateResult)
        case .update(let blockIds):
            blockIds.forEach { updateCellWithTargetId($0) }
        case .details(let details):
            updateCellWithTargetId(details.blockId)
        }
    }
    
    private func updateCellWithTargetId(_ blockId: BlockId) {
        guard let newDetails = document.getDetails(id: blockId)?.currentDetails else {
            anytypeAssertionFailure("Could not find object with id: \(blockId)")
            return
        }

        favoritesCellData.enumerated()
            .first { $0.element.destinationId == blockId }
            .flatMap { offset, data in
                favoritesCellData[offset] = cellDataBuilder.updatedCellData(newDetails: newDetails, oldData: data)
            }
    }
}

// MARK: - New page
extension HomeViewModel {
    func createNewPage() {
        newPageSubscription = dashboardService.createNewPage()
            .receiveOnMain()
            .sinkWithDefaultCompletion("Create page") { [weak self] response in
                guard let self = self else {
                    return
                }

                self.document.handle(
                    events: PackOfEvents(middlewareEvents: response.messages)
                )

                guard !response.newBlockId.isEmpty else {
                    anytypeAssertionFailure("No new block id in create new page response")
                    return
                }
                
                self.showPage(pageId: response.newBlockId)
        }
    }
    
    func startSearch() {
        showSearch = true
    }
    
    func showPage(pageId: BlockId) {
        newPageData = NewPageData(
            pageId: pageId,
            showingNewPage: true
        )
    }
}
