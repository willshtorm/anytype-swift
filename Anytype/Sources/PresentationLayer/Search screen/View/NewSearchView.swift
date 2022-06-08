import SwiftUI

struct NewSearchView: View {
    
    @ObservedObject var viewModel: NewSearchViewModel

    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            DragIndicator()
            TitleView(title: viewModel.title)
            SearchBar(text: $searchText, focused: true)
            content
            
            viewModel.addButtonModel.flatMap {
                addButton(model: $0)
            }
        }
        .background(Color.backgroundSecondary)
        .onChange(of: searchText) { viewModel.didAskToSearch(text: $0) }
        .onAppear { viewModel.didAskToSearch(text: searchText) }
    }
    
    private var content: some View {
        Group {
            switch viewModel.state {
            case .resultsList(let model):
                searchResults(model: model)
            case .error(let error):
                errorState(error)
            }
        }
    }
    
    private func errorState(_ error: NewSearchError) -> some View {
        VStack(alignment: .center) {
            Spacer()
            AnytypeText(
                error.title,//"\("There is no object named".localized) \"\(searchText)\"",
                style: .uxBodyRegular,
                color: .textPrimary
            )
            .multilineTextAlignment(.center)
            error.subtitle.flatMap {
                AnytypeText(
                    $0,// "Try to create a new one or search for something else".localized,
                    style: .uxBodyRegular,
                    color: .textSecondary
                )
                .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private func searchResults(model: ListModel) -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if viewModel.isCreateButtonAvailable {
                    RelationOptionCreateButton(text: searchText) {
                        viewModel.didTapCreateButton(title: searchText)
                    }
                }
                switch model {
                case .plain(let rows):
                    rowViews(rows: rows)
                case .sectioned(let sections):
                    ForEach(sections) { section in
                        Section(header: section.makeView()) {
                            rowViews(rows: section.rows)
                        }
                    }
                }
            }
            .padding(.bottom, 10)
        }
    }
    
    private func rowViews(rows: [ListRowConfiguration]) -> some View {
        ForEach(rows) { row in
            Button {
                viewModel.didSelectRow(with: row.id)
            } label: {
                row.makeView()
            }
        }
    }
    
    private func addButton(model: AddButtonModel) -> some View {
        StandardButton(disabled: model.isDisabled, text: "Add".localized, style: .primary) {
            viewModel.didTapAddButton()
        }
        .if(!model.isDisabled) {
            $0.if(model.counter > 0) {
                $0.overlay(
                    HStack(spacing: 0) {
                        Spacer()
                        AnytypeText("\(model.counter)", style: .relation1Regular, color: .textWhite)
                            .frame(minWidth: 15, minHeight: 15)
                            .padding(5)
                            .background(Color.System.amber125)
                            .clipShape(Circle())
                        Spacer.fixedWidth(12)
                    }
                )
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }
    
}

//struct NewSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewSearchView()
//    }
//}
