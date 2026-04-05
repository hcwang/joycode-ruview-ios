import SwiftUI

// COCO 17关键点骨骼连接定义
private let SKELETON_CONNECTIONS: [(Int, Int)] = [
    (0,1),(0,2),(1,3),(2,4),         // 头部
    (5,6),(5,7),(7,9),(6,8),(8,10),  // 上肢
    (5,11),(6,12),(11,12),            // 躯干
    (11,13),(13,15),(12,14),(14,16)  // 下肢
]

public struct PoseSkeletonView: View {
    public let keypoints: [[Double]]  // [[x, y, confidence], ...]
    public let frameSize: CGSize

    public init(keypoints: [[Double]], frameSize: CGSize = CGSize(width: 300, height: 400)) {
        self.keypoints = keypoints
        self.frameSize = frameSize
    }

    public var body: some View {
        Canvas { ctx, size in
            guard keypoints.count == 17 else { return }
            let scaleX = size.width / frameSize.width
            let scaleY = size.height / frameSize.height

            // 画骨骼连线
            for (i, j) in SKELETON_CONNECTIONS {
                guard i < keypoints.count, j < keypoints.count else { continue }
                let kpA = keypoints[i], kpB = keypoints[j]
                guard kpA.count >= 3, kpB.count >= 3,
                      kpA[2] > 0.3, kpB[2] > 0.3 else { continue }
                var path = Path()
                path.move(to: CGPoint(x: kpA[0]*scaleX, y: kpA[1]*scaleY))
                path.addLine(to: CGPoint(x: kpB[0]*scaleX, y: kpB[1]*scaleY))
                ctx.stroke(path, with: .color(.green.opacity(0.8)), lineWidth: 2)
            }
            // 画关键点
            for kp in keypoints {
                guard kp.count >= 3, kp[2] > 0.3 else { continue }
                let rect = CGRect(x: kp[0]*scaleX-4, y: kp[1]*scaleY-4, width: 8, height: 8)
                ctx.fill(Path(ellipseIn: rect), with: .color(.yellow))
            }
        }
        .frame(width: frameSize.width, height: frameSize.height)
        .background(Color.black.opacity(0.05))
        .cornerRadius(8)
    }
}
