import Foundation
import BlocksModels

protocol ObjectTypeProviderProtocol: AnyObject {

    var objectTypes: [ObjectType] { get }
    var defaultObjectType: ObjectType { get }
    func setDefaulObjectType(type: ObjectType)
    
    func isSupportedForEdit(typeId: String) -> Bool
    func objectType(id: String) -> ObjectType?
    func deleteObjectType(id: String) -> ObjectType
    
    func objectTypes(smartblockTypes: Set<SmartBlockType>) -> [ObjectType]
    func notVisibleTypeIds() -> [String]
    
    func startSubscription()
    func stopSubscription()
}