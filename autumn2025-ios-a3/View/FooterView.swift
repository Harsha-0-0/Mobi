import SwiftUI

enum FooterTab: Hashable {
    case home, log, plan
}

struct FooterView: View {
    let activeTab: FooterTab
    let onTap: (FooterTab) -> Void

    var body: some View {
        HStack {
            Spacer()
            footerButton(tab: .home, systemImage: "house", label: "Home")
            Spacer()
            footerButton(tab: .log, systemImage: "calendar", label: "Log")
            Spacer()
            footerButton(tab: .plan, systemImage: "pencil", label: "Plan")
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGray6))
    }

    private func footerButton(tab: FooterTab, systemImage: String, label: String) -> some View {
        let isActive = (tab == activeTab)

        return Button(action: {
            if !isActive {
                onTap(tab)
            }
        }) {
            VStack {
                Image(systemName: systemImage)
                    .foregroundColor(isActive ? .blue : .gray)
                Text(label)
                    .font(.caption)
                    .foregroundColor(isActive ? .blue : .gray)
            }
        }
        .disabled(isActive)
    }
}
