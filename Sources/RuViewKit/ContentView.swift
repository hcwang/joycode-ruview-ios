import SwiftUI

public struct ContentView: View {
    @StateObject private var client = CSIWebSocketClient(
        serverURL: URL(string: "ws://localhost:8080")!
    )
    private let deviceId = "robot-001"

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 连接状态
                    HStack {
                        Circle()
                            .fill(client.isConnected ? Color.green : Color.red)
                            .frame(width: 10, height: 10)
                        Text(client.isConnected ? "已连接" : "未连接")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Button(client.isConnected ? "断开" : "连接") {
                            if client.isConnected {
                                client.disconnect()
                            } else {
                                client.connect(deviceId: deviceId)
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.horizontal)

                    // 生命体征
                    VitalsView(
                        vitals: client.latestFrame?.vitals,
                        presence: client.latestFrame?.presence ?? false
                    )

                    // 姿态骨骼图
                    if let frame = client.latestFrame, frame.poseAvailable {
                        PoseSkeletonView(keypoints: frame.poseKeypoints)
                            .padding(.horizontal)
                    } else {
                        Text("姿态估计数据不可用")
                            .foregroundColor(.secondary)
                            .frame(height: 100)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("开心小金刚 · RuView")
        }
        .onAppear {
            client.connect(deviceId: deviceId)
        }
    }
}
