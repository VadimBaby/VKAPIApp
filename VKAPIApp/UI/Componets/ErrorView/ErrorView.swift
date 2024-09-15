//
//  ErrorView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 14.09.2024.
//

import SwiftUI

struct ErrorView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    private let description: String
    private let onRepeat: (() -> Void)?
    
    init(description: String, onRepeat: (() -> Void)? = nil) {
        self.description = description
        self.onRepeat = onRepeat
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            VStack(spacing: 15) {
                Text("Ошибка:")
                    .font(.title)
                
                Text(description)
                    .font(.headline)
                
                if let onRepeat {
                    Button(action: onRepeat) {
                        Text("Повторить")
                            .foregroundStyle(Color.black)
                            .padding(10)
                            .background(Color.white)
                            .clipShape(.rect(cornerRadius: 5))
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .center)
        }
        .foregroundStyle(Color.white)
        .fontWeight(.bold)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundGradient)
    }
}

private extension ErrorView {
    @ViewBuilder
    var headerView: some View {
        let size: CGFloat = 25
        
        Button(action: { dismiss() }) {
            Image(systemName: "xmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    @ViewBuilder
    var backgroundGradient: some View {
        LinearGradient(
            colors: [.red.opacity(0.8), .red],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

#Preview {
    ErrorView(description: URLError(.badServerResponse).localizedDescription) {
        
    }
}
