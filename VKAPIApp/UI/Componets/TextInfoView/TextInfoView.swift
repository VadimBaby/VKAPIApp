//
//  TextInfoView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import SwiftUI

struct TextInfoView: View {
    
    private let title: String
    private let value: String?
    
    init(title: String, value: String? = nil) {
        self.title = title
        self.value = value
    }
    
    init(title: String, value: Int) {
        self.title = title
        self.value = String(value)
    }
    
    var body: some View {
        Group {
            if let value {
                Text("\(title): \(value)")
            } else {
                Text(title)
            }
        }
        .font(.caption)
        .foregroundStyle(Color.gray)
    }
}

#Preview {
    TextInfoView(title: "Title")
}
