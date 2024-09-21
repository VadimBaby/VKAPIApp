//
//  CommunitiesSectionView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import SwiftUI

struct CommunitiesSectionView: View {
    
    let communities: [Community]
    let communitiesCommonCount: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Сообщества:")
                Text("\(communitiesCommonCount)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                ForEach(communities.indices, id: \.self) { index in
                    let community = communities[index]
                    
                    CircleImageView(url: community.photo, size: 30)
                        .offset(x: calculateX(with: index))
                }
            }
        }
        .foregroundStyle(Color.primary)
        .padding()
    }
}

private extension CommunitiesSectionView {
    func calculateX(with index: Int) -> CGFloat {
        let count = communities.count
        
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
