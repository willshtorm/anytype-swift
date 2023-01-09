import Foundation

protocol HomeWidgetProviderAssemblyProtocol: AnyObject {
    func make(widgetBlockId: String, widgetObject: HomeWidgetsObjectProtocol) -> HomeWidgetProviderProtocol
}
