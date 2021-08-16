import UIKit
import SocketIO

final class ViewController: UIViewController {

    private let chatView: View = View(frame: UIScreen.main.bounds)
    private let manager = SocketManager(socketURL: URL(string: "http://localhost:5000")!, config: [.log(true), .compress])
    private var socket: SocketIOClient!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        socket = manager.defaultSocket

        socket.on(clientEvent: .connect) { (data, ack) in
            debugPrint(">>> socket connected")
        }

        socket.on("message") { [weak self] (data, ack) in
            if let message = data[0] as? String {
                self?.chatView.botMessage = message
            }
        }

        socket.connect()
    }

    override func loadView() {
        chatView.delegate = self
        self.view = chatView
    }
}

// MARK:- ViewDelegate

extension ViewController: ViewDelegate {
    func onKeyboardReturn(message: String?) {
        guard let message = message else { return }
        socket.emit("message", message)
    }
}

