import FloatingPanel
import SwiftUI
import ProtobufMessages
import BlocksModels
import AnytypeCore

final class EditorSetViewSettingsViewModel: ObservableObject, AnytypePopupViewModelProtocol {
    weak var popup: AnytypePopupProxy?
    private let setModel: EditorSetViewModel
    private let service: DataviewServiceProtocol
    
    init(setModel: EditorSetViewModel, service: DataviewServiceProtocol) {
        self.setModel = setModel
        self.service = service
    }
    
    func onShowIconChange(_ show: Bool) {
        let newView = setModel.activeView.updated(hideIcon: !show)
        service.updateView(newView)
    }
    
    func onRelationVisibleChange(_ relation: SetRelation, isVisible: Bool) {
        let newOption = relation.option.updated(isVisible: isVisible)
        let newView = setModel.activeView.updated(option: newOption)
        service.updateView(newView)
    }
    
    func deleteRelations(indexes: IndexSet) {
        indexes.forEach { index in
            guard let relation = setModel.sortedRelations[safe: index] else {
                anytypeAssertionFailure("No relation to delete at index: \(index)", domain: .dataviewService)
                return
            }
            service.deleteRelation(key: relation.metadata.key)
        }
    }
    
    func moveRelation(from: IndexSet, to: Int) {
        from.forEach { sortedRelationsFromIndex in
            guard sortedRelationsFromIndex != to else { return }
            
            let relationFrom = setModel.sortedRelations[sortedRelationsFromIndex]
            let sortedRelationsToIndex = to > sortedRelationsFromIndex ? to - 1 : to // map insert index to item index
            let relationTo = setModel.sortedRelations[sortedRelationsToIndex]
            
            // index in all options array (includes hidden options)
            guard let indexFrom = setModel.activeView.options.index(of: relationFrom) else {
                anytypeAssertionFailure("No relation for move: \(relationFrom)", domain: .dataviewService)
                return
            }
            guard let indexTo = setModel.activeView.options.index(of: relationTo) else {
                anytypeAssertionFailure("No relation for move: \(relationTo)", domain: .dataviewService)
                return
            }
            
            var newOptions = setModel.activeView.options
            newOptions.moveElement(from: indexFrom, to: indexTo)
            let newView = setModel.activeView.updated(options: newOptions)
            service.updateView(newView)
        }
    }
    
    func showAddNewRelationView() {
        setModel.showAddNewRelationView { [weak self] relation, isNew in
            guard let self = self else { return }
            
            if self.service.addRelation(relation) {
                let newOption = DataviewRelationOption(key: relation.key, isVisible: true)
                let newView = self.setModel.activeView.updated(option: newOption)
                self.service.updateView(newView)
            }
            AnytypeAnalytics.instance().logAddRelation(format: relation.format, isNew: isNew, type: .set)
        }
    }
    
    // MARK: - AnytypePopupViewModelProtocol
    var popupLayout: AnytypePopupLayoutType {
        .fullScreen
    }
    
    func onPopupInstall(_ popup: AnytypePopupProxy) {
        self.popup = popup
    }
    
    func makeContentView() -> UIViewController {
        UIHostingController(
            rootView: EditorSetViewSettingsView()
                .environmentObject(self)
                .environmentObject(setModel)
        )
    }
}