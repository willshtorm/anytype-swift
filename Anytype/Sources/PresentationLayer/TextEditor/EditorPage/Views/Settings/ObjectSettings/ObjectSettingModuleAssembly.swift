import BlocksModels
import UIKit

protocol ObjectSettingsModuleDelegate: AnyObject {
    func didCreateLinkToItself(selfName: String, in objectId: BlockId)
}

protocol ObjectSettingModuleAssemblyProtocol {
    func make(
        document: BaseDocumentProtocol,
        output: ObjectSettingswModelOutput,
        delegate: ObjectSettingsModuleDelegate
    ) -> UIViewController
}

final class ObjectSettingModuleAssembly: ObjectSettingModuleAssemblyProtocol {
    
    private let serviceLocator: ServiceLocator
    
    init(serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
    }
    
    // MARK: - ObjectSettingModuleAssemblyProtocol
    
    func make(
        document: BaseDocumentProtocol,
        output: ObjectSettingswModelOutput,
        delegate: ObjectSettingsModuleDelegate
    ) -> UIViewController {
        let viewModel = ObjectSettingsViewModel(
            document: document,
            objectDetailsService: serviceLocator.detailsService(objectId: document.objectId),
            output: output,
            delegate: delegate
        )
        let view = ObjectSettingsView(viewModel: viewModel)
        let popup = AnytypePopup(contentView: view, floatingPanelStyle: true)
        viewModel.onDismiss = { [weak popup] in popup?.close() }
        
        return popup
    }
}