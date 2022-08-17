import Foundation
import UIKit

//@see https://www.figma.com/file/3lljgCRXYLiUeefJSxN1aC/Components?node-id=123%3A981
enum ObjectIconImageUsecase: Equatable {
    case openedObject
    case openedObjectNavigationBar
    
    case editorSearch // slash menu + mention
    case editorSearchExpandedIcons
    case editorCalloutBlock
    
    case dashboardList
    case dashboardProfile
    case dashboardSearch
    case mention(ObjectIconImageMentionType)
    case editorAccessorySearch
    
    case featuredRelationsBlock
    
    case setRow
    case setGallery
}

extension ObjectIconImageUsecase {
    var profileBackgroundColor: UIColor {
        switch self {
        case .openedObject: return .strokePrimary
        default: return .strokeSecondary
        }
    }
    
    var placeholderBackgroundColor: UIColor {
        .strokeTransperent
    }
    
    var emojiBackgroundColor: UIColor {
        switch self {
        case .openedObjectNavigationBar, .mention, .setRow, .featuredRelationsBlock, .editorCalloutBlock:
            return .clear
        default:
            return .strokeTransperent
        }
    }
}
