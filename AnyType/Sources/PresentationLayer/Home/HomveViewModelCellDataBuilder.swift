import Combine
import BlocksModels

// TODO: Use single subscriptions for all changes instead of per cell approach
extension HomeViewModel {
    
    func onDashboardUpdate(_ updateResult: DocumentViewModelUpdateResult) {
        switch updateResult.updates {
        case .general:
            let newCellData = buldCellData(updateResult)

            DispatchQueue.main.async { [weak self] in
                self?.cellData = newCellData
            }
            
        case .update(let payload):
            print(payload)
            // Currently models updates using their own publishers
            // Do not need to do something here
            break
        }
    }
    
    private func buldCellData(_ updateResult: DocumentViewModelUpdateResult) -> [PageCellData] {
        let viewModels = updateResult.models.compactMap { $0 as? BlockPageLinkViewModel }
        cellSubscriptions = []
        return viewModels.map { buildPageCellData(pageLinkViewModel: $0) }
    }
    
    private func buildPageCellData(pageLinkViewModel: BlockPageLinkViewModel) -> PageCellData {
        let details = pageLinkViewModel.getDetailsViewModel().currentDetails
        
        pageLinkViewModel.getDetailsViewModel().wholeDetailsPublisher.receiveOnMain().sink { [weak self] details in
            guard let self = self, let index = self.cellData.index(id: pageLinkViewModel.blockId) else {
                return
            }
            
            var data = self.cellData[index]
            data.title = details[.name] ?? ""
            data.icon = details.documentIcon
            
            self.cellData[index] = data
        }.store(in: &cellSubscriptions)
        
        return PageCellData(
            id: pageLinkViewModel.blockId,
            destinationId: pageLinkViewModel.targetBlockId,
            icon: details.documentIcon,
            title: details[.name] ?? "",
            type: "Page"
        )
    }
    
    private func destinationId(_ pageLinkViewModel: BlockPageLinkViewModel) -> String {
        let targetBlockId: String
        if case let .link(link) = pageLinkViewModel.getBlock().blockModel.information.content {
            targetBlockId = link.targetBlockID
        }
        else {
            assertionFailure("No target id for \(pageLinkViewModel)")
            targetBlockId = ""
        }
        return targetBlockId
    }
    
}
