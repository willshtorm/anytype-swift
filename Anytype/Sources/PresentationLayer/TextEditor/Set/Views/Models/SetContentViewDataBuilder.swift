import BlocksModels
import Foundation
import AnytypeCore
import SwiftProtobuf

final class SetContentViewDataBuilder {
    private let relationsBuilder = RelationsBuilder()
    private let storage = ObjectDetailsStorage.shared
    private let relationDetailsStorage = ServiceLocator.shared.relationDetailsStorage()
    
    func sortedRelations(dataview: BlockDataview, view: DataviewView) -> [SetRelation] {
        let relations: [SetRelation] = view.options
            .compactMap { option in
                let relationsDetails = relationDetailsStorage.relationsDetails(for: dataview.relationLinks)
                    .filter { !$0.isHidden && !$0.isDeleted }
                    .first { $0.key == option.key }
                guard let relationsDetails = relationsDetails else { return nil }
                
                return SetRelation(relationDetails: relationsDetails, option: option)
            }

        return NSOrderedSet(array: relations).array as! [SetRelation]
    }
    
    func activeViewRelations(
        dataViewRelationsDetails: [RelationDetails],
        view: DataviewView,
        excludeRelations: [RelationDetails]
    ) -> [RelationDetails] {
        view.options.compactMap { option in
            let relationDetails = dataViewRelationsDetails.first { relation in
                option.key == relation.key
            }
            
            guard let relationDetails = relationDetails,
                  shouldAddRelationDetails(relationDetails, excludeRelations: excludeRelations) else { return nil }
            
            return relationDetails
        }
    }
    
    func itemData(
        _ details: [ObjectDetails],
        dataView: BlockDataview,
        activeView: DataviewView,
        isObjectLocked: Bool,
        onIconTap: @escaping (ObjectDetails) -> Void,
        onItemTap: @escaping (ObjectDetails) -> Void
    ) -> [SetContentViewItemConfiguration] {
        
        let relationsDetails = sortedRelations(
            dataview: dataView,
            view: activeView
        ).filter { $0.option.isVisible }.map(\.relationDetails)

        return details.compactMap { details in
            let parsedRelations = relationsBuilder
                .parsedRelations(
                    relationsDetails: relationsDetails,
                    objectId: details.id,
                    isObjectLocked: isObjectLocked
                )
                .installed
            let sortedRelations = relationsDetails.compactMap { colum in
                parsedRelations.first { $0.key == colum.key }
            }
            
            let relations: [Relation] = relationsDetails.map { colum in
                let relation = sortedRelations.first { $0.key == colum.key }
                guard let relation = relation else {
                    return .unknown(.empty(id: colum.id, key: colum.key, name: colum.name))
                }
                
                return relation
            }
            
            let hasCover = activeView.coverRelationKey.isNotEmpty && activeView.type != .kanban
            
            return SetContentViewItemConfiguration(
                id: details.id,
                title: details.title,
                description: details.description,
                icon: details.objectIconImage,
                relations: relations,
                showIcon: !activeView.hideIcon,
                smallItemSize: activeView.cardSize == .small,
                hasCover: hasCover,
                coverFit: activeView.coverFit,
                coverType: coverType(details, dataView: dataView, activeView: activeView),
                onIconTap: {
                    onIconTap(details)
                },
                onItemTap: {
                    onItemTap(details)
                }
            )
        }
    }
    
    private func coverType(
        _ details: ObjectDetails,
        dataView: BlockDataview,
        activeView: DataviewView) -> ObjectHeaderCoverType?
    {
        guard activeView.type == .gallery else {
            return nil
        }
        if activeView.coverRelationKey == SetViewSettingsImagePreviewCover.pageCover.rawValue,
           let documentCover = details.documentCover {
            return .cover(documentCover)
        } else {
            return relationCoverType(details, dataView: dataView, activeView: activeView)
        }
    }
    
    private func relationCoverType(
        _ details: ObjectDetails,
        dataView: BlockDataview,
        activeView: DataviewView) -> ObjectHeaderCoverType?
    {
        let relationDetails = relationDetailsStorage.relationsDetails(for: dataView.relationLinks)
            .first { $0.format == .file && $0.key == activeView.coverRelationKey }
        
        guard let relationDetails = relationDetails else {
            return nil
        }

        let values = details.stringValueOrArray(for: relationDetails)
        return findCover(at: values, details)
    }

    private func findCover(at values: [String], _ details: ObjectDetails) -> ObjectHeaderCoverType? {
        for value in values {
            let details = storage.get(id: value)
            if let details = details, details.type == Constants.imageType {
                return .cover(.imageId(details.id))
            }
        }
        return nil
    }
    
    private func shouldAddRelationDetails(_ relationDetails: RelationDetails, excludeRelations: [RelationDetails]) -> Bool {
        guard excludeRelations.first(where: { $0.key == relationDetails.key }) == nil else {
            return false
        }
        guard relationDetails.key != ExceptionalSetSort.name.rawValue,
              relationDetails.key != ExceptionalSetSort.done.rawValue else {
            return true
        }
        return !relationDetails.isHidden &&
        relationDetails.format != .file &&
        relationDetails.format != .unrecognized
    }
}

extension SetContentViewDataBuilder {
    enum Constants {
        static let imageType = "_otimage"
    }
}