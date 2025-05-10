import SwiftUI

struct SettingItem: Identifiable {
    let id = UUID()
    let title: String
    let action: () -> Void
}

