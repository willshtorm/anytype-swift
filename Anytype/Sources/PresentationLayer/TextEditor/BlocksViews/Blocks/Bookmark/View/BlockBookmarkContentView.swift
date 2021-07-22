import Combine
import UIKit
import BlocksModels
    
final class BlockBookmarkContentView: UIView & UIContentView {
    private var currentConfiguration: BlockBookmarkConfiguration
    var configuration: UIContentConfiguration {
        get { currentConfiguration }
        set {
            guard let configuration = newValue as? BlockBookmarkConfiguration,
                  configuration != currentConfiguration else { return }
            
            currentConfiguration = configuration
            apply(state: currentConfiguration.state)
        }
    }
    
    init(configuration: BlockBookmarkConfiguration) {
        self.currentConfiguration = configuration
        super.init(frame: .zero)
        
        apply(state: currentConfiguration.state)
    }
    
    @available(*, unavailable)
    override init(frame: CGRect) {
        fatalError("Not implemented")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func apply(state: BlockBookmarkState) {
        switch state {
        case .empty:
            bookmarkView.removeFromSuperview()
            addSubview(emptyView) {
                $0.pinToSuperview(insets: Layout.emptyViewInsets)
                $0.height.equal(to: Layout.emptyViewHeight)
            }
        case let .onlyURL(url):
            emptyView.removeFromSuperview()
            addSubview(bookmarkView) {
                $0.pinToSuperview(insets: Layout.bookmarkViewInsets)
                $0.height.equal(to: Layout.emptyViewHeight)
            }
            bookmarkView.handle(state: .onlyURL(url))
        case let .fetched(payload):
            emptyView.removeFromSuperview()
            addSubview(bookmarkView) {
                $0.pinToSuperview(insets: Layout.bookmarkViewInsets)
                $0.height.equal(to: Layout.bookmarkViewHeight)
            }
            bookmarkView.handle(state: .fetched(payload))
        }
    }

    // MARK: - Views
    private let emptyView = BlocksFileEmptyView(
        viewData: .init(
            image: UIImage.blockFile.empty.bookmark,
            placeholderText: "Add a web bookmark"
        )
    )
    
    private let bookmarkView: BlockBookmarkView = {
        let view = BlockBookmarkView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grayscale30.cgColor
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
}

private extension BlockBookmarkContentView {
    enum Layout {
        static let emptyViewHeight: CGFloat = 48
        static let bookmarkViewHeight: CGFloat = 108
        static let bookmarkViewInsets = UIEdgeInsets(top: 10, left: 20, bottom: -10, right: -20)
        static let emptyViewInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20)
    }
}
