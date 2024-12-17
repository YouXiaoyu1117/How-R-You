import SwiftUI

struct CustomExpressionView: View {
    var onSave: (UIImage) -> Void // 保存绘图结果的回调
    var initialImage: UIImage? = nil // 添加初始图像
    @Environment(\.presentationMode) var presentationMode // 环境变量，用于返回上一个界面

    @State private var selectedColor: Color = .black // 默认画笔颜色
    @State private var brushSize: CGFloat = 5 // 默认画笔粗细
    @State private var canvasColor: Color = .white // 默认画布颜色
    @State private var paths: [PathData] = [] // 存储绘制的路径
    @State private var currentPath: [CGPoint] = [] // 当前路径
    @State private var isEraserMode: Bool = false // 是否为橡皮擦模式

    // PathData 结构体
      struct PathData {
          var points: [CGPoint]
          var color: Color
          var lineWidth: CGFloat
      }

    var body: some View {
        VStack {
            Spacer()
            // 圆角画布
            ZStack {
                Rectangle()
                    .fill(canvasColor) // 动态绑定背景颜色
                    .frame(width: 300, height: 300)
                    .cornerRadius(20)
                    .shadow(radius: 4)
                
                // 显示初始图像
                          if let image = initialImage {
                              Image(uiImage: image)
                                  .resizable()
                                  .scaledToFit()
                                  .frame(width: 300, height: 300)
                                  .cornerRadius(20)
                          }

                // Canvas 绘制区域
                Canvas { context, _ in
                    for pathData in paths {
                        var path = Path()
                        path.addLines(pathData.points)
                        context.stroke(path, with: .color(pathData.color), lineWidth: pathData.lineWidth)
                    }

                    // 当前路径
                    if !currentPath.isEmpty {
                        var path = Path()
                        path.addLines(currentPath)
                        context.stroke(path, with: .color(selectedColor), lineWidth: brushSize)
                    }
                }
                .frame(width: 300, height: 300)
                .cornerRadius(20)
                .clipped()
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let point = value.location
                            if isEraserMode {
                                erasePath(at: point)
                            } else {
                                currentPath.append(point)
                            }
                        }
                        .onEnded { _ in
                            if !isEraserMode {
                                // 保存当前路径
                                paths.append(PathData(points: currentPath, color: selectedColor, lineWidth: brushSize))
                                currentPath = [] // 清空当前路径
                            }
                        }
                )
            }

            Spacer()

            // 工具栏
            HStack {
                // 改变画布颜色
                Button(action: {
                    canvasColor = selectedColor // 设置圆角画板背景颜色
                }) {
                    Image(systemName: "face.smiling")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                        .padding()
                }

                // 画笔模式
                Button(action: {
                    isEraserMode = false // 切换为画笔模式
                }) {
                    Image(systemName: "pencil.tip")
                        .font(.system(size: 30))
                        .foregroundColor(isEraserMode ? .gray : .blue)
                        .padding()
                }

                // 橡皮擦模式
                Button(action: {
                    isEraserMode = true // 切换为橡皮擦模式
                }) {
                    Image(systemName: "eraser")
                        .font(.system(size: 30))
                        .foregroundColor(isEraserMode ? .red : .gray)
                        .padding()
                }

                // 撤销
                Button(action: {
                    if !paths.isEmpty {
                        paths.removeLast() // 移除最后一条路径
                    }
                }) {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                        .padding()
                }
            }

