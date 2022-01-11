import Foundation
import UIKit
import Combine
import BlocksModels

struct HomeCellData: Identifiable {
    let id: String
    let destinationId: String
    let icon: ObjectIconType?
    let title: Title
    let type: String
    let isLoading: Bool
    let isArchived: Bool
    let isDeleted: Bool
    let viewType: EditorViewType
    
    static func create(details: ObjectDetails) -> HomeCellData {
        HomeCellData(
            id: details.id,
            destinationId: details.id,
            icon: details.icon,
            title: details.pageCellTitle,
            type: details.objectType.name,
            isLoading: false,
            isArchived: details.isArchived,
            isDeleted: details.isDeleted,
            viewType: details.editorViewType
        )
    }
}

extension HomeCellData {
    
    enum Title {
        case `default`(title: String)
        case todo(title: String, isChecked: Bool)
        
        var isTodo: Bool {
            switch self {
            case .todo:
                return true
            default:
                return false
            }
        }
    }
    
}
