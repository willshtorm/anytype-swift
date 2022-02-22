import XCTest
@testable import Anytype
@testable import BlocksModels

class KeyboardActionHandlerTests: XCTestCase {
    private var handler: KeyboardActionHandler!
    private var service: BlockActionServiceMock!
    private var toggleStorage: ToggleStorage!

    override func setUpWithError() throws {
        service = BlockActionServiceMock()
        toggleStorage = ToggleStorage()
        handler = KeyboardActionHandler(service: service, toggleStorage: toggleStorage)
    }

    override func tearDownWithError() throws {
        service = nil
        handler = nil
        toggleStorage = nil
    }

    func test_enterInside() throws {
        let info = info()
        service.splitStub = true
        
        handler.handle(info: info, action: .enterInside(string: .init(string: ""), position: 0))
        
        XCTAssertEqual(service.splitNumberOfCalls, 1)
    }
    
    private func info() -> BlockInformation {
        BlockInformation(
            id: "id",
            content: .text(.empty(contentType: .text)),
            backgroundColor: nil,
            alignment: .center,
            childrenIds: [],
            fields: [:]
        )
    }
}
