import SwiftUI
import UIKit

struct TimerView: View {
    
    // MARK: - STATES
    
    @State private var timeRemaining = 1500
    
    @State private var timerRunning = false
    
    @State private var animateBackground = false
    
    @State private var selectedTime = 1500
    
    
    // MARK: - TIMER
    
    let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()
    
    
    // MARK: - TIME VALUES
    
    var minutes: Int {
        timeRemaining / 60
    }
    
    var seconds: Int {
        timeRemaining % 60
    }
    
    
    // MARK: - PROGRESS
    
    var progress: Double {
        Double(timeRemaining) / Double(selectedTime)
    }
    
    
    // MARK: - HAPTICS
    
    func triggerHaptic() {
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        
        generator.impactOccurred()
    }
    
    
    // MARK: - BODY
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                
                // PREMIUM ANIMATED BACKGROUND
                
                LinearGradient(
                    colors: animateBackground
                    ? [
                        Color.blue.opacity(0.25),
                        Color.purple.opacity(0.2),
                        Color.black
                    ]
                    : [
                        Color.purple.opacity(0.25),
                        Color.blue.opacity(0.15),
                        Color.black
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
                
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(spacing: 35) {
                        
                        
                        // HEADER
                        
                        VStack(spacing: 10) {
                            
                            Text("Focus Timer")
                                .font(.system(size: 36, weight: .bold))
                            
                            
                            Text("Deep work starts here 🚀")
                                .foregroundColor(.secondary)
                        }
                        .padding(.top)
                        
                        
                        // TIMER RING
                        
                        ZStack {
                            
                            Circle()
                                .stroke(
                                    Color.white.opacity(0.08),
                                    lineWidth: 18
                                )
                                .frame(width: 270, height: 270)
                            
                            
                            Circle()
                                .trim(
                                    from: 0,
                                    to: progress
                                )
                                .stroke(
                                    AngularGradient(
                                        gradient: Gradient(
                                            colors: [
                                                .blue,
                                                .purple,
                                                .pink
                                            ]
                                        ),
                                        center: .center
                                    ),
                                    style: StrokeStyle(
                                        lineWidth: 18,
                                        lineCap: .round
                                    )
                                )
                                .frame(width: 270, height: 270)
                                .rotationEffect(.degrees(-90))
                                .shadow(
                                    color: .purple.opacity(0.5),
                                    radius: 12
                                )
                                .animation(
                                    .linear(duration: 1),
                                    value: timeRemaining
                                )
                            
                            
                            VStack(spacing: 12) {
                                
                                Text(
                                    String(
                                        format: "%02d:%02d",
                                        minutes,
                                        seconds
                                    )
                                )
                                .font(
                                    .system(
                                        size: 52,
                                        weight: .bold,
                                        design: .rounded
                                    )
                                )
                                
                                
                                Text(timerRunning ? "Stay Focused 🔥" : "Ready to Focus")
                                    .foregroundColor(.secondary)
                                
                                
                                if timerRunning {
                                    
                                    Image(systemName: "bolt.fill")
                                        .foregroundColor(.yellow)
                                        .transition(.scale)
                                }
                            }
                        }
                        .padding(.top)
                        
                        
                        // TIMER MODES
                        
                        VStack(alignment: .leading, spacing: 20) {
                            
                            Text("Focus Modes")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            
                            HStack(spacing: 15) {
                                
                                timerModeButton(
                                    title: "25 Min",
                                    time: 1500,
                                    color: .blue
                                )
                                
                                
                                timerModeButton(
                                    title: "45 Min",
                                    time: 2700,
                                    color: .purple
                                )
                                
                                
                                timerModeButton(
                                    title: "60 Min",
                                    time: 3600,
                                    color: .orange
                                )
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(
                                    Color.white.opacity(0.08),
                                    lineWidth: 1
                                )
                        )
                        .cornerRadius(25)
                        
                        
                        // CONTROLS
                        
                        HStack(spacing: 20) {
                            
                            
                            // START / PAUSE
                            
                            Button {
                                
                                timerRunning.toggle()
                                
                                triggerHaptic()
                                
                            } label: {
                                
                                HStack {
                                    
                                    Image(
                                        systemName:
                                            timerRunning
                                        ? "pause.fill"
                                        : "play.fill"
                                    )
                                    
                                    
                                    Text(
                                        timerRunning
                                        ? "Pause"
                                        : "Start"
                                    )
                                    .fontWeight(.bold)
                                }
                                .foregroundColor(.white)
                                .frame(width: 150, height: 60)
                                .background(
                                    LinearGradient(
                                        colors:
                                            timerRunning
                                        ? [.orange, .red]
                                        : [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(20)
                                .shadow(
                                    color: .purple.opacity(0.3),
                                    radius: 10
                                )
                            }
                            .scaleEffect(timerRunning ? 1.02 : 1)
                            .animation(.spring(), value: timerRunning)
                            
                            
                            // RESET
                            
                            Button {
                                
                                timerRunning = false
                                
                                timeRemaining = selectedTime
                                
                                triggerHaptic()
                                
                            } label: {
                                
                                Image(systemName: "arrow.counterclockwise")
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                                    .background(
                                        LinearGradient(
                                            colors: [.red, .pink],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .cornerRadius(20)
                            }
                        }
                        
                        
                        // FOCUS STATS CARD
                        
                        VStack(alignment: .leading, spacing: 15) {
                            
                            HStack {
                                
                                Image(systemName: "brain.head.profile")
                                    .foregroundColor(.purple)
                                
                                
                                Text("Focus Tip")
                                    .font(.title3)
                                    .fontWeight(.bold)
                            }
                            
                            
                            Text("Turn off notifications and keep your phone away for deeper focus sessions.")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color.purple.opacity(0.2),
                                    Color.blue.opacity(0.15)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(
                                    Color.white.opacity(0.08),
                                    lineWidth: 1
                                )
                        )
                        .cornerRadius(25)
                    }
                    .padding()
                }
            }
            .navigationTitle("Timer")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                
                animateBackground.toggle()
            }
            .onReceive(timer) { _ in
                
                if timerRunning && timeRemaining > 0 {
                    
                    timeRemaining -= 1
                }
                
                
                // TIMER FINISHED
                
                if timeRemaining == 0 {
                    
                    timerRunning = false
                    
                    triggerHaptic()
                }
            }
        }
    }
    
    
    // MARK: - TIMER MODE BUTTON
    
    func timerModeButton(
        title: String,
        time: Int,
        color: Color
    ) -> some View {
        
        Button {
            
            selectedTime = time
            
            timeRemaining = time
            
            timerRunning = false
            
            triggerHaptic()
            
        } label: {
            
            Text(title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(color.opacity(0.8))
                .cornerRadius(18)
        }
    }
}


struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
            .preferredColorScheme(.dark)
    }
}
