//
//  CalendarView.swift
//  How R You
//
//  Created by XIAOYU YOU on 05/12/24.
//

/* import SwiftUI

struct CalendarView: View {
    @State private var selectedDate: Date = Date() // 当前选中的日期
    private let calendar = Calendar.current
    @State private var navigateToMoodSelection = false // 控制跳转到 MoodSelectionView 的状态
    @State private var isAlreadyFilled = false

    // 日期与表情的映射
    @State var emojiDates: [String: String] = [
        "2024-12-01": "happyface",
        "2024-12-02": "heartface",
        "2024-12-03": "angryface",
        "2024-12-04": "orangeface",
        "2024-12-05": "politeface",
        "2024-12-06": "winkface",
        "2024-12-07": "oface",
        "2024-12-08": "greenface",
        "2024-12-09": "purpleface",
        "2024-12-10": "happyface"
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // 月份标题
                HStack {
                    /*  Text(getMonthAndYear(from: selectedDate))
                        .font(.title2)
                        .fontWeight(.bold)
                    
                   DatePicker("", selection: $selectedDate, in: Date.now..., displayedComponents: .date)
                        */
                    // 自定义DatePicker
                    DatePicker("Select Your Day :D", selection: $selectedDate, displayedComponents: .date)
                                 .datePickerStyle(CompactDatePickerStyle()) // 去除灰色框
                                 .font(.system(size: 24)) // 设置字体大小为24
                                 .fontWeight(.bold)
            
                    
                    Spacer()
                }
                .padding(.horizontal)

                // 星期标题
                HStack {
                    ForEach(["M", "T", "W", "T", "F", "S", "S"], id: \.self) { day in
                        Text(day)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)

                // 日期网格
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                    let daysInMonth = getDaysInMonth(for: selectedDate)
                    let firstWeekday = getFirstWeekday(for: selectedDate)
                    
                    // 添加空白单元格
                    ForEach(0..<firstWeekday, id: \.self) { _ in
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 50)
                    }
                    
                    // 添加日期单元格
                    ForEach(daysInMonth, id: \.self) { date in
                        VStack {
                            if let emojiName = emojiDates[formatDate(date)] {
                                // 如果有表情，显示表情
                                Image(emojiName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .onTapGesture {
                                        selectedDate = date
                                        isAlreadyFilled.toggle()
                                    }
                            } else {
                                // 否则显示一个占位方块
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(5)
                                    .onTapGesture {
                                        selectedDate = date
                                        navigateToMoodSelection = true // 触发导航
                                    }
                            }
                            // 显示日期数字
                            Text("\(calendar.component(.day, from: date))")
                                .foregroundColor(.primary)
                        }
                        
                    }
                }
                .padding(.horizontal)

                Spacer()

                // 隐藏的 NavigationLink
                NavigationLink(
                    destination: MoodSelectionView(selectedDate: $selectedDate, emojiDates: $emojiDates),
                    isActive: $navigateToMoodSelection
                ) {
                    EmptyView() // 通过点击日期触发导航
                }
                
                NavigationLink(
                    destination: DiaryEditView(selectedMood: "", date: selectedDate),
                    isActive: $isAlreadyFilled
                ) {
                    EmptyView() // 通过点击日期触发导航
                }
            }
            .padding(.vertical)
        }
    }

    // 获取当前月份和年份
    private func getMonthAndYear(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MMMM"
        return formatter.string(from: date)
    }

    // 获取当前月份的所有天数
    private func getDaysInMonth(for date: Date) -> [Date] {
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date)),
              let range = calendar.range(of: .day, in: .month, for: date) else {
            return []
        }

        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: monthStart)
        }
    }

    // 获取当前月份第一天是星期几（从 0 开始，表示周一到周日）
    private func getFirstWeekday(for date: Date) -> Int {
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return 0
        }
        let weekday = calendar.component(.weekday, from: monthStart)
        return (weekday + 5) % 7 // 转换为 0 表示周一，6 表示周日
    }

    // 格式化日期为 "yyyy-MM-dd"
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}



#Preview {
    CalendarView()
}  */

import SwiftUI

struct CalendarView: View {
    @State private var selectedDate: Date = Date() // 当前选中的日期
    private let calendar = Calendar.current
    @State private var navigateToMoodSelection = false // 控制跳转到 MoodSelectionView 的状态
    @State private var isAlreadyFilled = false

