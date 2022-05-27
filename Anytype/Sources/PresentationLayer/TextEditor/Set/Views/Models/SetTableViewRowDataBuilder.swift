import BlocksModels

final class SetTableViewDataBuilder {
    private let relationsBuilder = RelationsBuilder(scope: [.object, .type])
    
    func sortedRelations(dataview: BlockDataview, view: DataviewView) -> [SetRelation] {
        let relations: [SetRelation] = view.options
            .compactMap { option in
                let metadata = dataview.relations
                    .filter { !$0.isHidden }
                    .first { $0.key == option.key }
                guard let metadata = metadata else { return nil }
                
                return SetRelation(metadata: metadata, option: option)
            }

        return NSOrderedSet(array: relations).array as! [SetRelation]
    }
    
    func rowData(
        _ datails: [ObjectDetails],
        dataView: BlockDataview,
        activeView: DataviewView,
        colums: [RelationMetadata],
        isObjectLocked: Bool
    ) -> [SetTableViewRowData] {
        datails.flatMap { details in
            let metadata = sortedRelations(dataview: dataView, view: activeView)
                .filter { $0.option.isVisible == true }
                .map { $0.metadata }
            let parsedRelations = relationsBuilder
                .parsedRelations(
                    relationMetadatas: metadata,
                    objectId: details.id.value,
                    isObjectLocked: isObjectLocked
                )
                .all
            
            let sortedRelations = colums.compactMap { colum in
                parsedRelations.first { $0.id == colum.key }
            }
            
            let relations: [Relation] = colums.map { colum in
                let relation = sortedRelations.first { $0.id == colum.key }
                guard let relation = relation else {
                    return .unknown(.empty(id: colum.id, name: colum.name))
                }
                
                return relation
            }
            
            let screenData = EditorScreenData(pageId: details.id, type: details.editorViewType)
            
            return SetTableViewRowData(
                id: details.id.value,
                title: details.title,
                icon: details.objectIconImage,
                relations: relations,
                screenData: screenData,
                showIcon: !activeView.hideIcon
            )
        }
    }
}