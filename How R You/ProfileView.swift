//
//  ProfileView.swift
//  How R You
//
//  Created by XIAOYU YOU on 09/12/24.
//

/*import SwiftUI

struct Avatar{
    let name: String
    let moodIcon: String
    let image: Data
}

struct ProfileView: View {
    @State private var userName: String = "Your Name"  // 用户名
    @State private var selectedAvatar: String? = nil   // 头像选择
    @State private var navigateToCustomExpression = false // 控制是否跳转到自定义表情界面
    
    let avatars = ["avatar1", "avatar2", "avatar3", "avatar4"] // 假设是你的头像图片名字
    let moodIcons = ["heartface","angryface","orangeface","winkface","happyface", "politeface", "oface", "cryface", "greenface", "purpleface"] // 初始表情图标
    
    var body: some View {
        NavigationStack {  // 使用 NavigationStack 包裹整个视图
            ScrollView {
           
                    TextField("Edit your name", text: $userName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                ZStack{ // 头像网格选择
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(avatars, id: \.self) { avatar in
                            Button(action: {
                                selectedAvatar = avatar
                            }) {
                                Image(avatar)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 120)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(selectedAvatar == avatar ? Color.blue : Color.white, lineWidth: 3))
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                    
                    // 初始表情选择
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: 7), count: 3), // 每列之间的空隙
                        spacing: 30 // 每行之间的空隙
                    ) {
                        ForEach(moodIcons, id: \.self) { mood in
                            Button(action: {
                                // 这里可以选择表情的逻辑
                            }) {
                                Image(mood)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                            }
                        }
                    }
                }
                    .padding()
                    
                    // 加号按钮，跳转到自定义表情界面
                    NavigationLink(value: "customExpression") {  // 使用新的 NavigationLink
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.blue)
                            Text("Design Custom Expression")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    
                    
                    // 跳转到自定义表情设计界面
                    .navigationDestination(for: String.self) { value in
                        if value == "customExpression" {
                            CustomExpressionView(onSave: { image in
                                // 在这里处理保存的图像
                                print("Saved custom expression: \(image)")
                            })
                        
                    }
                } // 关闭 VStack
            } // 关闭 NavigationStack
        }
    }
}
#Preview {
    ProfileView()
}*/


/*
import SwiftUI

struct Avatar {
    let name: String
    let moodIcon: String
    let image: Data
}

struct ProfileView: View {
    @State private var userName: String = "Your Name" // 用户名
    @State private var selectedAvatar: UIImage? = nil // 当前选中的头像或表情
    @State private var customExpressions: [UIImage] = [] // 存储自定义表情

    let defaultMoodIcons = ["heartface", "angryface", "orangeface", "winkface", "happyface", "politeface", "oface", "cryface", "greenface", "purpleface"] // 初始表情图标

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 顶部头像框
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray, lineWidth: 2)
                            .frame(width: 100, height: 100) // 使头像框尺寸与下面的表情框一致

                        if let avatar = selectedAvatar {
                            Image(uiImage: avatar)
                                .resizable()
                                .scaledToFill() // 确保填满框架
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 10)) // 裁剪成圆角矩形
                        } else {
                            Text("Avatar")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                    }
                    
                    // 用户名输入框
                    TextField("Edit your name", text: $userName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 150) // 限制输入框宽度
                        .padding(.top, 8)
                }
    
                Divider()

                // 表情选择网格
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                        // 默认表情
                        ForEach(defaultMoodIcons, id: \.self) { mood in
                            Button(action: {
                                if let image = UIImage(named: mood) {
                                    selectedAvatar = image
                                }
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 100, height: 120)
                                    Image(mood)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 75, height: 75)
                                }
                            }
                        }

                        // 自定义表情
                        ForEach(customExpressions, id: \.self) { expression in
                            Button(action: {
                                selectedAvatar = expression
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 100, height: 120)
                                    Image(uiImage: expression)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 75, height: 75)
                                }
                            }
                        }
                        
                        // 加号按钮
                        NavigationLink(destination: CustomExpressionView(onSave: { image in
                            // 保存自定义表情
                            customExpressions.append(image)
                        })) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 100, height: 120)
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding()
            }
           
        }
    }
}

#Preview {
    ProfileView()
}*/



