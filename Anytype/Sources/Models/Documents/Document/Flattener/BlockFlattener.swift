import BlocksModels

/// Input:
/// A -> [B, C, D]
/// B -> [X]
/// C -> [Y]
/// D -> [Z]
///
/// Result: [A, B, X, C, Y, D, Z]
/// It is like a left-order traversing of tree, but we have to output parents first.
///
final class BlockFlattener {
    private let container: BlockContainerModelProtocol
    init(container: BlockContainerModelProtocol) {
        self.container = container
    }
            
    func flatten(model: BlockModelProtocol) -> [BlockModelProtocol] {
        var result = Array<BlockModelProtocol>()
        let stack = Stack<BlockModelProtocol>()
        
        stack.push(model)
        
        while !stack.isEmpty {
            if let model = stack.pop() {
                if model.kind == .block { result.append(model) } // Skip meta blocks
                
                let children = children(model: model)
                
                updateBlockNumberCount(models: children)
                
                for item in children.reversed() {
                    stack.push(item)
                }
            }
        }
        
        return result
    }

    private func children(model: BlockModelProtocol) -> [BlockModelProtocol] {
        if model.information.content.isToggle, UserSession.shared.isToggled(blockId: model.information.id) == false {
            return [] // return no children for closed toggle
        }
        
        return container.children(of: model.information.id)
    }
    
    func updateBlockNumberCount(models: [BlockModelProtocol]) {
        var number: Int = 0
        
        models.forEach { model in
            switch model.information.content {
            case let .text(text) where text.contentType == .numbered:
                number += 1
                var model = model
                model.information.content = .text(text.updated(number: number))
            default:
                number = 0
            }
        }
    }
}
