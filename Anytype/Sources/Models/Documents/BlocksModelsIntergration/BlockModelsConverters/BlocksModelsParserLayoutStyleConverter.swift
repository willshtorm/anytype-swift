import Foundation
import BlocksModels
import ProtobufMessages

final class BlocksModelsParserLayoutStyleConverter {
    typealias MiddlewareModel = Anytype_Model_Block.Content.Layout.Style
    
    static func asModel(_ value: MiddlewareModel) -> BlockLayout.Style? {
        switch value {
        case .row: return .row
        case .column: return .column
        case .div: return .div
        case .header: return .header
        default: return nil
        }
    }
    
    static func asMiddleware(_ value: BlockLayout.Style) -> MiddlewareModel {
        switch value {
        case .row: return .row
        case .column: return .column
        case .div: return .div
        case .header: return .header
        }
    }
}