import SwiftUI

struct ProfileView: View {
    
    @State private var animateBackground = false
    @State private var animateCards = false
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                // MARK: - Animated Gradient Background
                LinearGradient(
                    colors: animateBackground
                    ? [
                        Color.blue.opacity(0.3),
                        Color.purple.opacity(0.25),
                        Color.black
                    ]
                    : [
                        Color.purple.opacity(0.25),
                        Color.blue.opacity(0.2),
                        Color.black
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animateBackground)
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(spacing: 30) {
                        
                        // MARK: - Profile Header
                        profileHeader
                            .scaleEffect(animateCards ? 1 : 0.9)
                            .opacity(animateCards ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.7), value: animateCards)
                        
                        // MARK: - Stats
                        HStack(spacing: 16) {
                            
                            statCard(icon: "checkmark.circle.fill", value: "126", title: "Tasks", color: .blue)
                            
                            statCard(icon: "flame.fill", value: "14", title: "Streak", color: .orange)
                        }
                        .opacity(animateCards ? 1 : 0)
                        .offset(y: animateCards ? 0 : 20)
                        .animation(.easeOut(duration: 0.7).delay(0.2), value: animateCards)
                        
                        // MARK: - Achievements
                        achievementsSection
                            .opacity(animateCards ? 1 : 0)
                            .offset(y: animateCards ? 0 : 30)
                            .animation(.easeOut(duration: 0.8).delay(0.3), value: animateCards)
                    }
                    .padding()
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                animateBackground = true
                animateCards = true
            }
        }
    }
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        
        VStack(spacing: 18) {
            
            ZStack {
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 140)
                    .shadow(color: .purple.opacity(0.4), radius: 20, x: 0, y: 10)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
            }
            
            Text("Sai")
                .font(.system(size: 34, weight: .bold, design: .rounded))
            
            Text("Focused every day 🚀")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(30)
        .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 10)
    }
    
    // MARK: - Stat Card
    private func statCard(icon: String, value: String, title: String, color: Color) -> some View {
        
        VStack(spacing: 10) {
            
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2.bold())
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(22)
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(color.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: color.opacity(0.1), radius: 10, x: 0, y: 5)
        .scaleEffect(animateCards ? 1 : 0.95)
        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: animateCards)
    }
    
    // MARK: - Achievements Section
    private var achievementsSection: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Achievements")
                .font(.title2.bold())
            
            achievementRow(icon: "flame.fill", title: "7 Day Streak", color: .orange)
            achievementRow(icon: "bolt.fill", title: "Focus Master", color: .purple)
            achievementRow(icon: "star.fill", title: "Top Performer", color: .yellow)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 10)
    }
    
    // MARK: - Achievement Row
    private func achievementRow(icon: String, title: String, color: Color) -> some View {
        
        HStack(spacing: 14) {
            
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 38, height: 38)
                
                Image(systemName: icon)
                    .foregroundColor(color)
            }
            
            Text(title)
                .font(.body.weight(.medium))
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 6)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .preferredColorScheme(.dark)
    }
}
