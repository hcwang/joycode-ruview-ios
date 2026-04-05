# joycode-ruview-ios

开心小金刚机器人 RuView iOS App（SwiftUI）

## 功能
- WebSocket 接收 CSI 感知数据（生命体征 + 姿态关键点）
- 生命体征卡片：实时呼吸率/心率显示
- 姿态骨骼图：17 COCO 关键点 SwiftUI Canvas 渲染
- 设备存在状态指示

## 数据格式
```json
{
  "type": "csi_data",
  "timestamp": 1712300000000,
  "device_id": "robot-001",
  "presence": true,
  "pose_available": false,
  "vitals": { "breathing_bpm": 16, "heart_bpm": 72 },
  "pose_keypoints": []
}
```

## 相关仓库
- [服务端](https://github.com/hcwang/joycode-ruview-server)
- [固件](https://github.com/hcwang/joycode-ruview-firmware)
