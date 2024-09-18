//
//  ProfileSectionView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 18.09.2024.
//

import SwiftUI

struct ProfileSectionView: View {
    
    private let profile: User
    private let isProfileLoading: Bool
    
    init(_ profile: User, isProfileLoading: Bool) {
        self.profile = profile
        self.isProfileLoading = isProfileLoading
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ProfileImageView(
                url: profile.photo,
                online: true,
                onlineMobile: true,
                size: 120
            )
            .frame(maxWidth: .infinity, alignment: .center)
            
            Text(profile.displayName)
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(alignment: .leading, spacing: 10) {
                if let domain = profile.domain {
                    Label(domain, systemImage: "at")
                }
                
                if let gender = profile.gender {
                    Label("Пол: \(gender.title)", systemImage: "person.fill")
                }
                
                if let bithday = profile.displayBirthday {
                    Label("День рождения: \(bithday)", systemImage: "gift.fill")
                }
                
                if let city = profile.city {
                    Label("Город: \(city)", systemImage: "house.fill")
                }
                
                if let followers = profile.followersCount {
                    Label("Подписчиков: \(followers)", systemImage: "dot.radiowaves.up.forward")
                }
            }
        }
        .padding()
        .roundedContainer(isContentLoading: isProfileLoading)
    }
}

#Preview {
    ZStack {
        Color.systemGray6.ignoresSafeArea()
        
        ProfileSectionView(User.mock, isProfileLoading: false)
            .padding()
    }
}
