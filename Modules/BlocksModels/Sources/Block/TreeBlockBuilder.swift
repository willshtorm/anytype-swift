import Foundation
import os

public enum TreeBlockBuilder {
    /// Build blocks tree from middleware model
    /// - Parameters:
    ///   - information: block information model array from which we build tree
    ///   - rootId: block root id (target rootId)
    /// - Returns: Container that represents the tree of blocks
    public static func buildBlocksTree(from information: [BlockInformation], with rootId: BlockId) -> BlockContainerModelProtocol {
        fromList(information: information, isRoot: { $0.information.id == rootId })
    }
    
    // Description
    //
    // Steps
    // 1. create dictionary: ID -> Model
    // 2. check if we have only one root
    // 3. If we have several roots, so, notify about it.
    // 4. find root id as first element in roots. No matter, how much roots we have.
    // 5. Build tree.
    // Note
    //
    // 6 is necessary
    //
    // Observation
    //
    // Consider unsorted (not sorted topologically) blocks.
    // At the end we _may_ don't know if these blocks have correct indices or not.
    // For that case we _should_ rerun building indices in second time after we determine root.
    private static func fromList(information: [BlockInformation], isRoot: (BlockModelProtocol) -> Bool) -> BlockContainerModelProtocol {
        fromList(information.compactMap(BlockModel.init), isRoot: isRoot)
    }

    private static func fromList(_ models: [BlockModelProtocol], isRoot: (BlockModelProtocol) -> Bool) -> BlockContainerModelProtocol {
        // 1. create dictionary: ID -> Model
        let container = BlockContainerBuilder.build(list: models)

        // 2. check if we have only one root
        let roots = models.filter(isRoot)

        guard roots.count != 0 else {
            assertionFailure("Unknown situation. We can't have zero roots.")
            return BlockContainerBuilder.emptyContainer()
        }

        // 3. If we have several roots, so, notify about it.
        if roots.count != 1 {
            // this situation is not possible, but, let handle it.
            assertionFailure("We have several roots for our rootId. Not possible, but let us handle it.")
        }

        // 4. find root id as first element in roots. No matter, how much roots we have.
        // But for now we don't need root id in this container.
        let rootId = roots[0].information.id
        container.rootId = rootId

        // 5. Build tree.
        BlockContainerBuilder.buildTree(container: container, rootId: rootId)

        return container
    }
}
