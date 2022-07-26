import SwiftUI

struct CheckboxRelationView: View {
    let isChecked: Bool
    let style: RelationStyle
    
    var body: some View {
        switch style {
        case .regular, .set:
            icon
        case .featuredRelationBlock:
            featuredRelationBlockIcon
        case .filter:
            filterText
        }
    }
    
    private var featuredRelationBlockIcon: some View {
        Group {
            isChecked ? Image(asset: .relationCheckboxChecked).resizable() : Image(asset: .relationCheckboxUnchecked).resizable()
        }.frame(width: style.checkboxSize.width, height: style.checkboxSize.height)
        
    }
    
    private var icon: some View {
        Group {
            isChecked ? Image(asset: .relationCheckboxChecked) : Image(asset: .relationCheckboxUnchecked)
        }
    }
    
    private var filterText: some View {
        Group {
            AnytypeText(
                isChecked ? Loc.EditSorts.Popup.Filter.Value.checked :
                    Loc.EditSorts.Popup.Filter.Value.unchecked,
                style: .relation1Regular,
                color: .textSecondary
            )
        }
    }
}

struct CheckboxRelationView_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxRelationView(isChecked: true, style: .featuredRelationBlock(allowMultiLine: false))
    }
}
