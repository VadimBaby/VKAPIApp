//
//  AvatarGroupView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import SwiftUI

struct AvatarGroupView<T: Avatarable>: View {
    
    let models: [T]
    let title: String
    let commonCount: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                Text(commonCount)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                ForEach(models.indices, id: \.self) { index in
                    let model = models[index]
                    
                    CircleImageView(url: model.displayAvatar, size: 30)
                        .offset(x: calculateX(with: index))
                }
            }
        }
        .foregroundStyle(Color.primary)
        .padding()
    }
}

private extension AvatarGroupView {
    func calculateX(with index: Int) -> CGFloat {
        let count = models.count
        
        guard index < count - 1 else { return 0 }
        
        return CGFloat(15 * (count - 1 - index))
    }
}

#Preview {
    ZStack {
        Color.systemGray6.ignoresSafeArea()
        
        AvatarGroupView(
            models: (1...5).map{ _ in User.mock },
            title: "Друзья",
            commonCount: 100
        )
        .padding()
    }
}
