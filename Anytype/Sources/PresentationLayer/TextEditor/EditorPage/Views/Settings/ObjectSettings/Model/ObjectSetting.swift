import SwiftUI

enum ObjectSetting: CaseIterable {
    case icon
    case cover
    case layout
    case relations

    static var lockedEditingCases: [ObjectSetting] { [.relations] }
}

extension ObjectSetting {
    
    var title: String {
        switch self {
        case .icon:
            return Loc.icon
        case .cover:
            return Loc.cover
        case .layout:
            return Loc.layout
        case .relations:
            return Loc.relations
        }
    }
    
    var description: String {
        switch self {
        case .icon:
            return Loc.emojiOrImageForObject
        case .cover:
            return Loc.backgroundPicture
        case .layout:
            return Loc.arrangementOfObjectsOnACanvas
        case .relations:
            return Loc.listOfRelatedObjects
        }
    }
    
    var imageAsset: ImageAsset {
        switch self {
        case .icon:
            return .objectSettingsIcon
        case .cover:
            return .objectSettingsCover
        case .layout:
            return .objectSettingsLayout
        case .relations:
            return .objectSettingsRelations
        }
    }
}