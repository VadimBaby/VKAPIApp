//
//  ProfileImage.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 14.09.2024.
//

import SwiftUI

struct ProfileImageView: View {
    
    private let url: URL?
    private let online: Bool?
    private let onlineMobile: Bool?
    
    init(url: URL?, online: Bool? = nil, onlineMobile: Bool? = nil) {
        self.url = url
        self.online = online
        self.onlineMobile = onlineMobile
    }
    
    private let size: CGFloat = 60
    
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
                .clipShape(.circle)
                .overlay(alignment: .bottomTrailing) {
                    if let online, online {
                        onlineMark
                    }
                }
        } placeholder: {
            ProgressView()
                .frame(width: size, height: size)
        }
    }
}

private extension ProfileImageView {
    @ViewBuilder
    var onlineMark: some View {
        let onlineSize: CGFloat = 12
        
        Group {
            if let onlineMobile, onlineMobile {
                Image(systemName: "iphone.gen3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: onlineSize, height: onlineSize)
                    .foregroundStyle(Color.green)
            } else {
                Circle()
                    .fill(Color.green)
                    .frame(
                        width: onlineSize,
                        height: onlineSize
                    )
            }
        }
        .padding(2)
        .background(.white)
        .clipShape(.rect(cornerRadius: 5))
        .padding(.bottom, 5)
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        
        ProfileImageView(
            url: .init(string: "https://clck.ru/3DEnoW"),
            online: true,
            onlineMobile: true
        )
    }
}
