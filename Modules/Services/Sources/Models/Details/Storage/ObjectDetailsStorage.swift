import Foundation
import AnytypeCore
import SwiftProtobuf
import ProtobufMessages
import Combine

public final class ObjectDetailsStorage {
    
    private var storage = SynchronizedDictionary<BlockId, ObjectDetails>()
    
    public init() {}
        
    public func get(id: BlockId) -> ObjectDetails? {
        guard id.isValidId else { return nil }
        return storage[id]
    }
    
    public func add(details: ObjectDetails) {
        storage[details.id] = details
    }
    
    public func set(data: Anytype_Event.Object.Details.Set) -> ObjectDetails? {
        guard data.hasDetails else {
            anytypeAssertionFailure("No details in Object.Details.Set")
            return nil
        }
        let id = data.id
        guard id.isValidId else {
            anytypeAssertionFailure("Id is empty in details", info: ["id": id])
            return nil
        }
        
        let currentDetails = get(id: id) ?? ObjectDetails(id: id)
        let updatedDetails = currentDetails.updated(by: data.details.fields)
        
        add(details: updatedDetails)
        
        return updatedDetails
    }
    
    public func unset(data: Anytype_Event.Object.Details.Unset) -> ObjectDetails? {
        let id = data.id
        guard id.isValidId else {
            anytypeAssertionFailure("Id is empty in details", info: ["id": id])
            return nil
        }
        
        guard let currentDetails = get(id: id) else {
            return nil
        }
        
        let updatedDetails = currentDetails.removed(keys: data.keys)
        add(details: updatedDetails)
        
        return updatedDetails
    }
    
    public func amend(data: Anytype_Event.Object.Details.Amend) -> ObjectDetails? {
        let id = data.id
        guard id.isValidId else { return nil }
        
        return amend(id: id, values: data.details.asDetailsDictionary)
    }
    
    @discardableResult
    public func amend(details: ObjectDetails) -> ObjectDetails {
        return amend(id: details.id, values: details.values)
    }
    
    public func amend(id: BlockId, values: [String: Google_Protobuf_Value]) -> ObjectDetails {
        let currentDetails = get(id: id) ?? ObjectDetails(id: id)
        let updatedDetails = currentDetails.updated(by: values)
        add(details: updatedDetails)
        return updatedDetails
    }
}
