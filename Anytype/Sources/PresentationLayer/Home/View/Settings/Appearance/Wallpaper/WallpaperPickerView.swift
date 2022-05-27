import SwiftUI
import AnytypeCore

struct WallpaperPickerView: View {
    @EnvironmentObject var model: SettingsViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            DragIndicator()
            Spacer.fixedHeight(12)
            AnytypeText("Change wallpaper".localized, style: .uxTitle1Semibold, color: .textPrimary)
            Spacer.fixedHeight(12)
            WallpaperColorsGridView() { background in
                model.wallpaper = background
                model.wallpaperPicker = false
            }
        }
        .background(Color.backgroundSecondary)
        .onAppear {
            AnytypeAnalytics.instance().logEvent(AnalyticsEventsName.wallpaperSettingsShow)
        }
    }
}

struct WallpaperPickerView_Previews: PreviewProvider {
    static var previews: some View {
        WallpaperPickerView()
    }
}