            // 底部颜色选择器和粗细调整
            VStack {
                // 颜色选择器
                HStack {
                    ForEach([Color.red, Color.orange, Color.yellow, Color.green, Color.blue, Color.purple, Color.black], id: \.self) { color in
                        ZStack {
                            if color == selectedColor {
                                // 白色圆圈包裹
                                Circle()
                                    .stroke(Color.blue, lineWidth: 4)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        // 对号符号
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 16))
                                    )
                            }

                            // 颜色圆圈
                            Circle()
                                .fill(color)
                                .frame(width: 30, height: 30)
                        }
                        .onTapGesture {
                            selectedColor = color // 改变选中的颜色
                        }
                    }
                }
                .padding()

                // 画笔粗细调整
                if !isEraserMode {
                    HStack {
                        Text("Brush Size")
                        Slider(value: $brushSize, in: 1...20, step: 1)
                            .padding()
                    }
                }
            }

            Spacer()

            // 保存按钮
            Button("Done") {
                let image = renderImage() // 将当前画布渲染为 UIImage
                onSave(image) // 调用回调函数，将图像传回 ProfileView
                presentationMode.wrappedValue.dismiss() // 返回到 ProfileView
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top)
            
        }
        .padding()
        .navigationTitle("Custom Expression")
    }

    // 擦除路径
    func erasePath(at point: CGPoint) {
        paths.removeAll { pathData in
            pathData.points.contains(where: { $0.distance(to: point) < 10 })
        }
    }

    // 渲染图像
    func renderImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 300, height: 300))
        return renderer.image { context in
            let cgContext = context.cgContext
            cgContext.setFillColor(UIColor(canvasColor).cgColor)
            cgContext.fill(CGRect(x: 0, y: 0, width: 300, height: 300))

            for pathData in paths {
                cgContext.setStrokeColor(UIColor(pathData.color).cgColor)
                cgContext.setLineWidth(pathData.lineWidth)
                let cgPath = CGMutablePath()
                cgPath.addLines(between: pathData.points)
                cgContext.addPath(cgPath)
                cgContext.strokePath()
            }
        }
    }
}

// CGPoint 距离扩展
extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        sqrt(pow(self.x - point.x, 2) + pow(self.y - point.y, 2))
    }
}

#Preview {
    CustomExpressionView { image in
        print("Saved image: \(image)")
    }
}