/*
import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var context // SwiftData 上下文
    @Query private var customExpressions: [CustomExpression] // 查询已保存的表情

    @State private var userName: String = "Your Name"
    @State private var selectedAvatar: UIImage? = nil
    @State private var isEditing: Bool = false // 是否处于编辑模式

    let defaultMoodIcons = ["heartface","angryface","orangeface","winkface","happyface", "politeface", "oface", "cryface", "greenface", "purpleface"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 顶部头像框
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray, lineWidth: 2)
                            .frame(width: 100, height: 100)
                        
                        if let avatar = selectedAvatar {
                            Image(uiImage: avatar)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            Text("Avatar")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                    }
                    TextField("Edit your name", text: $userName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 150)
                }
                
                Divider()
                
                // 表情选择
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                        // 默认表情
                        ForEach(defaultMoodIcons, id: \.self) { mood in
                            Button {
                                selectedAvatar = UIImage(named: mood)
                            } label: {
                                Image(mood)
                                    .resizable()
                                    .frame(width: 75, height: 75)
                            }
                        }

                        // 自定义表情
                        ForEach(customExpressions) { expression in
                            Button {
                                selectedAvatar = expression.image
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray.opacity(0.2))
                                    if let image = expression.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                    }
                                }
                                .frame(width: 100, height: 100)
                            }
                            .onLongPressGesture {
                                editOrDeleteExpression(expression: expression)
                            }
                        }
                        
                        // 添加按钮
                        NavigationLink {
                            CustomExpressionView { newImage in
                                saveCustomExpression(image: newImage)
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.2))
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                                    .foregroundColor(.blue)
                            }
                            .frame(width: 100, height: 100)
                        }
                    }
                }
            }
            .padding()
        }
    }

    // 保存表情到 SwiftData
    private func saveCustomExpression(image: UIImage) {
        let newExpression = CustomExpression(image: image)
        context.insert(newExpression)
    }

    // 编辑或删除表情
    private func editOrDeleteExpression(expression: CustomExpression) {
        let actionSheet = UIAlertController(title: "Edit or Delete", message: "What do you want to do?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            // 进入编辑模式
            editExpression(expression: expression)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            context.delete(expression)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(actionSheet, animated: true)
        }
    }

    private func editExpression(expression: CustomExpression) {
            NavigationLink {
                CustomExpressionView(onSave: { image in
                    // 保存图像到 SwiftData 数据模型
                    let newExpression = CustomExpression(image: image)
                    context.insert(newExpression) // 假设你使用 SwiftData 的上下文
                }, initialImage: selectedAvatar) // 编辑时传入已选中的表情图像
            } label: {
                Image(systemName: "pencil")
                    .foregroundColor(.blue)
            }
    }
}

#Preview {
    ProfileView()
}*/





import SwiftUI

struct ProfileView: View {
    @State private var userName: String = "Your Name" // 用户名
    @State private var selectedAvatar: UIImage? = nil // 当前选中的头像或表情
    @State private var customExpressions: [UIImage] = [] // 存储自定义表情

    @State private var isEditingExpression = false // 控制是否进入编辑模式
    @State private var expressionToEdit: UIImage? = nil // 当前要编辑的表情

    let defaultMoodIcons = ["heartface", "angryface", "orangeface", "winkface", "happyface", "politeface", "oface", "cryface", "greenface", "purpleface"] // 初始表情图标

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 顶部头像框
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray, lineWidth: 2)
                            .frame(width: 100, height: 100)

                        if let avatar = selectedAvatar {
                            Image(uiImage: avatar)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            Text("Avatar")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                    }
                    TextField("Edit your name", text: $userName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 150)
                        .padding(.top, 8)
                }
                Divider()

                // 表情选择网格
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                        // 默认表情
                        ForEach(defaultMoodIcons, id: \.self) { mood in
                            Button(action: {
                                if let image = UIImage(named: mood) {
                                    selectedAvatar = image
                                }
                            }) {
                                expressionCell(image: UIImage(named: mood)!)
                            }
                        }

                        // 自定义表情
                        ForEach(Array(customExpressions.enumerated()), id: \.element) { index, expression in
                            expressionCell(image: expression)
                                .contextMenu {
                                    Button("Edit") {
                                        expressionToEdit = expression
                                        isEditingExpression = true
                                    }
                                    Button("Delete", role: .destructive) {
                                        customExpressions.remove(at: index)
                                    }
                                }
                        }

                        // 加号按钮
                        NavigationLink(destination: CustomExpressionView(onSave: { image in
                            customExpressions.append(image)
                        })) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 100, height: 120)
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationDestination(isPresented: $isEditingExpression) {
                if let initialImage = expressionToEdit {
                    CustomExpressionView(
                        onSave: { updatedImage in
                            if let index = customExpressions.firstIndex(of: initialImage) {
                                customExpressions[index] = updatedImage // 更新表情
                            }
                            isEditingExpression = false
                        },
                        initialImage: initialImage // 传入初始图像
                    )
                }
            }
        }
    }

    // 单个表情视图
    private func expressionCell(image: UIImage) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 100, height: 120)
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75)
        }
    }
}

#Preview {
    ProfileView()
}

