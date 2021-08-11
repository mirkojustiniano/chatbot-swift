import UIKit
import Anchorage

protocol ViewDelegate: AnyObject {
    func onKeyboardReturn(message: String?)
}

final class View: UIView {
    weak var delegate: ViewDelegate?

    var botMessage: String? {
        didSet {
            botLabel.text = botMessage
        }
    }

    private lazy var botLabel: UILabel = {
        return UILabel(frame: .zero)
    }()

    private lazy var textField: UITextField = {
        return UITextField(frame: .zero)
    }()

    private var keyboardHiddenConstraints: [NSLayoutConstraint] = []
    private var keyboardShownConstraints: [NSLayoutConstraint] = []

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
        textField.delegate = self
        addSubview(textField)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func style() {
        botLabel.backgroundColor = .black
        botLabel.textColor = .green
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: "Enter message here...",
                                                             attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
    }

    private func constrain() {
        botLabel.centerXAnchor /==/ centerXAnchor
        botLabel.topAnchor /==/ safeAreaLayoutGuide.topAnchor
        botLabel.widthAnchor /==/ widthAnchor
        botLabel.heightAnchor /==/ heightAnchor / 3

        textField.centerXAnchor /==/ centerXAnchor
        textField.widthAnchor /==/ widthAnchor
        textField.heightAnchor /==/ 31

        keyboardHiddenConstraints = Anchorage.batch(active: true) {
            textField.bottomAnchor /==/ safeAreaLayoutGuide.bottomAnchor
        }
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }
        if keyboardShownConstraints.count == 0 {
            let keyboardFrame = keyboardSize.cgRectValue
            keyboardShownConstraints = Anchorage.batch(active: true) {
                textField.bottomAnchor /==/ safeAreaLayoutGuide.bottomAnchor - keyboardFrame.height
            }
        }
        NSLayoutConstraint.activate(keyboardShownConstraints)
        NSLayoutConstraint.deactivate(keyboardHiddenConstraints)
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        NSLayoutConstraint.activate(keyboardHiddenConstraints)
        NSLayoutConstraint.deactivate(keyboardShownConstraints)
    }
}

// MARK:- UITextFieldDelegate

extension View: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.onKeyboardReturn(message: textField.text)
        textField.text = nil
        return true
    }
}
