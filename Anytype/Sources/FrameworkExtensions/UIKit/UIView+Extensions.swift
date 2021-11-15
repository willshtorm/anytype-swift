import UIKit

extension UIView {
    
    /// Add constraints to superview
    ///
    /// - Parameters:
    ///   - insets: Insets
    func edgesToSuperview(insets: UIEdgeInsets = .zero) {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        ])
    }
    
    func renderedImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func isAnySubviewFirstResponder() -> Bool {
        if isFirstResponder {
            return true
        }
        for subview in subviews {
            if subview.isAnySubviewFirstResponder() {
                return true
            }
        }
        return false
    }
    
    func removeInteractions(passing check: (UIInteraction) -> Bool) {
        let interactionsToRemove = interactions.filter(check)
        interactionsToRemove.forEach { interaction in
            removeInteraction(interaction)
        }
    }
}