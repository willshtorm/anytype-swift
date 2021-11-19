public enum DataviewViewType: Hashable {
    case table
    case list
    case gallery
    case kanban
}

public struct DataviewViewRelation: Hashable {
    public let key: String
    public let isVisible: Bool
    
    public init(key: String, isVisible: Bool) {
        self.key = key
        self.isVisible = isVisible
    }
}

public struct DataviewView: Hashable {
    public let id: BlockId
    public let name: String

    public let type: DataviewViewType
    
    public let relations: [DataviewViewRelation]

    public init(
        id: BlockId,
        name: String,
        type: DataviewViewType,
        relations: [DataviewViewRelation]
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.relations = relations
    }
}


public struct BlockDataview: Hashable {
    public let source: [String]
    public let activeViewId: BlockId
    public let views: [DataviewView]
    public let relations: [RelationMetadata]
    
    public var activeView: DataviewView? {
        views.first { $0.id == activeViewId } ?? views.first
    }
    
    public init(
        source: [String],
        activeView: BlockId,
        views: [DataviewView],
        relations: [RelationMetadata]
    ) {
        self.source = source
        self.activeViewId = activeView
        self.views = views
        self.relations = relations
    }
}
