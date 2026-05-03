import SwiftUI
import UIKit

struct DashboardView: View {
    
    // MARK: - DYNAMIC PROGRESS
    
    var progress: Double {
        
        if tasks.isEmpty {
            return 0
        }
        
        let completedTasks = tasks.filter { $0.isCompleted }.count
        
        return Double(completedTasks) / Double(tasks.count)
    }
    
    
    // MARK: - AI PRODUCTIVITY INSIGHTS
    
    var productivityInsight: String {
        
        let completedTasks = tasks.filter { $0.isCompleted }.count
        
        if tasks.isEmpty {
            return "Start adding tasks to build productivity 🚀"
        }
        
        if completedTasks == tasks.count {
            return "Amazing work! You completed everything today 🔥"
        }
        
        if progress >= 0.7 {
            return "Great consistency today! Keep the momentum going 🚀"
        }
        
        if progress >= 0.4 {
            return "Good progress so far. Stay focused 💪"
        }
        
        return "Try completing a few more tasks to boost productivity 🎯"
    }
    
    
    // MARK: - STATES
    
    @State private var tasks = [
        Task(title: "Complete SwiftUI UI", isCompleted: true),
        Task(title: "Practice coding", isCompleted: false),
        Task(title: "Push project to GitHub", isCompleted: false)
    ]
    
    @State private var newTask = ""
    
    @State private var animateCards = false
    
    @State private var animateBackground = false
    
    
    // MARK: - STREAK STORAGE
    
    @AppStorage("currentStreak") private var currentStreak = 0
    
    @AppStorage("lastCompletedDate") private var lastCompletedDate = ""
    
    
    // MARK: - SAVE TASKS
    
    func saveTasks() {
        
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }
    
    
    // MARK: - LOAD TASKS
    
    func loadTasks() {
        
        if let savedTasks = UserDefaults.standard.data(forKey: "tasks"),
           let decoded = try? JSONDecoder().decode([Task].self, from: savedTasks) {
            
            tasks = decoded
        }
    }
    
    
    // MARK: - UPDATE STREAK
    
    func updateStreak() {
        
        let today = Date.now.formatted(date: .numeric, time: .omitted)
        
        if progress >= 0.7 {
            
            if lastCompletedDate != today {
                
                currentStreak += 1
                
                lastCompletedDate = today
            }
            
        } else {
            
            currentStreak = 0
        }
    }
    
    
    // MARK: - HAPTIC FEEDBACK
    
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
                    
