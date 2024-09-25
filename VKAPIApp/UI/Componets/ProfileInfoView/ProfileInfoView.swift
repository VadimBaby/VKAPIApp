//
//  ProfileInfoView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 23.09.2024.
//

import SwiftUI

struct ProfileInfoView<Content: View>: View {
    private let avatar: URL?
    private let title: String
    private let description: String?
    private let infoContent: () -> Content
    
    init(
        avatar: URL?,
        title: String,
        description: String? = nil,
        @ViewBuilder infoContent: @escaping () -> Content = { EmptyView() }
    ) {
        self.avatar = avatar
        self.title = title
        self.description = description
        self.infoContent = infoContent
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 15) {
                CircleImageView(
                    url: avatar,
                    size: 120
                )
                .frame(maxWidth: .infinity, alignment: .center)
                
                Text(title)
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                if let description {
                    Text(description)
                        .font(.subheadline)
                }
                
                VStack(alignment: .leading, spacing: 10, content: infoContent)
            }
            .padding()
        }
    }
}

#Preview {
    ProfileInfoView(
        avatar: User.mock.displayAvatar,
        title: User.mock.displayName,
        description: "desctiption"
    ) {
        Text("Дата рождения: \(User.mock.displayBirthday ?? "")")
    }
}
