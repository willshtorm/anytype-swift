import UIKit

final class ObjectRelationViewUIKit: UIView {
    let option: Relation.Object.Option
    let objectRelationStyle: ObjectRelationView.ObjectRelationStyle

    private var textView: AnytypeLabel!

    init(options: Relation.Object.Option, objectRelationStyle: ObjectRelationView.ObjectRelationStyle) {
        self.option = options
        self.objectRelationStyle = objectRelationStyle

        super.init(frame: .zero)

        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: textView.intrinsicContentSize.width + objectRelationStyle.size.width, height: textView.intrinsicContentSize.height)
    }

    private func setupView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = objectRelationStyle.hSpaсingObject

        textView = AnytypeLabel(style: .relation1Regular)
        textView.setText(option.title)
        textView.setLineBreakMode(.byTruncatingTail)
        textView.textColor = titleColor(option: option)

        let model = ObjectIconImageModel(
            iconImage: option.icon,
            usecase: .mention(.body)
        )
        let icon = ObjectIconImageView()
        icon.configure(model: model)

        stackView.addArrangedSubview(icon)
        stackView.addArrangedSubview(textView)

        icon.layoutUsing.anchors {
            $0.width.equal(to: objectRelationStyle.size.width)
            $0.height.equal(to: objectRelationStyle.size.height, priority: .defaultHigh)
        }

        addSubview(stackView) {
            $0.pinToSuperview()
        }
    }
    
    private func titleColor(option: Relation.Object.Option) -> UIColor {
        if option.isDeleted || option.isArchived {
            return .textTertiary
        } else {
            return .textPrimary
        }
    }
}