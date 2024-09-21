//
//  FriendsListItemView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 11.09.2024.
//

import SwiftUI

struct FriendsListItemView: View {
    
    let friend: User
    
    var body: some View {
        HStack {
            CircleImageView(
                url: friend.displayPhoto,
                online: friend.online,
                onlineMobile: friend.onlineMobile
            )
            
            VStack(alignment: .leading) {
                Text(friend.displayName)
                    .foregroundStyle(Color.primary)
                    .font(.title3)
                    .multilineTextAlignment(.leading)
                
                VStack(alignment: .leading, spacing: 0) {
                    if let city = friend.city {
                        TextInfoView(title: "Город", value: city)
                    }
                    
                    if let displayBirthday = friend.displayBirthday {
                        TextInfoView(title: "Дата рождения", value: displayBirthday)
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


#Preview {
    FriendsListItemView(friend: .mock)
        .padding()
}
