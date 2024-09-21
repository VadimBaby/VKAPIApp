//
//  FriendsSectionView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 18.09.2024.
//

import SwiftUI

struct FriendsSectionView: View {
    
    let friends: [User]
    let friendsCommonCount: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Друзья:")
                Text("\(friendsCommonCount)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                ForEach(friends.indices, id: \.self) { index in
                    let friend = friends[index]
                    
                    CircleImageView(url: friend.photo, size: 30)
                        .offset(x: calculateX(with: index))
                }
            }
        }
        .foregroundStyle(Color.primary)
        .padding()
    }
}

private extension FriendsSectionView {
    func calculateX(with index: Int) -> CGFloat {
        let count = friends.count
        
        guard index < count - 1 else { return 0 }
        
        return CGFloat(15 * (count - 1 - index))
    }
}

#Preview {
    ZStack {
        Color.systemGray6.ignoresSafeArea()
        
        FriendsSectionView(
            friends: (1...5).map{ _ in User.mock },
            friendsCommonCount: 100
        )
        .padding()
    }
}
