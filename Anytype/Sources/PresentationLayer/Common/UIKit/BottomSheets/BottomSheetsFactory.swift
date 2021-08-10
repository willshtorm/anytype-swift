import AnytypeCore
import FloatingPanel
import BlocksModels
import UIKit


final class BottomSheetsFactory {
    typealias ActionHandler = (_ action: BlockHandlerActionType) -> Void

    static func createStyleBottomSheet(
        parentViewController: UIViewController,
        delegate: FloatingPanelControllerDelegate,
        information: BlockInformation,
        actionHandler: EditorActionHandlerProtocol,
        didShow: @escaping (FloatingPanelController) -> Void,
        showMarkupMenu: @escaping () -> Void
    ) {
        let fpc = FloatingPanelController()
        fpc.delegate = delegate
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 16.0
        // Define shadows
        let shadow = SurfaceAppearance.Shadow()
        shadow.color = UIColor.grayscale90
        shadow.offset = CGSize(width: 0, height: 4)
        shadow.radius = 40
        shadow.opacity = 0.25
        appearance.shadows = [shadow]

        fpc.surfaceView.layer.cornerCurve = .continuous

        fpc.surfaceView.containerMargins = .init(top: 0, left: 10.0, bottom: parentViewController.view.safeAreaInsets.bottom + 6, right: 10.0)
        fpc.surfaceView.grabberHandleSize = .init(width: 48.0, height: 4.0)
        fpc.surfaceView.grabberHandle.barColor = .grayscale30
        fpc.surfaceView.appearance = appearance
        fpc.isRemovalInteractionEnabled = true
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        fpc.layout = StylePanelLayout()
        fpc.backdropView.backgroundColor = .clear
        fpc.contentMode = .static

        // NOTE: This will be moved to coordinator in next pr
        guard case let .text(textContentType) = information.content.type else { return }

        let askColor: () -> UIColor? = {
            guard case let .text(textContent) = information.content else { return nil }
            return textContent.color?.color(background: false)
        }
        let askBackgroundColor: () -> UIColor? = {
            return information.backgroundColor?.color(background: true)
        }

        let restrictions = BlockRestrictionsFactory().makeRestrictions(for: information.content)

        let contentVC = StyleViewController(
            viewControllerForPresenting: parentViewController,
            style: textContentType,
            restrictions: restrictions,
            askColor: askColor,
            askBackgroundColor: askBackgroundColor,
            didTapMarkupButton: showMarkupMenu
        ) { action in
            actionHandler.handleAction(action, blockId: information.id)
        }
        
        fpc.set(contentViewController: contentVC)
        fpc.addPanel(toParent: parentViewController, animated: true) {
            didShow(fpc)
        }
    }
    
    static func showMarkupBottomSheet(
        parentViewController: UIViewController,
        blockInformation: BlockInformation,
        viewModel: MarkupViewModel
    ) {
        viewModel.blockInformation = blockInformation
        viewModel.setRange(.whole)
        let markupsViewController = MarkupsViewController(viewModel: viewModel)
        viewModel.view = markupsViewController
        
        let fpc = FloatingPanelController(delegate: markupsViewController)
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 16.0
        // Define shadows
        let shadow = SurfaceAppearance.Shadow()
        shadow.color = UIColor.grayscale90
        shadow.offset = CGSize(width: 0, height: 4)
        shadow.radius = 40
        shadow.opacity = 0.25
        appearance.shadows = [shadow]

        let sizeDifference = StylePanelLayout.Constant.panelHeight -  TextAttributesPanelLayout.Constant.panelHeight
        fpc.layout = TextAttributesPanelLayout(additonalHeight: sizeDifference)

        let bottomInset = parentViewController.view.safeAreaInsets.bottom + 6 + sizeDifference
        fpc.surfaceView.containerMargins = .init(top: 0, left: 10.0, bottom: bottomInset, right: 10.0)
        fpc.surfaceView.layer.cornerCurve = .continuous
        fpc.surfaceView.grabberHandleSize = .init(width: 48.0, height: 4.0)
        fpc.surfaceView.grabberHandle.barColor = .grayscale30
        fpc.surfaceView.appearance = appearance
        fpc.isRemovalInteractionEnabled = true
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        fpc.backdropView.backgroundColor = .clear
        fpc.contentMode = .static
        fpc.set(contentViewController: markupsViewController)
        fpc.addPanel(toParent: parentViewController, animated: true)
    }
}
