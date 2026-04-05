import SwiftUI

public struct VitalsView: View {
    public let vitals: Vitals?
    public let presence: Bool

    public init(vitals: Vitals?, presence: Bool) {
        self.vitals = vitals
        self.presence = presence
    }

    public var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: presence ? "person.fill" : "person.slash")
                    .foregroundColor(presence ? .green : .gray)
                Text(presence ? "有人在" : "无人")
                    .foregroundColor(presence ? .green : .secondary)
                    .font(.headline)
            }
            HStack(spacing: 20) {
                VitalCard(
                    icon: "wind",
                    label: "呼吸",
                    value: vitals?.breathingBpm.map { String(format: "%.0f", $0) } ?? "--",
                    unit: "次/分",
                    color: .blue
                )
                VitalCard(
                    icon: "heart.fill",
                    label: "心率",
                    value: vitals?.heartBpm.map { String(format: "%.0f", $0) } ?? "--",
                    unit: "BPM",
                    color: .red
                )
            }
        }
        .padding()
    }
}

struct VitalCard: View {
    let icon: String
    let label: String
    let value: String
    let unit: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon).foregroundColor(color).font(.title2)
            Text(value).font(.system(size: 36, weight: .bold, design: .rounded)).foregroundColor(color)
            Text(unit).font(.caption).foregroundColor(.secondary)
            Text(label).font(.caption2).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}
