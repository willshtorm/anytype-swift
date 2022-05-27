import ProtobufMessages
import SwiftProtobuf
import BlocksModels

class SearchHelper {
    static func sort(relation: BundledRelationKey, type: DataviewSort.TypeEnum) -> DataviewSort {
        var sort = DataviewSort()
        sort.relationKey = relation.rawValue
        sort.type = type
        
        return sort
    }
    
    static func isArchivedFilter(isArchived: Bool) -> DataviewFilter {
        var filter = DataviewFilter()
        filter.condition = .equal
        filter.value = isArchived.protobufValue
        filter.relationKey = BundledRelationKey.isArchived.rawValue
        filter.operator = .and
        
        return filter
    }
    
    static func isDeletedFilter(isDeleted: Bool) -> DataviewFilter {
        var filter = DataviewFilter()
        filter.condition = .equal
        filter.value = isDeleted.protobufValue
        filter.relationKey = BundledRelationKey.isDeleted.rawValue
        filter.operator = .and
        
        return filter
    }
    
    static func notHiddenFilter() -> DataviewFilter {
        var filter = DataviewFilter()
        filter.condition = .equal
        filter.value = false.protobufValue
        filter.relationKey = BundledRelationKey.isHidden.rawValue
        filter.operator = .and
        
        return filter
    }
    
    static func lastOpenedDateNotNilFilter() -> DataviewFilter {
        var filter = DataviewFilter()
        filter.condition = .notEmpty
        filter.value = nil
        filter.relationKey = BundledRelationKey.lastOpenedDate.rawValue
        filter.operator = .and
        
        return filter
    }
    
    static func typeFilter(typeUrls: [String]) -> DataviewFilter {
        var filter = DataviewFilter()
        filter.condition = .in
        filter.value = typeUrls.protobufValue
        filter.relationKey = BundledRelationKey.type.rawValue
        filter.operator = .and
        
        return filter
    }
    
    static func layoutFilter(layouts: [Int]) -> DataviewFilter {
        var filter = DataviewFilter()
        filter.condition = .in
        filter.value = layouts.protobufValue
        filter.relationKey = BundledRelationKey.layout.rawValue
        filter.operator = .and
        
        return filter
    }
    
    static func supportedObjectTypeUrlsFilter(_ typeUrls: [String]) -> DataviewFilter {
        var filter = DataviewFilter()
        filter.condition = .in
        filter.value = typeUrls.protobufValue
        filter.relationKey = BundledRelationKey.id.rawValue
        filter.operator = .and
        
        return filter
    }
    
    static func sharedObjectsFilters() -> [DataviewFilter] {
        var workspaceFilter = DataviewFilter()
        workspaceFilter.condition = .notEmpty
        workspaceFilter.value = nil
        workspaceFilter.relationKey = BundledRelationKey.workspaceId.rawValue
        workspaceFilter.operator = .and
   
        var highlightedFilter = DataviewFilter()
        highlightedFilter.condition = .equal
        highlightedFilter.value = true
        highlightedFilter.relationKey = BundledRelationKey.isHighlighted.rawValue
        highlightedFilter.operator = .and
        
        return [
            workspaceFilter,
            highlightedFilter
        ]
    }
    
    static func excludedObjectTypeUrlFilter(_ typeUrl: String) -> DataviewFilter {
        var filter = DataviewFilter()
        filter.condition = .notEqual
        filter.value = typeUrl.protobufValue
        
        filter.relationKey = BundledRelationKey.id.rawValue
        filter.operator = .and
        
        return filter
    }
    
    static func excludedIdsFilter(_ ids: [String]) -> DataviewFilter {
        var filter = DataviewFilter()
        filter.condition = .notIn
        filter.value = ids.protobufValue
        
        filter.relationKey = BundledRelationKey.id.rawValue
        filter.operator = .and
        
        return filter
    }
    
}