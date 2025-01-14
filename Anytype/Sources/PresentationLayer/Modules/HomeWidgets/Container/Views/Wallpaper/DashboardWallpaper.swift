import SwiftUI
import AnytypeCore

struct DashboardWallpaper: View {
    @ObservedObject private var model = DashboardWallpaperViewModel()
    
    var body: some View {
        Group {
            switch model.wallpaper {
            case .color(let color):
                Color(hex: color.data.hex).ignoresSafeArea()
            case .gradient(let gradient):
                Gradients.create(topHexColor: gradient.data.startHex, bottomHexColor: gradient.data.endHex)
            }
        }
    }
}

struct DashboardWallpaper_Previews: PreviewProvider {
    static var previews: some View {
        DashboardWallpaper()
    }
}
