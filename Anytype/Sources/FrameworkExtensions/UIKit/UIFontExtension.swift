import UIKit

extension UIFont {
    
    func adding(trait: UIFontDescriptor.SymbolicTraits) -> UIFont? {
        let traits = fontDescriptor.symbolicTraits.union(trait)
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else { return nil }
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}
