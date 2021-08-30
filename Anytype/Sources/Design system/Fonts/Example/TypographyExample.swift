#if DEBUG
import SwiftUI

struct TypographyExample: View {
    var body: some View {
        ScrollView() {
            ForEach(AnytypeFont.allCases, id: \.self) { style in
                VStack {
                    AnytypeText("\(String(describing: style))", style: style)
                    AnytypeText("The quick brown fox jumps over the lazy dog", style: style)
                }.padding(10)
            }
        }
    }
}

struct TypographyExample_Previews: PreviewProvider {
    static var previews: some View {
        TypographyExample()
    }
}
#endif
