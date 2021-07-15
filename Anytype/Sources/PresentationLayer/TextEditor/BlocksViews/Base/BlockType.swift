import Foundation
import UIKit

protocol ToolbarInfoProvider {
    var imagePath: String {get}
    var imageName: String {get}
    
    var titlePath: String {get}
    var titleName: String {get}
    
    var subtitlePath: String {get}
    var subtitleName: String {get}
    
    var image: String {get}
    var title: String {get}
    var subtitle: String {get}
}

extension ToolbarInfoProvider {
    var image: String {
        BlockViewType.Resources.Image.image(self.imageName)
    }
    
    var imagePath: String { "" }
    var imageName: String { "" }
    
    var title: String {
        NSLocalizedString(self.titleName, tableName: self.titlePath, bundle: .main, value: "", comment: "")
    }
    
    var titlePath: String { "TextEditor.Toolbar.Blocks.Types.Title" }
    var titleName: String { self.subtitleName }

    var subtitle: String {
        NSLocalizedString(self.subtitleName, tableName: self.subtitlePath, bundle: .main, value: "", comment: "")
    }
    var subtitlePath: String { "TextEditor.Toolbar.Blocks.Types.Subtitle" }
    var subtitleName: String { "" }

    
}

enum BlockViewType: Hashable, Comparable {
    case text(Text), list(List), objects(Objects), tool(Tool), other(Other)
    static var allCases: [Self] = [.text(.text), .list(.bulleted), objects(.bookmark), .other(.lineDivider)]
}

// MARK: Internals
extension BlockViewType {
    enum Text: Hashable, CaseIterable, Comparable {
        case text, h1, h2, h3, highlighted
    }

    enum List: Hashable, CaseIterable, Comparable {
        case checkbox, bulleted, numbered, toggle
    }
    
    enum Objects: Hashable, CaseIterable, Comparable {
        case page, file, picture, video, bookmark, linkToObject
    }

    enum Tool: Hashable, CaseIterable, Comparable {
        case contact, database, set, task
    }

    enum Other: Hashable, CaseIterable, Comparable {
        case lineDivider, dotsDivider, code
    }
}

// MARK: Identifiable
extension BlockViewType: Identifiable {
    var id: String { Resources.Title.title(for: self) }
}

// MARK: Resources
extension BlockViewType {
    typealias BlocksTypes = BlockViewType
    enum Resources {
        struct Color {
            private static let path = "TextEditor/Toolbar/Blocks/New/Types/TypesColors/"
            static func color(for type: BlocksTypes) -> UIColor {
                switch type {
                case .text: return UIColor.init(named: path + "Text") ?? .clear
                case .list: return UIColor.init(named: path + "List") ?? .clear
                case .objects: return UIColor.init(named: path + "Objects") ?? .clear
                case .tool: return UIColor.init(named: path + "Tool") ?? .clear
                case .other: return UIColor.init(named: path + "Other") ?? .clear
                }
            }
        }
        struct Title {
            static func title(for type: BlocksTypes) -> String {
                switch type {
                case .text: return "Text"
                case .list: return "List"
                case .objects: return "Objects"
                case .tool: return "Tool"
                case .other: return "Other"
                }
            }
        }
        struct Image {
            private static let imagesPrefix = "TextEditor/Toolbar/Blocks/New/NewTypes/"
            static func image(_ subpath: String) -> String { imagesPrefix + subpath }
        }
    }
}

extension BlockViewType {
    var title: String { Resources.Title.title(for: self) }
}

// MARK: Protocol Adoption / ToolbarInfoProvider
extension BlockViewType.Text: ToolbarInfoProvider {
    var imageName: String {
        switch self {
        case .text: return "Text/Text"
        case .h1: return "Text/H1"
        case .h2: return "Text/H2"
        case .h3: return "Text/H3"
        case .highlighted: return "Text/Highlighted"
        }
    }
    var subtitleName: String {
        switch self {
        case .text: return "Text.Paragraph"
        case .h1: return "Text.Header1"
        case .h2: return "Text.Header2"
        case .h3: return "Text.Header3"
        case .highlighted: return "Text.Quote"
        }
    }
}

extension BlockViewType.List: ToolbarInfoProvider {
    var imageName: String {
        switch self {
        case .bulleted: return "List/Bulleted"
        case .checkbox: return "List/Checkbox"
        case .numbered: return "List/Numbered"
        case .toggle: return "List/Toggle"
        }
    }
    var subtitleName: String {
        switch self {
        case .bulleted: return "List.Bulleted"
        case .checkbox: return "List.Checkbox"
        case .numbered: return "List.Numbered"
        case .toggle: return "List.Toggle"
        }
    }
}

extension BlockViewType.Objects: ToolbarInfoProvider {
    var imageName: String {
        switch self {
        case .page: return "Objects/Page"
        case .file: return "Objects/File"
        case .picture: return "Objects/Picture"
        case .video: return "Objects/Video"
        case .bookmark: return "Objects/Bookmark"
        case .linkToObject: return "Objects/LinkToObject"
        }
    }
    var subtitleName: String {
        switch self {
        case .page: return "Objects.Page"
        case .file: return "Objects.File"
        case .picture: return "Objects.Picture"
        case .video: return "Objects.Video"
        case .bookmark: return "Objects.Bookmark"
        case .linkToObject: return "Objects.LinkToObject"
        }
    }
}

extension BlockViewType.Tool: ToolbarInfoProvider {
    var imageName: String {
        switch self {
        case .contact: return "Tool/Contact"
        case .database: return "Tool/Database"
        case .set: return "Tool/Set"
        case .task: return "Tool/Task"
        }
    }
    var subtitleName: String {
        switch self {
        case .contact: return "Tool.Contact"
        case .database: return "Tool.Database"
        case .set: return "Tool.Set"
        case .task: return "Tool.Task"
        }
    }
}

extension BlockViewType.Other: ToolbarInfoProvider {
    var imageName: String {
        switch self {
        case .lineDivider: return "Other/LineDivider"
        case .dotsDivider: return "Other/DotsDivider"
        case .code: return "Other/Code"
        }
    }
    var subtitleName: String {
        switch self {
        case .lineDivider: return "Other.LineDivider"
        case .dotsDivider: return "Other.DotsDivider"
        case .code: return "Other.Code"
        }
    }
}

