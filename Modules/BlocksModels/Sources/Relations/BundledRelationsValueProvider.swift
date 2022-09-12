import Foundation
import AnytypeCore
import SwiftProtobuf
import ProtobufMessages

public protocol BundledRelationsValueProvider {
    
    var values: [String: Google_Protobuf_Value] { get }
    
    var id: BlockId { get }
    var name: String { get }
    var snippet: String { get }
    var iconEmoji: String { get }
    var iconImageHash: Hash? { get }
    var coverId: String { get }
    var coverType: CoverType { get }
    var isArchived: Bool { get }
    var isFavorite: Bool { get }
    var isReadonly: Bool { get }
    var isHidden: Bool { get }
    var description: String { get }
    var layout: DetailsLayout { get }
    var layoutAlign: LayoutAlignment { get }
    var isDone: Bool { get }
    var type: String { get }
    var isDeleted: Bool { get }
    var featuredRelations: [String] { get }
    var isSelectType: Bool { get }
    var isSelectTemplate: Bool { get }
    var url: String { get }
    var picture: String { get }
    var smartblockTypes: [SmartBlockType] { get }
    var relationOptionText: String { get }
    var relationOptionColor: String { get }
    var relationKey: String { get }
    var relationFormat: RelationFormat { get }
    var readonlyValue: Bool { get }
    var relationFormatObjectTypes: [String] { get }
}


public extension BundledRelationsValueProvider {
    
    var name: String {
        stringValue(with: .name)
    }

    var snippet: String {
        stringValue(with: .snippet).replacedNewlinesWithSpaces
    }
    
    var iconEmoji: String {
        stringValue(with: .iconEmoji)
    }
    
    var iconImageHash: Hash? {
        guard let value = values[BundledRelationKey.iconImage.rawValue] else { return nil }
        return Hash(value.unwrapedListValue.stringValue)
    }
    
    var coverId: String {
        stringValue(with: .coverId)
    }
    
    var coverType: CoverType {
        guard
            let value = values[BundledRelationKey.coverType.rawValue],
            let number = value.unwrapedListValue.safeIntValue,
            let coverType = CoverType(rawValue: number)
        else { return .none }
        
        return coverType
    }
    
    var isArchived: Bool {
        boolValue(with: .isArchived)
    }
    
    var isFavorite: Bool {
        boolValue(with: .isFavorite)
    }
    
    var isReadonly: Bool {
        boolValue(with: .isReadonly)
    }
    
    var isHidden: Bool {
        boolValue(with: .isHidden)
    }
    
    var description: String {
        stringValue(with: .description)
    }
    
    var layout: DetailsLayout {
        guard
            let value = values[BundledRelationKey.layout.rawValue],
            let number = value.unwrapedListValue.safeIntValue,
            let layout = DetailsLayout(rawValue: number)
        else {
            return .basic
        }
        
        if layout == .bookmark && !FeatureFlags.bookmarksFlowP2 {
            return .basic
        }
        
        return layout
    }
    
    var layoutAlign: LayoutAlignment {
        guard
            let value = values[BundledRelationKey.layoutAlign.rawValue],
            let number = value.unwrapedListValue.safeIntValue,
            let layout = LayoutAlignment(rawValue: number)
        else {
            return .left
        }
        return layout
    }
    
    var isDone: Bool {
        boolValue(with: .done)
    }
    
    var type: String {
        stringValue(with: .type)
    }
    
    var isDeleted: Bool {
        boolValue(with: .isDeleted)
    }
    
    var featuredRelations: [String] {
        guard let value = values[BundledRelationKey.featuredRelations.rawValue] else { return [] }
        
        let ids: [String] = value.listValue.values.compactMap {
            let value = $0.stringValue
            guard value.isNotEmpty else { return nil }
            return value
        }
        
        return ids
    }
    
    var isSelectType: Bool {
        return internalFlag(with: .editorSelectType)
    }
    
    var isSelectTemplate: Bool {
        return internalFlag(with: .editorSelectTemplate)
    }
    
    var url: String {
        stringValue(with: .url)
    }
    
    var picture: String {
        stringValue(with: .picture)
    }
    
    var smartblockTypes: [SmartBlockType] {
        guard let value = values[BundledRelationKey.smartblockTypes.rawValue] else { return [] }
        let rawValues = value.listValue.values
        return rawValues
            .compactMap { $0.safeIntValue }
            .compactMap { Anytype_Model_SmartBlockType(rawValue: $0) }
            .map { SmartBlockType(smartBlockType: $0) }
    }
    
    var relationOptionText: String {
        stringValue(with: .relationOptionText)
    }
    
    var relationOptionColor: String {
        stringValue(with: .relationOptionColor)
    }
    
    var relationKey: String {
        stringValue(with: .relationKey)
    }
    
    var relationFormat: RelationFormat {
        values[BundledRelationKey.relationFormat.rawValue]?
            .safeIntValue.map { RelationFormat(rawValue: $0) } ?? .unrecognized
    }
    
    var readonlyValue: Bool {
        boolValue(with: .readonlyValue)
    }
    
    var relationFormatObjectTypes: [String] {
        values[BundledRelationKey.relationFormatObjectTypes.rawValue]?.listValue.values.map { $0.stringValue } ?? []
    }
    
    // MARK: - Private
    
    private func stringValue(with key: BundledRelationKey) -> String {
        guard let value = values[key.rawValue] else { return "" }
        return value.unwrapedListValue.stringValue
    }
    
    private func boolValue(with key: BundledRelationKey) -> Bool {
        guard let value = values[key.rawValue] else { return false }
        return value.unwrapedListValue.boolValue
    }
    
    private func internalFlag(with flag: Anytype_Model_InternalFlag.Value) -> Bool {
        guard let value = values[BundledRelationKey.internalFlags.rawValue] else { return false }
        let rawValues = value.listValue.values
        let internalFlags = rawValues
            .compactMap { $0.safeIntValue }
            .compactMap { Anytype_Model_InternalFlag.Value(rawValue: $0) }
        return internalFlags.contains(flag)
    }
}
