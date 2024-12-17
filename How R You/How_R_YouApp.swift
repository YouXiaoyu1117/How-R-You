//
//  How_R_YouApp.swift
//  How R You
//
//  Created by XIAOYU YOU on 05/12/24.
//

/*import SwiftUI

@main
struct How_R_YouApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView() // 启动时显示 ContentView
        }
    }
}*/

import SwiftUI
import SwiftData

@main
struct How_R_YouApp : App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([CustomExpression.self]) // 关联数据模型
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [configuration])
    }()

    var body: some Scene {
        WindowGroup {
            ContentView() // 启动时显示 ContentView
         
            
        }
    }

    }
