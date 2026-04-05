import Foundation

@MainActor
public class CSIWebSocketClient: NSObject, ObservableObject {
    @Published public var latestFrame: CSIFrame?
    @Published public var isConnected = false
    @Published public var error: String?

    private var webSocketTask: URLSessionWebSocketTask?
    private let serverURL: URL

    public init(serverURL: URL) {
        self.serverURL = serverURL
    }

    public func connect(deviceId: String) {
        let url = serverURL.appendingPathComponent("ws/csi/\(deviceId)")
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        isConnected = true
        receiveNext()
    }

    public func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        isConnected = false
    }

    private func receiveNext() {
        webSocketTask?.receive { [weak self] result in
            Task { @MainActor in
                switch result {
                case .success(let message):
                    if case .string(let text) = message,
                       let data = text.data(using: .utf8) {
                        self?.latestFrame = try? JSONDecoder().decode(CSIFrame.self, from: data)
                    }
                    self?.receiveNext()
                case .failure(let err):
                    self?.error = err.localizedDescription
                    self?.isConnected = false
                }
            }
        }
    }
}

extension CSIWebSocketClient: URLSessionWebSocketDelegate {
    nonisolated public func urlSession(_ session: URLSession,
                            webSocketTask: URLSessionWebSocketTask,
                            didOpenWithProtocol protocol: String?) {
        Task { @MainActor in self.isConnected = true }
    }
    nonisolated public func urlSession(_ session: URLSession,
                            webSocketTask: URLSessionWebSocketTask,
                            didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                            reason: Data?) {
        Task { @MainActor in self.isConnected = false }
    }
}
