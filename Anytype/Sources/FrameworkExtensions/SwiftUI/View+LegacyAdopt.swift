import Foundation
import SwiftUI

/// Adopt for ios 15

@available(iOS, deprecated: 16)
extension View {
    func hideScrollIndicatorLegacy() -> some View {
        if #available(iOS 16.0, *) {
            return self.scrollIndicators(.never)
        } else {
            return self
        }
    }
    
    func hideKeyboardOnScrollLegacy() -> some View {
        if #available(iOS 16.0, *) {
            return self.scrollDismissesKeyboard(.immediately)
        } else {
            return self
        }
    }
}
