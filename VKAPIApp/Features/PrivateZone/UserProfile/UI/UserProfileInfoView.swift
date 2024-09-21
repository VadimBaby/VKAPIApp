//
//  ProfileSectionView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 18.09.2024.
//

import SwiftUI

struct UserProfileInfoView: View {
    
    let profile: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            CircleImageView(
                url: profile.displayPhoto,
                online: profile.online,
                onlineMobile: profile.onlineMobile,
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
    }
}

#Preview {
    ZStack {
        Color.systemGray6.ignoresSafeArea()
        
        UserProfileInfoView(
            profile: User.mock
        )
        .padding()
    }
}
