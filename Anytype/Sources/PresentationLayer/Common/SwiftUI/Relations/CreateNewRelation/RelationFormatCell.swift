import SwiftUI
import AnytypeCore
import BlocksModels

struct RelationFormatCell: View {
    
    let model: Model

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(model.icon).frame(width: 24, height: 24)

            AnytypeText(model.title, style: .uxBodyRegular, color: .textPrimary)
                .lineLimit(1)

            Spacer()

            if model.isSelected {
                Image.optionChecked.frame(width: 24, height: 24)
                    .foregroundColor(.buttonSelected)
            }
        }
        .frame(height: 52)
        .divider()
    }
}

extension RelationFormatCell {
    
    struct Model: Identifiable, Hashable {
        let id: String
        
        let title: String
        let icon: String
        
        let isSelected: Bool
    }
    
}
