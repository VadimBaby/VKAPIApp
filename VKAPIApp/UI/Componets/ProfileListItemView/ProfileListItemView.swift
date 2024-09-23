//
//  ProfileListItemView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 23.09.2024.
//

import SwiftUI

struct ProfileListItemView<Content: View>: View {
    private let avatar: URL?
    private let online: Bool
    private let onlineMobile: Bool?
    private let title: String
    private let infoContent: () -> Content
    
    init(
        avatar: URL?,
        online: Bool = false,
        onlineMobile: Bool? = nil,
        title: String,
        @ViewBuilder infoContent: @escaping () -> Content = { EmptyView() }
    ) {
        self.avatar = avatar
        self.online = online
        self.onlineMobile = onlineMobile
        self.title = title
        self.infoContent = infoContent
    }
    
    var body: some View {
        HStack {
            CircleImageView(
                url: avatar,
                online: online,
                onlineMobile: onlineMobile
            )
            
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundStyle(Color.primary)
                    .font(.title3)
                    .multilineTextAlignment(.leading)
                
                VStack(alignment: .leading, spacing: 0, content: infoContent)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.opposite)
        .clipShape(.rect(cornerRadius: 15))
    }
}

#Preview {
    ProfileListItemView(
        avatar: User.mock.displayAvatar,
        online: User.mock.online,
        onlineMobile: User.mock.onlineMobile,
        title: User.mock.displayName
    ) {
        if let city = User.mock.city {
            TextInfoView(title: "Город", value: city)
        }
    }
}