    // 日期与表情的映射
    @State var emojiDates: [String: String] = [
        "2024-12-01": "happyface",
        "2024-12-02": "heartface",
        "2024-12-03": "angryface",
        "2024-12-04": "orangeface",
        "2024-12-05": "politeface",
        "2024-12-06": "winkface",
        "2024-12-07": "oface",
        "2024-12-08": "greenface",
        "2024-12-09": "purpleface",
        "2024-12-10": "happyface"
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // 月份标题
                HStack {
                    // 自定义DatePicker
                    DatePicker("Select Your Day :D", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle()) // 去除灰色框
                        .font(.system(size: 24)) // 设置字体大小为24
                        .fontWeight(.bold)
                        .accessibilityLabel("Select the date for mood tracking")
                        .accessibilityHint("Tap to choose a date to track your mood.")
                    
                    Spacer()
                }
                .padding(.horizontal)

                // 星期标题
                HStack {
                    ForEach(["M", "T", "W", "T", "F", "S", "S"], id: \.self) { day in
                        Text(day)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .accessibilityLabel("Day \(day)") // Adding accessibility label for each weekday
                    }
                }
                .padding(.horizontal)

                // 日期网格
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                    let daysInMonth = getDaysInMonth(for: selectedDate)
                    let firstWeekday = getFirstWeekday(for: selectedDate)
                    
                    // 添加空白单元格
                    ForEach(0..<firstWeekday, id: \.self) { _ in
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 50)
                            .accessibilityHidden(true) // This cell is empty, so it's hidden for VoiceOver
                    }
                    
                    // 添加日期单元格
                    ForEach(daysInMonth, id: \.self) { date in
                        VStack {
                            if let emojiName = emojiDates[formatDate(date)] {
                                // 如果有表情，显示表情
                                Image(emojiName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .onTapGesture {
                                        selectedDate = date
                                        isAlreadyFilled.toggle()
                                    }
                                    .accessibilityLabel("Mood: \(emojiName)") // Accessibility label for the emoji
                                    .accessibilityHint("Tap to view or update your mood")
                                    .accessibilityAddTraits(.isButton) // Correct way to add button trait
                            } else {
                                // 否则显示一个占位方块
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(5)
                                    .onTapGesture {
                                        selectedDate = date
                                        navigateToMoodSelection = true // 触发导航
                                    }
                                    .accessibilityLabel("Empty, tap to select mood for \(calendar.component(.day, from: date))")
                                    .accessibilityHint("Tap to choose a mood for the day")
                                    .accessibilityAddTraits(.isButton) // Correct way to add button trait
                            }
                            // 显示日期数字
                            Text("\(calendar.component(.day, from: date))")
                                .foregroundColor(.primary)
                                .accessibilityLabel("Date \(calendar.component(.day, from: date))") // Accessibility label for the date number
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()

                // 隐藏的 NavigationLink
                NavigationLink(
                    destination: MoodSelectionView(selectedDate: $selectedDate, emojiDates: $emojiDates),
                    isActive: $navigateToMoodSelection
                ) {
                    EmptyView() // 通过点击日期触发导航
                }
                
                NavigationLink(
                    destination: DiaryEditView(selectedMood: "", date: selectedDate),
                    isActive: $isAlreadyFilled
                ) {
                    EmptyView() // 通过点击日期触发导航
                }
            }
            .padding(.vertical)
        }
    }

    // 获取当前月份和年份
    private func getMonthAndYear(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MMMM"
        return formatter.string(from: date)
    }

    // 获取当前月份的所有天数
    private func getDaysInMonth(for date: Date) -> [Date] {
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date)),
              let range = calendar.range(of: .day, in: .month, for: date) else {
            return []
        }

        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: monthStart)
        }
    }

    // 获取当前月份第一天是星期几（从 0 开始，表示周一到周日）
    private func getFirstWeekday(for date: Date) -> Int {
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return 0
        }
        let weekday = calendar.component(.weekday, from: monthStart)
        return (weekday + 5) % 7 // 转换为 0 表示周一，6 表示周日
    }

    // 格式化日期为 "yyyy-MM-dd"
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

#Preview {
    CalendarView()
}
