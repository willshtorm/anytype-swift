import Services

extension Relation {
    
    struct Text: RelationProtocol, Hashable, Identifiable {
        let id: String
        let key: String
        let name: String
        let isFeatured: Bool
        let isEditable: Bool
        let isSystem: Bool
        let isDeleted: Bool
        let isDeletedValue: Bool
        
        let value: String?
        
        init(
            id: String,
            key: String,
            name: String,
            isFeatured: Bool,
            isEditable: Bool, 
            isSystem: Bool,
            isDeleted: Bool,
            isDeletedValue: Bool = false,
            value: String?
        ) {
            self.id = id
            self.key = key
            self.name = name
            self.isFeatured = isFeatured
            self.isEditable = isEditable
            self.isSystem = isSystem
            self.isDeleted = isDeleted
            self.isDeletedValue = isDeletedValue
            self.value = value
        }
        
        var hasValue: Bool {
            value?.isNotEmpty ?? false
        }
    }
    
}
