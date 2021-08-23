import UIKit

final class DocumentIconEmojiView: UIView {
        
    // MARK: - Private properties
    
    private let emojiLabel: UILabel = UILabel()
        
    // MARK: Initialization
    
    init(
        font: UIFont = .systemFont(ofSize: 48),
        cornerRadius: CGFloat = Constants.cornerRadius,
        size: CGSize = Constants.size
    ) {
        super.init(frame: .zero)
        
        setupView(
            font: font,
            cornerRadius: cornerRadius,
            size: size
        )
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - ConfigurableView

extension DocumentIconEmojiView: ConfigurableView {
    
    func configure(model: String) {
        emojiLabel.text = model
    }
    
}

// MARK: - Private extension

private extension DocumentIconEmojiView {
    
    func setupView(font: UIFont, cornerRadius: CGFloat, size: CGSize) {
        clipsToBounds = true
        backgroundColor = .grayscale10
        
        layer.cornerRadius = cornerRadius
        
        configureEmojiLabel(font: font)
        
        setupLayout(size: size)
    }
    
    func configureEmojiLabel(font: UIFont) {
        emojiLabel.backgroundColor = .grayscale10
        emojiLabel.font = font
        emojiLabel.textColor = .textSecondary
        emojiLabel.textAlignment = .center
        emojiLabel.adjustsFontSizeToFitWidth = true
        emojiLabel.isUserInteractionEnabled = false
    }
    
    func setupLayout(size: CGSize) {
        addSubview(emojiLabel) {
            $0.pinToSuperview()
            $0.size(size)
        }
    }
    
}

// MARK: - Constants

extension DocumentIconEmojiView {
    
    enum Constants {
        static let cornerRadius: CGFloat = 18
        static let size = CGSize(width: 80, height: 80)
    }
    
}
