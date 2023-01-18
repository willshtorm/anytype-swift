import Foundation
import ProtobufMessages

public struct RelationLink: Hashable {
    public let key: String
}

public extension RelationLink {
    
    init(middlewareRelationLink: Anytype_Model_RelationLink) {
        self.key = middlewareRelationLink.key
    }
    
    var asMiddleware: Anytype_Model_RelationLink {
        return Anytype_Model_RelationLink(key: key)
    }
}
