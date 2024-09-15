//
//  FriendsListItemView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 11.09.2024.
//

import SwiftUI

struct FriendsListItemView: View {
    
    let friend: Friend
    
    var body: some View {
        HStack {
            ProfileImageView(
                url: friend.photo,
                online: friend.online,
                onlineMobile: friend.onlineMobile
            )
            
            VStack(alignment: .leading) {
                Text(friend.displayName)
                    .font(.title3)
                
                HStack(spacing: 0) {
                    if let city = friend.city {
                        descriptionView(city)
                    }
                    
                    if let bithdayString = friend.bithdayString() {
                        descriptionView(
                            friend.city.isNil ? "" : ", "
                            + bithdayString
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.opposite)
        .clipShape(.rect(cornerRadius: 15))
    }
}

private extension FriendsListItemView {
    @ViewBuilder
    func descriptionView(_ description: String) -> some View {
        Text(description)
            .font(.caption)
            .foregroundStyle(Color.gray)
    }
}

#Preview {
    FriendsListItemView(friend: .mock)
        .padding()
}
