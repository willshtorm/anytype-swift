import BlocksModels

extension DataviewGroup {    
    func filter(with relationKey: String) -> DataviewFilter? {
        switch value {
        case .tag(let tag):
            return DataviewFilter(
                relationKey: relationKey,
                condition: tag.ids.isEmpty ? .empty : .exactIn,
                value: tag.ids.protobufValue
            )
        case .status(let status):
            return DataviewFilter(
                relationKey: relationKey,
                condition: status.id.isEmpty ? .empty : .equal,
                value: status.id.protobufValue
            )
        case .checkbox(let checkbox):
            return DataviewFilter(
                relationKey: relationKey,
                condition: .equal,
                value: checkbox.checked.protobufValue
            )
        default:
            return nil
        }
    }
    
    var backgroundColor: BlockBackgroundColor? {
        switch value {
        case .tag(let tag):
            guard let firstTagId = tag.ids.first,
                    let details = ObjectDetailsStorage.shared.get(id: firstTagId) else { return nil }
            return MiddlewareColor(rawValue: details.relationOptionColor)?.backgroundColor
        case .status(let status):
            guard let details = ObjectDetailsStorage.shared.get(id: status.id) else { return nil }
            return MiddlewareColor(rawValue: details.relationOptionColor)?.backgroundColor
        default:
            return nil
        }
    }
    
    func header(with groupRelationKey: String) -> SetKanbanColumnHeaderType {
        switch value {
        case .tag(let tag):
            let tags = tag.ids
                .compactMap { ObjectDetailsStorage.shared.get(id: $0) }
                .map { RelationOption(details: $0) }
                .map { Relation.Tag.Option(option: $0) }
            return tags.isEmpty ? .uncategorized : .tag(tags)
        case .status(let status):
            guard let optionDetails = ObjectDetailsStorage.shared.get(id: status.id) else {
                return .uncategorized
            }
            let option = RelationOption(details: optionDetails)
            return .status([Relation.Status.Option(option: option)])
        case .checkbox(let checkbox):
            return .checkbox(title: groupRelationKey.capitalized, isChecked: checkbox.checked)
        default:
            return .uncategorized
        }
    }
}
