import SwiftUI

struct DashboardLogoutAlert: View {
    @EnvironmentObject var model: SettingsViewModel
    
    @State private var isLogoutInProgress = false
    
    var body: some View {
        FloaterAlertView(
            title: "Have you backed up your recovery phrase?".localized,
            description: "Recovery phrase description".localized,
            leftButtonData: StandardButtonModel(disabled: isLogoutInProgress, text: "Back up phrase".localized, style: .secondary) {
                model.keychain = true
                model.loggingOut = false
            },
            rightButtonData: StandardButtonModel(inProgress: isLogoutInProgress, text: "Log out".localized, style: .destructive) {
                isLogoutInProgress = true
                model.logout(removeData: false)
            }
        )
    }
}
