"""
iOS 端协议验证脚本（雨燕编写）
拉起 joycode-ruview-server，验证 WebSocket 数据格式与 iOS CSIFrame 模型一致

运行：python scripts/e2e_protocol_check.py
"""
import asyncio
import json
import subprocess
import sys
import time
import websockets
import urllib.request

SERVER_URL = "http://localhost:8080"
WS_URL = "ws://localhost:8080"

async def test_enroll_and_connect():
    print("=== iOS 端协议验证开始 ===")

    # 1. 设备注册
    print("[1] 测试设备注册...")
    req = urllib.request.Request(
        f"{SERVER_URL}/api/devices/enroll",
        data=json.dumps({"mac": "aa:bb:cc:12:34:56", "name": "ios-test-robot", "user_id": "ios-tester"}).encode(),
        headers={"Content-Type": "application/json"},
        method="POST"
    )
    with urllib.request.urlopen(req) as resp:
        enroll_data = json.loads(resp.read())
    assert "device_id" in enroll_data, f"注册失败，缺少 device_id: {enroll_data}"
    assert "token" in enroll_data, f"注册失败，缺少 token: {enroll_data}"
    device_id = enroll_data["device_id"]
    print(f"  ✅ 注册成功: device_id={device_id}")

    # 2. WebSocket 连接并验证响应帧格式
    print("[2] 测试 WebSocket CSI 数据帧格式...")
    # iOS CSIFrame 期望的字段（来自 CSIDataModel.swift）
    REQUIRED_FIELDS = {
        "type": str,
        "timestamp": (int, float),
        "device_id": str,
        "presence": bool,
        "pose_available": bool,
        "vitals": dict,
        "pose_keypoints": list,
    }
    REQUIRED_VITALS = {"breathing_bpm", "heart_bpm"}

    async with websockets.connect(f"{WS_URL}/ws/csi/{device_id}") as ws:
        # 发送一帧 CSI 数据
        await ws.send(json.dumps({
            "type": "csi_data",
            "timestamp": 1712300000000,
            "device_id": device_id,
            "csi_raw": [10, -5, 8, -3, 12, -7, 9, -4, 6, -2, 11, -8]
        }))
        resp_str = await asyncio.wait_for(ws.recv(), timeout=5.0)
        frame = json.loads(resp_str)

    print(f"  收到响应: {json.dumps(frame, ensure_ascii=False)[:120]}...")

    # 验证字段
    errors = []
    for field, expected_type in REQUIRED_FIELDS.items():
        if field not in frame:
            errors.append(f"缺少字段: {field}")
        elif not isinstance(frame[field], expected_type):
            errors.append(f"字段类型错误: {field}，期望 {expected_type}，实际 {type(frame[field])}")

    for vfield in REQUIRED_VITALS:
        if vfield not in frame.get("vitals", {}):
            errors.append(f"vitals 缺少字段: {vfield}")

    if errors:
        print("  ❌ 协议验证失败:")
        for e in errors:
            print(f"    - {e}")
        sys.exit(1)
    else:
        print("  ✅ 所有字段验证通过")
        print("  ✅ iOS CSIFrame 模型与服务端协议完全兼容")

    print("=== iOS 端协议验证完成 ===")

if __name__ == "__main__":
    asyncio.run(test_enroll_and_connect())
