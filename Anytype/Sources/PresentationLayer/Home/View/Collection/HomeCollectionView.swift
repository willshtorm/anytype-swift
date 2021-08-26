import SwiftUI
import UniformTypeIdentifiers


struct HomeCollectionView: View {
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var cellData: [HomeCellData]
    let coordinator: HomeCoordinator
    let dragAndDropDelegate: DragAndDropDelegate?
    let offsetChanged: (CGPoint) -> Void
    
    @State private var dropData = DropData()
    
    var body: some View {
        OffsetAwareScrollView(showsIndicators: false, offsetChanged: offsetChanged) {
            LazyVGrid(columns: columns) {
                ForEach(cellData) { data in
                    NavigationLink(
                        destination: coordinator.documentView(
                            selectedDocumentId: data.destinationId
                        ),
                        label: {
                            HomeCell(cellData: data)
                                .cornerRadius(16)
                                .frame(idealHeight: 124)
                        }
                    )
                    .disabled(data.isLoading)
                    
                    .ifLet(dragAndDropDelegate) { view, delegate in
                        view.onDrag {
                            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                            dropData.draggingCellData = data
                            return NSItemProvider(object: data.id as NSString)
                        }
                        .onDrop(
                            of: [UTType.text],
                            delegate: HomeCollectionDropInsideDelegate(dragAndDropDelegate: delegate, delegateData: data, cellData: cellData, data: $dropData)
                        )
                    }
                }
            }
            .padding()
        }
        .animation(.spring())
        .padding([.top], -22)
    }
}

struct HomeCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        HomeCollectionView(cellData: [], coordinator: ServiceLocator.shared.homeCoordinator(), dragAndDropDelegate: HomeViewModel(), offsetChanged: { _ in })
    }
}
