//
//  ProfileImage.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 14.09.2024.
//

import SwiftUI

struct CircleImageView: View {
    
    private let url: URL?
    private let online: Bool?
    private let onlineMobile: Bool?
    private let size: CGFloat
    
    init(url: URL?, online: Bool? = nil, onlineMobile: Bool? = nil, size: CGFloat = 60) {
        self.url = url
        self.online = online
        self.onlineMobile = onlineMobile
        self.size = size
    }
    
    var body: some View {
        if let url {
            AsyncImage(url: url, content: profileImage) {
                ProgressView()
                    .frame(width: size, height: size)
            }
        } else {
            profileImage(.init(.emptyUser))
        }
    }
}

private extension CircleImageView {
    @ViewBuilder func profileImage(_ image: Image) -> some View {
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
    }
    
    @ViewBuilder
    var onlineMark: some View {
        let onlineSize: CGFloat = size / 5
        
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
        
        CircleImageView(
            url: .init(string: "https://clck.ru/3DEnoW"),
            online: true,
            onlineMobile: true
        )
    }
}
