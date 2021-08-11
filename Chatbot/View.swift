import UIKit
import Anchorage

final class View: UIView {

    var botMessage: String? {
        didSet {
            botLabel.text = botMessage
        }
    }

    private lazy var botLabel: UILabel = {
        return UILabel(frame: .zero)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        style()
        constrain()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        botLabel.numberOfLines = 0
        addSubview(botLabel)
    }

    private func style() {
        botLabel.backgroundColor = .black
        botLabel.textColor = .green
    }

    private func constrain() {
        botLabel.centerXAnchor /==/ centerXAnchor
        botLabel.topAnchor /==/ safeAreaLayoutGuide.topAnchor
        botLabel.widthAnchor /==/ widthAnchor
        botLabel.heightAnchor /==/ heightAnchor / 3
    }
}
