//
//  EmptyContentView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 25.09.2024.
//

import SwiftUI

struct EmptyContentView: View {
    
    private let message: String
    
    init(message: String = "Пусто") {
        self.message = message
    }
    
    var body: some View {
        Text(message)
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.opposite)
            .clipShape(.rect(cornerRadius: 15))
    }
}

#Preview {
    EmptyContentView()
}
