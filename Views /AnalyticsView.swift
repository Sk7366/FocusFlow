import SwiftUI
import Charts

struct ProductivityData: Identifiable {
    
    let id = UUID()
    let day: String
    let tasks: Int
}

struct AnalyticsView: View {
    
    // MARK: - DATA
    
    let productivityData = [
        ProductivityData(day: "Mon", tasks: 3),
        ProductivityData(day: "Tue", tasks: 5),
        ProductivityData(day: "Wed", tasks: 2),
        ProductivityData(day: "Thu", tasks: 6),
        ProductivityData(day: "Fri", tasks: 4),
        ProductivityData(day: "Sat", tasks: 7),
        ProductivityData(day: "Sun", tasks: 5)
    ]
    
    
    // MARK: - STATES
    
    @State private var animateCards = false
    
    @State private var animateBackground = false
    
    
    // MARK: - CALCULATIONS
    
    var totalTasks: Int {
        productivityData.reduce(0) { $0 + $1.tasks }
    }
    
    var averageTasks: Double {
        Double(totalTasks) / Double(productivityData.count)
    }
    
    var mostProductiveDay: ProductivityData {
        productivityData.max(by: { $0.tasks < $1.tasks })!
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
                        
                        
                        // HEADER
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Text("Productivity Analytics")
                                .font(
                                    .system(
                                        size: 34,
                                        weight: .bold
                                    )
                                )
                            
                            
                            Text("Track your focus journey 📈")
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .opacity(animateCards ? 1 : 0)
                        .offset(y: animateCards ? 0 : 20)
                        
                        
                        // MAIN CHART CARD
                        
                        VStack(alignment: .leading, spacing: 20) {
                            
                            HStack {
                                
                                VStack(alignment: .leading) {
                                    
                                    Text("Weekly Focus")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    
                                    Text("Tasks completed this week")
                                        .foregroundColor(.secondary)
                                        .font(.subheadline)
                                }
                                
                                Spacer()
                                
                                
                                Image(systemName: "chart.bar.fill")
                                    .font(.title2)
                                    .foregroundColor(.purple)
                            }
                            
                            
                            Chart(productivityData) { data in
                                
                                BarMark(
                                    x: .value("Day", data.day),
                                    y: .value("Tasks", data.tasks)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            .blue,
                                            .purple,
                                            .pink
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .cornerRadius(8)
                                .annotation(position: .top) {
                                    
                                    Text("\(data.tasks)")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                            }
                            .frame(height: 260)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(
                                    Color.white.opacity(0.08),
                                    lineWidth: 1
                                )
                        )
                        .cornerRadius(25)
                        .shadow(
                            color: .purple.opacity(0.2),
                            radius: 12
                        )
                        .opacity(animateCards ? 1 : 0)
                        .offset(y: animateCards ? 0 : 30)
                        
                        
                        // STATS GRID
                        
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 15
                        ) {
                            
                            
                            // TOTAL TASKS
                            
                            statsCard(
                                title: "Tasks Done",
                                value: "\(totalTasks)",
                                icon: "checkmark.circle.fill",
                                colors: [
                                    .blue.opacity(0.25),
                                    .purple.opacity(0.2)
                                ]
                            )
                            
                            
                            // EFFICIENCY
                            
                            statsCard(
                                title: "Efficiency",
                                value: "87%",
                                icon: "bolt.fill",
                                colors: [
                                    .green.opacity(0.25),
                                    .mint.opacity(0.2)
                                ]
                            )
                            
                            
                            // AVERAGE
                            
                            statsCard(
                                title: "Daily Avg",
                                value: String(format: "%.1f", averageTasks),
                                icon: "chart.line.uptrend.xyaxis",
                                colors: [
                                    .orange.opacity(0.25),
                                    .yellow.opacity(0.2)
                                ]
                            )
                            
                            
                            // BEST DAY
                            
                            statsCard(
                                title: "Best Day",
                                value: mostProductiveDay.day,
                                icon: "crown.fill",
                                colors: [
                                    .pink.opacity(0.25),
                                    .purple.opacity(0.2)
                                ]
                            )
                        }
                        .opacity(animateCards ? 1 : 0)
                        .offset(y: animateCards ? 0 : 40)
                        
                        
                        // PRODUCTIVITY SCORE
                        
                        VStack(alignment: .leading, spacing: 20) {
                            
                            HStack {
                                
                                Text("Productivity Score")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Text("87")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                            
                            
                            GeometryReader { geometry in
                                
                                ZStack(alignment: .leading) {
                                    
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(
                                            Color.white.opacity(0.08)
                                        )
                                        .frame(height: 18)
                                    
                                    
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    .green,
                                                    .mint
                                                ],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(
                                            width: geometry.size.width * 0.87,
                                            height: 18
                                        )
                                }
                            }
                            .frame(height: 18)
                            
                            
                            Text("You're performing better than 87% of users this week 🚀")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(
                                    Color.white.opacity(0.08),
                                    lineWidth: 1
                                )
                        )
                        .cornerRadius(25)
                        
                        
                        // AI SUMMARY CARD
                        
                        VStack(alignment: .leading, spacing: 18) {
                            
                            HStack {
                                
                                Image(systemName: "brain.head.profile")
                                    .foregroundColor(.purple)
                                
                                
                                Text("AI Summary")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                
                                Image(systemName: "sparkles")
                                    .foregroundColor(.yellow)
                            }
                            
                            
                            Text("Your productivity improved significantly this week 🚀")
                                .font(.headline)
                            
                            
                            Text("Consistency score increased by 12% compared to last week. Your strongest productivity period was during the weekend.")
                                .foregroundColor(.secondary)
                            
                            
                            HStack {
                                
                                Label(
                                    "Highly Focused",
                                    systemImage: "flame.fill"
                                )
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    Color.orange.opacity(0.2)
                                )
                                .cornerRadius(20)
                                
                                
                                Label(
                                    "Consistent",
                                    systemImage: "checkmark.seal.fill"
                                )
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    Color.green.opacity(0.2)
                                )
                                .cornerRadius(20)
                            }
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
                        .offset(y: animateCards ? 0 : 50)
                    }
                    .padding()
                }
            }
            .navigationTitle("Analytics")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                
                animateBackground.toggle()
                
                withAnimation(.easeOut(duration: 0.8)) {
                    animateCards = true
                }
            }
        }
    }
    
    
    // MARK: - STATS CARD
    
    func statsCard(
        title: String,
        value: String,
        icon: String,
        colors: [Color]
    ) -> some View {
        
        VStack(spacing: 15) {
            
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.white)
            
            
            Text(value)
                .font(.system(size: 30, weight: .bold))
            
            
            Text(title)
                .foregroundColor(.secondary)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            LinearGradient(
                colors: colors,
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
        .shadow(radius: 10)
    }
}


struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
            .preferredColorScheme(.dark)
    }
}
