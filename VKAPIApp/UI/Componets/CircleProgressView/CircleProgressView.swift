//
//  CircleProgressView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 14.09.2024.
//

import SwiftUI

struct CircleProgressView: View {
    
    @State private var isActive: Int = 0
    
    @Namespace private var circleProgressViewNameSpace
    
    private let timer = Timer.publish(every: 0.8, on: .main, in: .common)
        .autoconnect()
    
    private let size: CGFloat = 20
    
    var body: some View {
        HStack {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.gray)
                    .frame(width: size, height: size)
                    .overlay {
                        if isActive == index {
                            Circle()
                                .fill(Color.blue)
                                .matchedGeometryEffect(
                                    id: "circle",
                                    in: circleProgressViewNameSpace
                                )
                        }
                    }
            }
        }
        .onReceive(timer) { _ in
            animate()
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
    }
}

private extension CircleProgressView {
    func animate() {
        withAnimation(.linear(duration: 0.2)) {
            guard isActive < 2 else { isActive = 0; return }
            
            isActive += 1
        }
    }
}

#Preview {
    CircleProgressView()
}
