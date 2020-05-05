//
//  TextView+UIKitTextView+TextView.swift
//  AnyType
//
//  Created by Dmitry Lobanov on 05.05.2020.
//  Copyright © 2020 AnyType. All rights reserved.
//

import Foundation
import UIKit
import Combine

extension TextView.UIKitTextView {
    class TextViewWithPlaceholder: UITextView {
        
        // MARK: Variables
        var subscriptions: Set<AnyCancellable> = []
        
        // MARK: Views
        private lazy var placeholderLabel: UILabel? = {
            let label: UILabel = .init()
            label.textColor = self.textColor
            label.font = self.font
            label.textAlignment = self.textAlignment
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        var placeholderConstraints: [NSLayoutConstraint] = []
        
        
        override var textContainerInset: UIEdgeInsets {
            didSet {
                self.updatePlaceholderLayout()
            }
        }

        // MARK: Initialization
        override init(frame: CGRect, textContainer: NSTextContainer?) {
            super.init(frame: frame, textContainer: textContainer)
            self.setup()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.setup()
        }
        
        // MARK: Setup
        func setup() {
            self.setupUIElements()
            self.updatePlaceholderLayout()
            self.setupSubscriptions()
        }
        
        func setupUIElements() {
            if let view = self.placeholderLabel {
                self.addSubview(view)
            }
        }
        
        func setupSubscriptions() {
            // Do not delete it.
            // Well, we could use publisher here?
            NotificationCenter.Publisher.init(center: .default, name: UITextView.textDidChangeNotification).sink { [weak self] (value) in
                // do stuff if we need it to adjust to updates of TextView.
                self?.syncPlaceholder()
            }.store(in: &self.subscriptions)
        }
        
        // MARK: Add Layout
        func updatePlaceholderLayout() {
            if let view = self.placeholderLabel, let superview = view.superview {
                let insets = self.textContainerInset
                let lineFragmentPadding = self.textContainer.lineFragmentPadding
                
                if !self.placeholderConstraints.isEmpty {
                    self.removeConstraints(self.placeholderConstraints)
                }
                
                self.placeholderConstraints = [
                    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left + lineFragmentPadding),
                    view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -(insets.right + lineFragmentPadding)),
                    view.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
                    view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
                ]
                
                NSLayoutConstraint.activate(self.placeholderConstraints)
            }
        }
    }
}

extension TextView.UIKitTextView.TextViewWithPlaceholder {
    // MARK: Update Placeholder
    fileprivate func syncPlaceholder() {
        self.placeholderLabel?.isHidden = !self.text.isEmpty
    }
    
    func update(placeholder: NSAttributedString?) {
        self.placeholderLabel?.attributedText = placeholder
        // TODO: Add redrawing?
    }
}
