//
//  CommunityProfileInfoView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import SwiftUI

struct CommunityProfileInfoView: View {
    
    let community: Community
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            CircleImageView(
                url: community.displayPhoto,
                size: 120
            )
            .frame(maxWidth: .infinity, alignment: .center)
            
            Text(community.name)
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .center)
            
            if let description = community.description {
                Text(description)
                    .font(.subheadline)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Label(community.screenName, systemImage: "at")
                
                if let activity = community.activity {
                    Label(activity, systemImage: "newspaper.fill")
                }
                
                if let memberCount = community.membersCount {
                    Label("Подписчиков: \(memberCount)", systemImage: "dot.radiowaves.up.forward")
                }
            }
        }
        .padding()
    }
}

#Preview {
    ZStack {
        Color.systemGray6.ignoresSafeArea()
        
        CommunityProfileInfoView(
            community: .mock
        )
        .padding()
    }
}
