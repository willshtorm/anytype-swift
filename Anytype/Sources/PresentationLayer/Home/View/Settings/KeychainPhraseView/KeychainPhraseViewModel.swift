import SwiftUI

class KeychainPhraseViewModel: ObservableObject {
    @Published var recoveryPhrase: String? = nil
    @Published var showSnackbar = false
    
    private let seedService = ServiceLocator.shared.seedService()

    func obtainRecoveryPhrase() {
        recoveryPhrase = try? seedService.obtainSeed()
    }

    func onSeedViewTap() {
        if recoveryPhrase.isNil {
            obtainRecoveryPhrase()
        }
        
        guard let recoveryPhrase = recoveryPhrase else {
            return
        }
        
        UISelectionFeedbackGenerator().selectionChanged()
        UIPasteboard.general.string = recoveryPhrase
        showSnackbar = true
    }
}