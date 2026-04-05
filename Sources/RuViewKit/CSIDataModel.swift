import Foundation

// MARK: - CSI 数据帧（与服务端 WebSocket 格式对应）

public struct CSIFrame: Codable, Sendable {
    public let type: String
    public let timestamp: Double
    public let deviceId: String
    public let presence: Bool
    public let poseAvailable: Bool
    public let vitals: Vitals
    public let poseKeypoints: [[Double]]

    enum CodingKeys: String, CodingKey {
        case type, timestamp, presence
        case deviceId = "device_id"
        case poseAvailable = "pose_available"
        case vitals
        case poseKeypoints = "pose_keypoints"
    }
}

public struct Vitals: Codable, Sendable {
    public let breathingBpm: Double?
    public let heartBpm: Double?

    enum CodingKeys: String, CodingKey {
        case breathingBpm = "breathing_bpm"
        case heartBpm = "heart_bpm"
    }
}

// MARK: - 17 COCO 关键点名称
public enum COCOKeypoint: Int, CaseIterable {
    case nose = 0, leftEye, rightEye, leftEar, rightEar
    case leftShoulder, rightShoulder, leftElbow, rightElbow
    case leftWrist, rightWrist, leftHip, rightHip
    case leftKnee, rightKnee, leftAnkle, rightAnkle

    public var name: String {
        ["鼻子","左眼","右眼","左耳","右耳",
         "左肩","右肩","左肘","右肘",
         "左腕","右腕","左髋","右髋",
         "左膝","右膝","左踝","右踝"][rawValue]
    }
}
