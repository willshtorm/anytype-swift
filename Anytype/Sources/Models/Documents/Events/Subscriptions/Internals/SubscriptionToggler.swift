import ProtobufMessages
import BlocksModels
import AnytypeCore

protocol SubscriptionTogglerProtocol {
    func startSubscription(data: SubscriptionData) -> SubscriptionTogglerResult?
    func stopSubscription(id: SubscriptionId)
}

final class SubscriptionToggler: SubscriptionTogglerProtocol {
    let numberOfRowsPerPageInSubscriptions = UserDefaultsConfig.rowsPerPageInSet
    
    func startSubscription(data: SubscriptionData) -> SubscriptionTogglerResult? {
        switch data {
        case .recentTab:
            return startHistoryTabSubscription()
        case .archiveTab:
            return startArchiveTabSubscription()
        case .sharedTab:
            return startSharedTabSubscription()
        case .setsTab:
            return startSetsTabSubscription()
        case .profile(id: let profileId):
            return startProfileSubscription(blockId: profileId)
        case let .set(data):
            return startSetSubscription(data: data)
        }
    }
    
    func stopSubscription(id: SubscriptionId) {
        _ = Anytype_Rpc.Object.SearchUnsubscribe.Service.invoke(subIds: [id.rawValue])
    }
    
    // MARK: - Private
    private func startProfileSubscription(blockId: BlockId) -> SubscriptionTogglerResult? {
        let response = Anytype_Rpc.Object.SubscribeIds.Service.invoke(
            subID: SubscriptionId.profile.rawValue,
            ids: [blockId],
            keys: [BundledRelationKey.id.rawValue, BundledRelationKey.name.rawValue, BundledRelationKey.iconImage.rawValue],
            ignoreWorkspace: ""
        )
        
        guard let result = response.getValue(domain: .subscriptionService) else {
            return nil
        }

        return SubscriptionTogglerResult(
            records: result.records.asDetais,
            dependencies: result.dependencies.asDetais,
            count: 1
        )
    }
    
    private func startSetSubscription(data: SetSubsriptionData) -> SubscriptionTogglerResult? {
        let keys = data.buildKeys(
            with: homeDetailsKeys.map { $0.rawValue}
        )
        
        return makeRequest(subId: .set, filters: data.filters, sorts: data.sorts, source: data.source, keys: keys, pageNumber: data.currentPage)
    }
    
    private func startHistoryTabSubscription() -> SubscriptionTogglerResult? {
        let sort = SearchHelper.sort(
            relation: BundledRelationKey.lastModifiedDate,
            type: .desc
        )
        var filters = buildFilters(
            isArchived: false,
            typeIds: ObjectTypeProvider.shared.supportedTypeIds
        )
        filters.append(SearchHelper.lastOpenedDateNotNilFilter())
        
        return makeRequest(subId: .recentTab, filters: filters, sorts: [sort])
    }
    
    private func startArchiveTabSubscription() -> SubscriptionTogglerResult? {
        let sort = SearchHelper.sort(
            relation: BundledRelationKey.lastModifiedDate,
            type: .desc
        )
        
        let filters = buildFilters(
            isArchived: true,
            typeIds: ObjectTypeProvider.shared.supportedTypeIds
        )
        
        return makeRequest(subId: .archiveTab, filters: filters, sorts: [sort])
    }
    
    private func startSharedTabSubscription() -> SubscriptionTogglerResult? {
        let sort = SearchHelper.sort(
            relation: BundledRelationKey.lastModifiedDate,
            type: .desc
        )
        var filters = buildFilters(isArchived: false, typeIds: ObjectTypeProvider.shared.supportedTypeIds)
        filters.append(contentsOf: SearchHelper.sharedObjectsFilters())
        
        return makeRequest(subId: .sharedTab, filters: filters, sorts: [sort])
    }
    
    private func startSetsTabSubscription() -> SubscriptionTogglerResult? {
        let sort = SearchHelper.sort(
            relation: BundledRelationKey.lastModifiedDate,
            type: .desc
        )
        let filters = buildFilters(
            isArchived: false,
            typeIds: ObjectTypeProvider.shared.objectTypes(smartblockTypes: [.set]).map { $0.id }
        )
        
        return makeRequest(subId: .setsTab, filters: filters, sorts: [sort])
    }

    private let homeDetailsKeys: [BundledRelationKey] = [
        .id, .iconEmoji, .iconImage, .name, .snippet, .description, .type, .layout, .isArchived, .isDeleted, .done, .isFavorite
    ]
    private func makeRequest(
        subId: SubscriptionId,
        filters: [DataviewFilter],
        sorts: [DataviewSort],
        source: [String] = [],
        keys: [String]? = nil,
        pageNumber: Int64 = 1
    ) -> SubscriptionTogglerResult? {
        let offset = Int64(pageNumber - 1) * numberOfRowsPerPageInSubscriptions
        let response = Anytype_Rpc.Object.SearchSubscribe.Service
            .invoke(
                subID: subId.rawValue,
                filters: filters,
                sorts: sorts,
                limit: numberOfRowsPerPageInSubscriptions,
                offset: offset,
                keys: keys ?? homeDetailsKeys.map { $0.rawValue },
                afterID: "",
                beforeID: "",
                source: source,
                ignoreWorkspace: "",
                noDepSubscription: false
            )
        
        guard let result = response.getValue(domain: .subscriptionService) else {
            return nil
        }
        
        return SubscriptionTogglerResult(
            records: result.records.asDetais,
            dependencies: result.dependencies.asDetais,
            count: result.counters.total
        )
    }
    
    private func buildFilters(isArchived: Bool, typeIds: [String]) -> [DataviewFilter] {
        [
            SearchHelper.notHiddenFilter(),
            
            SearchHelper.isArchivedFilter(isArchived: isArchived),
            
            SearchHelper.typeFilter(typeIds: typeIds)
        ]
    }
}
