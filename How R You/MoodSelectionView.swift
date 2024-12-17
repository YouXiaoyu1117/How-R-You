//
//  MoodSelectionView.swift
//  How R You
//
//  Created by XIAOYU YOU on 09/12/24.
//

import SwiftUI

/*struct MoodSelectionView: View {
    // 当前选择的表情
    @State private var selectedMood: String? = nil
    @State private var navigateToDiary = false // 控制是否跳转到日记界面
    
    // 表情的名称数组 (对应 assets 资源名)
    let moods = ["heartface","angryface","orangeface","winkface","happyface", "politeface", "oface", "cryface", "greenface", "purpleface"]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("How R You!\nWhat was your day?")
                                  .font(.title)
                                  .multilineTextAlignment(.center)
                                  .padding()
                // 表情选择网格
                
                
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 0.5), count: 3), // 每列之间的空隙
                    spacing: 30 // 每行之间的空隙
                ) {
                    ForEach(moods, id: \.self) { mood in
                        Button(action: {
                            selectedMood = mood
                        }) {
                            Image(mood)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 75, height: 75)
                                .background(selectedMood == mood ? Color.white : Color.clear)
                                .cornerRadius(8)
                                .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedMood == mood ? Color.blue : Color.clear, lineWidth: 3) // 给选中的表情添加蓝色边框
                                                                )
                        }
                    }
                }
                Spacer()
                
                // NEXT 按钮
                Button(action: {
                    navigateToDiary = true
                }) {
                    Text("NEXT")
                        .fontWeight(.heavy)
                        .frame(width: 170,height: 20)
                        .padding()
                    
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(selectedMood == nil) // 当没有选择表情时禁用按钮
            }
        
            // 配置跳转
            .navigationDestination(isPresented: $navigateToDiary) {
                DiaryEditView(selectedMood: selectedMood ?? "", date: Date())
            }
        }
    }
}*/


struct MoodSelectionView: View {
    // 使用 @Binding 接收父视图传递的 selectedDate 和 emojiDates
    @Binding var selectedDate: Date
    @Binding var emojiDates: [String: String]

    @State private var selectedMood: String? = nil
    @State private var navigateToDiary = false // 导航到日记编辑界面

    let moods = ["heartface", "angryface", "orangeface", "winkface", "happyface", "politeface", "oface", "cryface", "greenface", "purpleface"]

    var body: some View {
        VStack {
            Text("How R You!\nWhat was your day?")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
                .font(.system(size: 24)) // 设置字体大小为24
                .fontWeight(.bold)

            // 显示表情选择按钮
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 0.5), count: 3),
                spacing: 30
            ) {
                ForEach(moods, id: \.self) { mood in
                    Button(action: {
                        selectedMood = mood
                    }) {
                        Image(mood)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 75)
                            .background(selectedMood == mood ? Color.white : Color.clear)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedMood == mood ? Color.blue : Color.clear, lineWidth: 3)
                            )
                    }
                }
            }
            
            Spacer()

            Button(action: {
                if let selectedMood = selectedMood {
                    // 将选中的表情保存到 emojiDates 中
                    emojiDates[formatDate(selectedDate)] = selectedMood
                    navigateToDiary = true
                }
            }) {
                Text("NEXT")
                    .fontWeight(.heavy)
                    .frame(width: 170, height: 20)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(selectedMood == nil)

            // 导航到 DiaryEditView
            NavigationLink(
                destination: DiaryEditView(selectedMood: selectedMood ?? "", date: selectedDate),
                isActive: $navigateToDiary
            ) {
                EmptyView()
            }
        }
    }
   

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

/*
 #Preview {
    MoodSelectionView(selectedDate: , emojiDates: <#Binding<[String : String]>#>)
}
*/
