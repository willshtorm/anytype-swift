import Foundation
import BlocksModels
import CoreImage

extension RelationValue {
    
    struct Unknown: RelationValueProtocol, Hashable, Identifiable {
        let id: String
        let key: String
        let name: String
        let isFeatured: Bool
        let isEditable: Bool
        let isBundled: Bool
        
        let value: String
        
        var hasValue: Bool {
            value.isNotEmpty
        }
        
        static func empty(id: String, key: String, name: String) -> Unknown {
            Unknown(id: id, key: key, name: name, isFeatured: false, isEditable: false, isBundled: false, value: "")
        }
    }
    
}
