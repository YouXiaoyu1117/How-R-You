//
//  CustomExpression.swift
//  How R You
//
//  Created by XIAOYU YOU on 17/12/24.
//

import SwiftData
import SwiftUI

@Model
class CustomExpression {
    var imageData: Data
    var createdAt: Date

    init(image: UIImage) {
        self.imageData = image.pngData() ?? Data()
        self.createdAt = Date()
    }

    // 提供 UIImage 访问接口
    var image: UIImage? {
        UIImage(data: imageData)
    }
}
