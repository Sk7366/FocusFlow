import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab: Tab = .home
    @Namespace private var animation
    
    var body: some View {
        
        ZStack {
            
            // MARK: - Pages
            Group {
                switch selectedTab {
                case .home:
                    DashboardView()
                case .focus:
                    TimerView()
                case .analytics:
                    AnalyticsView()
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // MARK: - Floating Tab Bar
            VStack {
                Spacer()
                customTabBar
            }
        }
    }
    
    // MARK: - Custom Tab Bar
    private var customTabBar: some View {
        
        HStack {
            
            ForEach(Tab.allCases, id: \.self) { tab in
                
                Spacer()
                
                tabButton(tab)
                
                Spacer()
            }
        }
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
        .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 8)
    }
    
    // MARK: - Tab Button
    private func tabButton(_ tab: Tab) -> some View {
        
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                selectedTab = tab
            }
            
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            
        } label: {
            
            VStack(spacing: 4) {
                
                ZStack {
                    
                    if selectedTab == tab {
                        Circle()
                            .fill(.purple.opacity(0.15))
                            .frame(width: 42, height: 42)
                            .matchedGeometryEffect(id: "bg", in: animation)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(selectedTab == tab ? .purple : .gray)
                        .scaleEffect(selectedTab == tab ? 1.2 : 1.0)
                }
                
                Text(tab.title)
                    .font(.caption2)
                    .foregroundColor(selectedTab == tab ? .purple : .gray)
            }
        }
    }
}

// MARK: - Tab Enum
enum Tab: CaseIterable {
    case home
    case focus
    case analytics
    case profile
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .focus: return "Focus"
        case .analytics: return "Stats"
        case .profile: return "Profile"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .focus: return "timer"
        case .analytics: return "chart.bar.fill"
        case .profile: return "person.fill"
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
