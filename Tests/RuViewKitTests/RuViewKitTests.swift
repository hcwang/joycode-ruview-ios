import XCTest
@testable import RuViewKit

final class RuViewKitTests: XCTestCase {
    func testCSIFrameDecoding() throws {
        let json = """
        {
          "type": "csi_data",
          "timestamp": 1712300000000,
          "device_id": "robot-001",
          "presence": true,
          "pose_available": false,
          "vitals": {"breathing_bpm": 16, "heart_bpm": 72},
          "pose_keypoints": []
        }
        """.data(using: .utf8)!
        let frame = try JSONDecoder().decode(CSIFrame.self, from: json)
        XCTAssertEqual(frame.deviceId, "robot-001")
        XCTAssertTrue(frame.presence)
        XCTAssertEqual(frame.vitals.breathingBpm, 16)
        XCTAssertEqual(frame.vitals.heartBpm, 72)
    }
}
