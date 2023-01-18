import Foundation

struct FilesOptionsSearchModuleBuilder: RelationOptionsSearchModuleBuilderProtocol {
    
    private let newSearcModuleAssembly: NewSearchModuleAssemblyProtocol
    
    init(newSearcModuleAssembly: NewSearchModuleAssemblyProtocol) {
        self.newSearcModuleAssembly = newSearcModuleAssembly
    }
    
    // MARK: - RelationOptionsSearchModuleBuilderProtocol
    
    func buildModule(
        excludedOptionIds: [String],
        onSelect: @escaping ([String]) -> Void,
        onCreate _ : @escaping (String) -> Void
    ) -> NewSearchView {
        newSearcModuleAssembly.filesSearchModule(
            excludedFileIds: excludedOptionIds,
            onSelect: onSelect
        )
    }
    
}