                    VStack(spacing: 25) {
                        
                        
                        // GREETING
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            HStack {
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    
                                    Text("Hello, Sai 👋")
                                        .font(.system(size: 34, weight: .bold))
                                    
                                    Text("Stay focused and productive today.")
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                
                                Image(systemName: "bell.badge.fill")
                                    .font(.title2)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.yellow, .orange],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .opacity(animateCards ? 1 : 0)
                        .offset(y: animateCards ? 0 : 20)
                        
                        
                        // PROGRESS RING
                        
                        ZStack {
                            
                            Circle()
                                .stroke(
                                    Color.white.opacity(0.08),
                                    lineWidth: 18
                                )
                                .frame(width: 210, height: 210)
                            
                            
                            Circle()
                                .trim(from: 0, to: progress)
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
                                .frame(width: 210, height: 210)
                                .rotationEffect(.degrees(-90))
                                .shadow(color: .purple.opacity(0.5), radius: 12)
                                .animation(
                                    .spring(response: 0.8),
                                    value: progress
                                )
                            
                            
                            VStack(spacing: 10) {
                                
                                Text("\(Int(progress * 100))%")
                                    .font(
                                        .system(
                                            size: 46,
                                            weight: .bold
                                        )
                                    )
                                
                                
                                Text("Daily Goal")
                                    .foregroundColor(.secondary)
                                
                                
                                if progress >= 0.7 {
                                    
                                    Text("🔥 On Fire")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            Color.orange.opacity(0.2)
                                        )
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding()
                        .scaleEffect(animateCards ? 1 : 0.8)
                        .opacity(animateCards ? 1 : 0)
                        
                        
                        // AI INSIGHTS CARD
                        
                        VStack(alignment: .leading, spacing: 15) {
                            
                            HStack {
                                
                                Image(systemName: "sparkles")
                                    .foregroundColor(.yellow)
                                
                                
                                Text("AI Insights")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                                
                                Spacer()
                                
                                
                                Image(systemName: "waveform.path.ecg")
                                    .foregroundColor(.purple)
                            }
                            
                            
                            Text(productivityInsight)
                                .font(.headline)
                            
                            
                            Text("Based on your productivity patterns and completed tasks.")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color.purple.opacity(0.25),
                                    Color.blue.opacity(0.18)
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
                        .shadow(
                            color: .purple.opacity(0.25),
                            radius: 15
                        )
                        .opacity(animateCards ? 1 : 0)
                        .offset(y: animateCards ? 0 : 30)
                        
                        
                        // STREAK CARD
                        
                        VStack(spacing: 15) {
                            
                            HStack {
                                
                                ZStack {
                                    
                                    Circle()
                                        .fill(
                                            Color.orange.opacity(0.2)
                                        )
                                        .frame(width: 60, height: 60)
                                    
                                    
                                    Image(systemName: "flame.fill")
                                        .foregroundColor(.orange)
                                        .font(.system(size: 30))
                                }
                                
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    
                                    Text("\(currentStreak) Day Streak")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    
                                    Text("Consistency builds success 🔥")
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color.orange.opacity(0.25),
                                    Color.red.opacity(0.15)
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
                        .shadow(
                            color: .orange.opacity(0.3),
                            radius: 12
                        )
                        .scaleEffect(currentStreak > 0 ? 1 : 0.95)
                        .animation(.spring(), value: currentStreak)
                        
                        
                        // TASKS CARD
                        
                        VStack(alignment: .leading, spacing: 20) {
                            
                            HStack {
                                
                                Text("Today's Tasks")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                Text("\(tasks.count)")
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Color.blue.opacity(0.2)
                                    )
                                    .cornerRadius(20)
                            }
                            
                            
                            // ADD TASK
                            
                            HStack(spacing: 15) {
                                
                                TextField(
                                    "Add new task...",
                                    text: $newTask
                                )
                                .padding()
                                .background(
                                    Color.white.opacity(0.08)
                                )
                                .cornerRadius(16)
                                
                                
                                Button {
                                    
                                    if !newTask.isEmpty {
                                        
                                        withAnimation(.spring()) {
                                            
                                            tasks.append(
                                                Task(
                                                    title: newTask,
                                                    isCompleted: false
                                                )
                                            )
                                            
                                            saveTasks()
                                            
                                            updateStreak()
                                            
                                            triggerHaptic()
                                            
                                            newTask = ""
                                        }
                                    }
                                    
                                } label: {
                                    
                                    Image(systemName: "plus")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(
                                            LinearGradient(
                                                colors: [.blue, .purple],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .clipShape(Circle())
                                        .shadow(
                                            color: .purple.opacity(0.5),
                                            radius: 8
                                        )
                                }
                                .scaleEffect(newTask.isEmpty ? 0.95 : 1)
                                .animation(.spring(), value: newTask)
                            }
                            
                            
                            // TASK LIST
                            
                            ForEach(tasks.indices, id: \.self) { index in
                                
                                HStack(spacing: 15) {
                                    
                                    Image(
                                        systemName:
                                            tasks[index].isCompleted
                                        ? "checkmark.circle.fill"
                                        : "circle"
                                    )
                                    .foregroundColor(
                                        tasks[index].isCompleted
                                        ? .green
                                        : .gray
                                    )
                                    .font(.title2)
                                    .onTapGesture {
                                        
                                        withAnimation(.spring()) {
                                            
                                            tasks[index]
                                                .isCompleted.toggle()
                                            
                                            saveTasks()
                                            
                                            updateStreak()
                                            
                                            triggerHaptic()
                                        }
                                    }
                                    
                                    
                                    Text(tasks[index].title)
                                        .strikethrough(
                                            tasks[index].isCompleted
                                        )
                                        .foregroundColor(
                                            tasks[index].isCompleted
                                            ? .secondary
                                            : .primary
                                        )
                                    
                                    Spacer()
                                    
                                    
                                    Button {
                                        
                                        withAnimation(.spring()) {
                                            
                                            tasks.remove(at: index)
                                            
                                            saveTasks()
                                            
                                            updateStreak()
                                            
                                            triggerHaptic()
                                        }
                                        
                                    } label: {
                                        
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding()
                                .background(
                                    Color.white.opacity(0.05)
                                )
                                .cornerRadius(18)
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
                        .shadow(radius: 10)
                        .opacity(animateCards ? 1 : 0)
                        .offset(y: animateCards ? 0 : 40)
                    }
                    .padding()
                }
            }
            .navigationTitle("FocusFlow")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                
                loadTasks()
                
                updateStreak()
                
                animateBackground.toggle()
                
                withAnimation(.easeOut(duration: 0.8)) {
                    animateCards = true
                }
            }
        }
    }
}


struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .preferredColorScheme(.dark)
    }
}