/*import SwiftUI

struct CustomExpressionView: View {
    var onSave: (UIImage) -> Void // 保存绘图结果的回调
    var initialImage: UIImage? = nil // 可选初始图像
    @Environment(\.presentationMode) var presentationMode // 环境变量，用于返回上一个界面

    @State private var selectedColor: Color = .black // 默认画笔颜色
    @State private var brushSize: CGFloat = 5 // 默认画笔粗细
    @State private var canvasColor: Color = .white // 默认画布颜色
    @State private var paths: [PathData] = [] // 存储绘制的路径
    @State private var currentPath: [CGPoint] = [] // 当前路径
    @State private var isEraserMode: Bool = false // 是否为橡皮擦模式

    struct PathData {
        var points: [CGPoint]
        var color: Color
        var lineWidth: CGFloat
    }

    var body: some View {
        VStack {
            Spacer()
            // 圆角画布
            ZStack {
                Rectangle()
                    .fill(canvasColor) // 动态绑定背景颜色
                    .frame(width: 300, height: 300)
                    .cornerRadius(20)
                    .shadow(radius: 4)

                // Canvas 绘制区域
                Canvas { context, _ in
                    for pathData in paths {
                        var path = Path()
                        path.addLines(pathData.points)
                        context.stroke(path, with: .color(pathData.color), lineWidth: pathData.lineWidth)
                    }

                    // 当前路径
                    if !currentPath.isEmpty {
                        var path = Path()
                        path.addLines(currentPath)
                        context.stroke(path, with: .color(selectedColor), lineWidth: brushSize)
                    }
                }
                .frame(width: 300, height: 300)
                .cornerRadius(20)
                .clipped()
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let point = value.location
                            if isEraserMode {
                                erasePath(at: point)
                            } else {
                                currentPath.append(point)
                            }
                        }
                        .onEnded { _ in
                            if !isEraserMode {
                                // 保存当前路径
                                paths.append(PathData(points: currentPath, color: selectedColor, lineWidth: brushSize))
                                currentPath = [] // 清空当前路径
                            }
                        }
                )
            }

            Spacer()

            // 工具栏
            HStack {
                // 改变画布颜色
                Button(action: {
                    canvasColor = selectedColor // 设置圆角画板背景颜色
                }) {
                    Image(systemName: "face.smiling")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                        .padding()
                }

                // 画笔模式
                Button(action: {
                    isEraserMode = false // 切换为画笔模式
                }) {
                    Image(systemName: "pencil.tip")
                        .font(.system(size: 30))
                        .foregroundColor(isEraserMode ? .gray : .blue)
                        .padding()
                }

                // 橡皮擦模式
                Button(action: {
                    isEraserMode = true // 切换为橡皮擦模式
                }) {
                    Image(systemName: "eraser")
                        .font(.system(size: 30))
                        .foregroundColor(isEraserMode ? .red : .gray)
                        .padding()
                }

                // 撤销
                Button(action: {
                    if !paths.isEmpty {
                        paths.removeLast() // 移除最后一条路径
                    }
                }) {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                        .padding()
                }
            }

            // 底部颜色选择器和粗细调整
            VStack {
                // 颜色选择器
                HStack {
                    ForEach([Color.red, Color.orange, Color.yellow, Color.green, Color.blue, Color.purple, Color.black], id: \.self) { color in
                        ZStack {
                            if color == selectedColor {
                                // 白色圆圈包裹
                                Circle()
                                    .stroke(Color.blue, lineWidth: 4)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        // 对号符号
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 16))
                                    )
                            }

                            // 颜色圆圈
                            Circle()
                                .fill(color)
                                .frame(width: 30, height: 30)
                        }
                        .onTapGesture {
                            selectedColor = color // 改变选中的颜色
                        }
                    }
                }
                .padding()

                // 画笔粗细调整
                if !isEraserMode {
                    HStack {
                        Text("Brush Size")
                        Slider(value: $brushSize, in: 1...20, step: 1)
                            .padding()
                    }
                }
            }

            Spacer()

            // 保存按钮
            Button("Done") {
                let image = renderImage() // 将当前画布渲染为 UIImage
                onSave(image) // 调用回调函数，将图像传回 ProfileView
                presentationMode.wrappedValue.dismiss() // 返回到 ProfileView
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top)
            
        }
        .padding()
        .navigationTitle("Custom Expression")
    }

    // 擦除路径
    func erasePath(at point: CGPoint) {
        paths.removeAll { pathData in
            pathData.points.contains(where: { $0.distance(to: point) < 10 })
        }
    }

    // 渲染图像
    func renderImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 300, height: 300))
        return renderer.image { context in
            let cgContext = context.cgContext
            cgContext.setFillColor(UIColor(canvasColor).cgColor)
            cgContext.fill(CGRect(x: 0, y: 0, width: 300, height: 300))

            for pathData in paths {
                cgContext.setStrokeColor(UIColor(pathData.color).cgColor)
                cgContext.setLineWidth(pathData.lineWidth)
                let cgPath = CGMutablePath()
                cgPath.addLines(between: pathData.points)
                cgContext.addPath(cgPath)
                cgContext.strokePath()
            }
        }
    }
}

// CGPoint 距离扩展
extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        sqrt(pow(self.x - point.x, 2) + pow(self.y - point.y, 2))
    }
}

#Preview {
    CustomExpressionView { image in
        print("Saved image: \(image)")
    }
}*/


