import SwiftUI

struct EditorSetView: View {
    @ObservedObject var model: EditorSetViewModel

    @State private var headerMinimizedSize = CGSize.zero
    @State private var tableHeaderSize = CGSize.zero
    @State private var offset = CGPoint.zero

    var body: some View {
        content
            .environmentObject(model)
            .onAppear {
                model.onAppear()
            }
            .onDisappear {
                model.onDisappear()
            }
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            ZStack {
                SetTableView(
                    tableHeaderSize: $tableHeaderSize,
                    offset: $offset,
                    headerMinimizedSize: headerMinimizedSize
                )
                SetMinimizedHeader(
                    headerSize: tableHeaderSize,
                    tableViewOffset: offset,
                    headerMinimizedSize: $headerMinimizedSize
                )
            }
            EditorSetPaginationView()
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarHidden(true)
        
        .sheet(isPresented: $model.showViewPicker) {
            EditorSetViewPicker()
                .cornerRadius(16, corners: [.topLeft, .topRight])
        }
    }
}

struct EditorSetView_Previews: PreviewProvider {
    static var previews: some View {
        EditorSetView(model: EditorSetViewModel(document: BaseDocument(objectId: "")))
    }
}