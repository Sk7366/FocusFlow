import SwiftUI

struct ContentView: View {
    
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    
    var body: some View {
        
        if hasSeenOnboarding {
            
            TabView {
                
                DashboardView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Dashboard")
                    }
                
                
                TimerView()
                    .tabItem {
                        Image(systemName: "timer")
                        Text("Focus")
                    }
                
                
                AnalyticsView()
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Analytics")
                    }
            }
            
        } else {
            
            OnboardingView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