/*
import SwiftUI

struct CustomExpressionView: View {
    var onSave: (UIImage) -> Void // 保存绘图结果的回调
    var initialImage: UIImage? = nil // 初始图像（编辑模式）

    @State private var paths: [PathData] = [] // 已保存的路径
    @State private var currentPath: [CGPoint] = [] // 当前绘制的路径
    @State private var canvasImage: UIImage? // 加载初始图像
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedColor: Color = .black
    @State private var brushSize: CGFloat = 5
    @State private var canvasColor: Color = .white
    @State private var isEraserMode: Bool = false // 橡皮擦模式

    struct PathData {
        var points: [CGPoint]
        var color: Color
        var lineWidth: CGFloat
    }

    var body: some View {
        VStack {
            Spacer()
            // 圆角画布
            ZStack {
                Rectangle()
                    .fill(canvasColor) // 动态绑定背景颜色
                    .frame(width: 300, height: 300)
                    .cornerRadius(20)
                    .shadow(radius: 4)

                // Canvas 绘制区域
                Canvas { context, _ in
                    for pathData in paths {
                        var path = Path()
                        path.addLines(pathData.points)
                        context.stroke(path, with: .color(pathData.color), lineWidth: pathData.lineWidth)
                    }

                    // 当前路径
                    if !currentPath.isEmpty {
                        var path = Path()
                        path.addLines(currentPath)
                        context.stroke(path, with: .color(selectedColor), lineWidth: brushSize)
                    }
                }
                .frame(width: 300, height: 300)
                .cornerRadius(20)
                .clipped()
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let point = value.location
                            if isEraserMode {
                                erasePath(at: point)
                            } else {
                                currentPath.append(point)
                            }
                        }
                        .onEnded { _ in
                            if !isEraserMode {
                                // 保存当前路径
                                paths.append(PathData(points: currentPath, color: selectedColor, lineWidth: brushSize))
                                currentPath = [] // 清空当前路径
                            }
                        }
                )
            }

            Spacer()

            // 工具栏
            HStack {
                // 改变画布颜色
                Button(action: {
                    canvasColor = selectedColor // 设置圆角画板背景颜色
                }) {
                    Image(systemName: "face.smiling")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                        .padding()
                }

                // 画笔模式
                Button(action: {
                    isEraserMode = false // 切换为画笔模式
                }) {
                    Image(systemName: "pencil.tip")
                        .font(.system(size: 30))
                        .foregroundColor(isEraserMode ? .gray : .blue)
                        .padding()
                }

                // 橡皮擦模式
                Button(action: {
                    isEraserMode = true // 切换为橡皮擦模式
                }) {
                    Image(systemName: "eraser")
                        .font(.system(size: 30))
                        .foregroundColor(isEraserMode ? .red : .gray)
                        .padding()
                }

                // 撤销
                Button(action: {
                    if !paths.isEmpty {
                        paths.removeLast() // 移除最后一条路径
                    }
                }) {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                        .padding()
                }
            }

            // 底部颜色选择器和粗细调整
            VStack {
                // 颜色选择器
                HStack {
                    ForEach([Color.red, Color.orange, Color.yellow, Color.green, Color.blue, Color.purple, Color.black], id: \.self) { color in
                        ZStack {
                            if color == selectedColor {
                                // 白色圆圈包裹
                                Circle()
                                    .stroke(Color.blue, lineWidth: 4)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        // 对号符号
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 16))
                                    )
                            }

                            // 颜色圆圈
                            Circle()
                                .fill(color)
                                .frame(width: 30, height: 30)
                        }
                        .onTapGesture {
                            selectedColor = color // 改变选中的颜色
                        }
                    }
                }
                .padding()

                // 画笔粗细调整
                if !isEraserMode {
                    HStack {
                        Text("Brush Size")
                        Slider(value: $brushSize, in: 1...20, step: 1)
                            .padding()
                    }
                }
            }

            Spacer()

            // 保存按钮
            Button("Done") {
                let image = renderImage() // 将当前画布渲染为 UIImage
                onSave(image) // 调用回调函数，将图像传回 ProfileView
                presentationMode.wrappedValue.dismiss() // 返回到 ProfileView
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top)
            
        }
        .padding()
        .navigationTitle("Custom Expression")
        
    }


    // 擦除路径
    func erasePath(at point: CGPoint) {
        paths.removeAll { pathData in
            pathData.points.contains { $0.distance(to: point) < 10 }
        }
    }

    
    
    // 渲染画布为 UIImage
    func renderImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 300, height: 300))
        return renderer.image { context in
            context.cgContext.setFillColor(UIColor(canvasColor).cgColor)
            context.cgContext.fill(CGRect(x: 0, y: 0, width: 300, height: 300))

            for pathData in paths {
                context.cgContext.setStrokeColor(UIColor(pathData.color).cgColor)
                context.cgContext.setLineWidth(pathData.lineWidth)
                let cgPath = CGMutablePath()
                cgPath.addLines(between: pathData.points)
                context.cgContext.addPath(cgPath)
                context.cgContext.strokePath()
            }
        }
    }
}

// CGPoint 扩展
extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        sqrt(pow(self.x - point.x, 2) + pow(self.y - point.y, 2))
    }
}


struct PathData {
    var points: [CGPoint]
    var color: Color
    var lineWidth: CGFloat
}


#Preview {
    CustomExpressionView { image in
        print("Saved image: \(image)")
    }
}
*/
