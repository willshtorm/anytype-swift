import ProtobufMessages
import Combine
import BlocksModels
import AnytypeCore

protocol SearchServiceProtocol {
    func search(text: String) -> [ObjectDetails]?
    func searchObjectTypes(text: String, filteringTypeId: String?) -> [ObjectDetails]?
    func searchFiles(text: String, excludedFileIds: [String]) -> [ObjectDetails]?
    func searchObjects(text: String, excludedObjectIds: [String], limitedTypeIds: [String]) -> [ObjectDetails]?
    func searchTemplates(for type: ObjectTypeId) -> [ObjectDetails]?
    func searchObjects(
        text: String,
        excludedObjectIds: [String],
        excludedTypeIds: [String],
        sortRelationKey: BundledRelationKey?
    ) -> [ObjectDetails]?
}

final class SearchService: ObservableObject, SearchServiceProtocol {
    
    private let searchCommonService: SearchCommonServiceProtocol
    
    init(searchCommonService: SearchCommonServiceProtocol) {
        self.searchCommonService = searchCommonService
    }
    
    // MARK: - SearchServiceProtocol
    
    func search(text: String) -> [ObjectDetails]? {
        let sort = SearchHelper.sort(
            relation: BundledRelationKey.lastOpenedDate,
            type: .desc
        )
        
        let filters = buildFilters(
            isArchived: false,
            typeIds: ObjectTypeProvider.shared.supportedTypeIds
        )
        
        return searchCommonService.search(filters: filters, sorts: [sort], fullText: text)
    }
    
    func searchObjectTypes(text: String, filteringTypeId: String? = nil) -> [ObjectDetails]? {
        let sort = SearchHelper.sort(
            relation: BundledRelationKey.name,
            type: .asc
        )
        var filters = [
            SearchHelper.isArchivedFilter(isArchived: false),
            SearchHelper.typeFilter(typeIds: [ObjectTypeId.bundled(.objectType).rawValue]),
            SearchHelper.supportedObjectTypeIdsFilter(
                ObjectTypeProvider.shared.supportedTypeIds
            ),
            SearchHelper.excludedObjectTypeIdFilter(ObjectTypeId.bundled(.set).rawValue)
        ]
        if FeatureFlags.bookmarksFlow {
            filters.append(SearchHelper.excludedObjectTypeIdFilter(ObjectTypeId.bundled(.bookmark).rawValue))
        }
        filteringTypeId.map { filters.append(SearchHelper.excludedObjectTypeIdFilter($0)) }

        let result = searchCommonService.search(filters: filters, sorts: [sort], fullText: text, limit: 0)
        return result?.reordered(
            by: [
                ObjectTypeId.bundled(.page).rawValue,
                ObjectTypeId.bundled(.note).rawValue,
                ObjectTypeId.bundled(.task).rawValue
            ]
        ) { $0.id }
    }
    
    func searchFiles(text: String, excludedFileIds: [String]) -> [ObjectDetails]? {
        let sort = SearchHelper.sort(
            relation: BundledRelationKey.name,
            type: .asc
        )
        
        let filters = [
            SearchHelper.notHiddenFilter(),
            SearchHelper.isDeletedFilter(isDeleted: false),
            SearchHelper.layoutFilter(layouts: [DetailsLayout.fileLayout, DetailsLayout.imageLayout]),
            SearchHelper.excludedIdsFilter(excludedFileIds)
        ]
        
        return searchCommonService.search(filters: filters, sorts: [sort], fullText: text)
    }
    
    func searchObjects(text: String, excludedObjectIds: [String], limitedTypeIds: [String]) -> [ObjectDetails]? {
        let sort = SearchHelper.sort(
            relation: BundledRelationKey.lastOpenedDate,
            type: .desc
        )
        
        let typeIds: [String] = limitedTypeIds.isNotEmpty ? limitedTypeIds : ObjectTypeProvider.shared.supportedTypeIds
        var filters = buildFilters(isArchived: false, typeIds: typeIds)
        filters.append(SearchHelper.excludedIdsFilter(excludedObjectIds))
        
        return searchCommonService.search(filters: filters, sorts: [sort], fullText: text)
    }

    func searchTemplates(for type: ObjectTypeId) -> [ObjectDetails]? {
        return searchCommonService.search(filters: SearchHelper.templatesFilters(type: type))
    }
	
    func searchObjects(
        text: String,
        excludedObjectIds: [String],
        excludedTypeIds: [String],
        sortRelationKey: BundledRelationKey?
    ) -> [ObjectDetails]? {
        let sort = SearchHelper.sort(
            relation: sortRelationKey ?? .lastOpenedDate,
            type: .desc
        )
        
        var filters = buildFilters(
            isArchived: false,
            typeIds: ObjectTypeProvider.shared.supportedTypeIds
        )
        filters.append(SearchHelper.excludedTypeFilter(excludedTypeIds))
        filters.append(SearchHelper.excludedIdsFilter(excludedObjectIds))
        
        return searchCommonService.search(filters: filters, sorts: [sort], fullText: text)
    }
}

private extension SearchService {
        
    func buildFilters(isArchived: Bool, typeIds: [String]) -> [DataviewFilter] {
        [
            SearchHelper.notHiddenFilter(),
            SearchHelper.isArchivedFilter(isArchived: isArchived),
            SearchHelper.typeFilter(typeIds: typeIds)
        ]
    }
    
}
