import Foundation
import SwiftUI

extension Relation {
    
    struct Object: RelationProtocol, Hashable, Identifiable {
        let id: String
        let name: String
        let isFeatured: Bool
        let isEditable: Bool
        let isBundled: Bool
        
        let selectedObjects: [Option]
    }
    
}

extension Relation.Object {

    struct Option: Hashable, Identifiable, RelationOptionProtocol {
        let id: String
        
        let icon: ObjectIconImage
        let title: String
        let type: String
        
        func makeView() -> AnyView {
            AnyView(RelationObjectsRowView(object: self))
        }
    }
    
}