import SwiftUI

struct OnboardingPage {
    
    let title: String
    let subtitle: String
    let image: String
    let colors: [Color]
}

struct OnboardingView: View {
    
    // MARK: - STORAGE
    
    @AppStorage("hasSeenOnboarding")
    var hasSeenOnboarding = false
    
    
    // MARK: - STATES
    
    @State private var currentPage = 0
    
    @State private var animateBackground = false
    
    @State private var animateContent = false
    
    
    // MARK: - PAGES
    
    let pages = [
        
        OnboardingPage(
            title: "Welcome to FocusFlow",
            subtitle: "Organize your tasks and build powerful productivity habits every single day 🚀",
            image: "checklist",
            colors: [.blue, .purple]
        ),
        
        OnboardingPage(
            title: "Stay Deeply Focused",
            subtitle: "Use immersive Pomodoro sessions to eliminate distractions and maximize concentration ⏳",
            image: "timer",
            colors: [.orange, .red]
        ),
        
        OnboardingPage(
            title: "Track Your Growth",
            subtitle: "Visualize your consistency and productivity with beautiful AI-powered analytics 📈",
            image: "chart.line.uptrend.xyaxis",
            colors: [.green, .mint]
        )
    ]
    
    
    // MARK: - BODY
    
    var body: some View {
        
        ZStack {
            
            
            // PREMIUM ANIMATED BACKGROUND
            
            LinearGradient(
                colors: animateBackground
                ? [
                    pages[currentPage].colors[0],
                    pages[currentPage].colors[1],
                    .black
                ]
                : [
                    pages[currentPage].colors[1],
                    pages[currentPage].colors[0],
                    .black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(
                .easeInOut(duration: 6)
                .repeatForever(autoreverses: true),
                value: animateBackground
            )
            .animation(
                .easeInOut(duration: 0.5),
                value: currentPage
            )
            
            
            // GLOWING BACKGROUND CIRCLES
            
            Circle()
                .fill(
                    Color.white.opacity(0.08)
                )
                .frame(width: 350, height: 350)
                .blur(radius: 20)
                .offset(x: -120, y: -250)
            
            Circle()
                .fill(
                    Color.white.opacity(0.06)
                )
                .frame(width: 250, height: 250)
                .blur(radius: 20)
                .offset(x: 140, y: 300)
            
            
            VStack {
                
                
                // SKIP BUTTON
                
                HStack {
                    
                    Spacer()
                    
                    Button {
                        
                        hasSeenOnboarding = true
                        
                    } label: {
                        
                        Text("Skip")
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(
                                Color.white.opacity(0.12)
                            )
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                
                Spacer()
                
                
                // PAGE CONTENT
                
                TabView(selection: $currentPage) {
                    
                    ForEach(0..<pages.count, id: \.self) { index in
                        
                        VStack(spacing: 35) {
                            
                            
                            // ICON CARD
                            
                            ZStack {
                                
                                Circle()
                                    .fill(
                                        Color.white.opacity(0.12)
                                    )
                                    .frame(width: 220, height: 220)
                                    .blur(radius: 10)
                                
                                
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.18),
                                                Color.white.opacity(0.05)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 190, height: 190)
                                
                                
                                Image(systemName: pages[index].image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 90, height: 90)
                                    .foregroundColor(.white)
                            }
                            .scaleEffect(
                                currentPage == index
                                ? 1
                                : 0.85
                            )
                            .rotationEffect(
                                .degrees(
                                    currentPage == index
                                    ? 0
                                    : -10
                                )
                            )
                            .animation(
                                .spring(
                                    response: 0.6,
                                    dampingFraction: 0.7
                                ),
                                value: currentPage
                            )
                            
                            
                            // TITLE
                            
                            Text(pages[index].title)
                                .font(
                                    .system(
                                        size: 38,
                                        weight: .bold
                                    )
                                )
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            
                            // SUBTITLE
                            
                            Text(pages[index].subtitle)
                                .font(.title3)
                                .foregroundColor(
                                    .white.opacity(0.88)
                                )
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 35)
                                .lineSpacing(5)
                            
                            
                            // FEATURE TAGS
                            
                            HStack(spacing: 12) {
                                
                                onboardingTag(
                                    text: "AI Powered"
                                )
                                
                                onboardingTag(
                                    text: "Modern UI"
                                )
                                
                                onboardingTag(
                                    text: "Productivity"
                                )
                            }
                            .padding(.top, 10)
                        }
                        .padding(.horizontal)
                        .tag(index)
                    }
                }
                .tabViewStyle(
                    .page(indexDisplayMode: .never)
                )
                
                
                Spacer()
                
                
                // CUSTOM PAGE INDICATORS
                
                HStack(spacing: 10) {
                    
                    ForEach(0..<pages.count, id: \.self) { index in
                        
                        Capsule()
                            .fill(
                                currentPage == index
                                ? Color.white
                                : Color.white.opacity(0.3)
                            )
                            .frame(
                                width: currentPage == index ? 35 : 10,
                                height: 10
                            )
                            .animation(
                                .spring(),
                                value: currentPage
                            )
                    }
                }
                
                
                Spacer()
                    .frame(height: 30)
                
                
                // BUTTON
                
                Button {
                    
                    if currentPage < pages.count - 1 {
                        
                        withAnimation(.spring()) {
                            
                            currentPage += 1
                        }
                        
                    } else {
                        
                        hasSeenOnboarding = true
                    }
                    
                } label: {
                    
                    HStack {
                        
                        Text(
                            currentPage == pages.count - 1
                            ? "Get Started"
                            : "Continue"
                        )
                        .fontWeight(.bold)
                        
                        
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(22)
                    .shadow(
                        color: .white.opacity(0.3),
                        radius: 10
                    )
                    .padding(.horizontal)
                }
                .scaleEffect(animateContent ? 1 : 0.9)
                .opacity(animateContent ? 1 : 0)
                
                
                Spacer()
                    .frame(height: 40)
            }
        }
        .onAppear {
            
            animateBackground.toggle()
            
            withAnimation(
                .easeOut(duration: 0.8)
            ) {
                animateContent = true
            }
        }
    }
    
    
    // MARK: - TAG VIEW
    
    func onboardingTag(text: String) -> some View {
        
        Text(text)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Color.white.opacity(0.12)
            )
            .cornerRadius(20)
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .preferredColorScheme(.dark)
    }
}
