import ProtobufMessages
import SwiftProtobuf
import BlocksModels

final class PageService {
    func createPage(name: String) -> BlockId? {
        let details = Google_Protobuf_Struct(
            fields: [
                BundledRelationKey.name.rawValue: name.protobufValue,
                BundledRelationKey.type.rawValue: ObjectTypeProvider.shared.defaultObjectType.id.protobufValue
            ]
        )
        
        guard let response = Anytype_Rpc.Object.Create.Service.invoke(details: details, internalFlags: [], templateID: "")
            .getValue(domain: .pageService) else {
            return nil
        }
        
        EventsBunch(event: response.event).send()
        return response.objectID
    }
}
