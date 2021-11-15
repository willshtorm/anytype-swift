import Foundation
import Combine
import BlocksModels
import ProtobufMessages
import Amplitude
import AnytypeCore
import BlocksModels

// MARK: Actions
final class BlockActionsServiceSingle: BlockActionsServiceSingleProtocol {    
    func open(contextId: BlockId, blockId: BlockId) -> MiddlewareResponse? {
        Anytype_Rpc.Block.Open.Service.invoke(contextID: contextId, blockID: blockId, traceID: "")
            .map { MiddlewareResponse($0.event) }
            .getValue()
    }
    
    func close(contextId: BlockId, blockId: BlockId) {
        _ = Anytype_Rpc.Block.Close.Service.invoke(contextID: contextId, blockID: blockId)
    }
    
    // MARK: Create (OR Add) / Replace / Unlink ( OR Delete )
    func add(contextId: BlockId, targetId: BlockId, info: BlockInformation, position: BlockPosition) -> MiddlewareResponse? {
        guard let blockInformation = BlockInformationConverter.convert(information: info) else {
            anytypeAssertionFailure("addActionBlockIsNotParsed")
            return nil
        }

        Amplitude.instance().logEvent(AmplitudeEventsName.blockCreate)
        return Anytype_Rpc.Block.Create.Service.invoke(contextID: contextId, targetID: targetId, block: blockInformation, position: position.asMiddleware)
            .map { MiddlewareResponse($0.event) }
            .getValue()
    }

    func replace(contextId: BlockId, blockId: BlockId, info: BlockInformation) -> MiddlewareResponse? {
        guard let block = BlockInformationConverter.convert(information: info) else {
            anytypeAssertionFailure("replace action parsing error")
            return nil
        }
        
        return Anytype_Rpc.Block.Replace.Service
            .invoke(contextID: contextId, blockID: blockId, block: block)
            .map { MiddlewareResponse($0.event) }
            .getValue()
    }
    
    func delete(contextId: BlockId, blockIds: [BlockId]) -> Bool {
        Amplitude.instance().logEvent(AmplitudeEventsName.blockUnlink)
        let event = Anytype_Rpc.Block.Unlink.Service.invoke(contextID: contextId, blockIds: blockIds)
            .map { EventsBunch(event: $0.event) }
            .getValue()
        
        guard let event = event else { return false }
        event.send()
        
        return true
    }

    func duplicate(contextId: BlockId, targetId: BlockId, blockIds: [BlockId], position: BlockPosition) -> MiddlewareResponse? {
        Amplitude.instance().logEvent(AmplitudeEventsName.blockListDuplicate)
        
        return Anytype_Rpc.BlockList.Duplicate.Service
            .invoke(contextID: contextId, targetID: targetId, blockIds: blockIds, position: position.asMiddleware)
            .map { MiddlewareResponse($0.event) }
            .getValue()
    }
}