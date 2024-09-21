//
//  CommunitiesListItemView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 21.09.2024.
//

import SwiftUI

struct CommunitiesListItemView: View {
    
    let community: Community
    
    var body: some View {
        HStack {
            CircleImageView(url: community.displayPhoto)
            
            VStack(alignment: .leading) {
                Text(community.name)
                    .foregroundStyle(Color.primary)
                    .font(.title3)
                    .multilineTextAlignment(.leading)
                
                VStack(alignment: .leading, spacing: 0) {
                    if let activity = community.activity {
                        descriptionView(activity)
                    }
                    
                    if let membersCount = community.membersCount {
                        descriptionView("Подписчиков: \(membersCount)")
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

private extension CommunitiesListItemView {
    @ViewBuilder
    func descriptionView(_ description: String) -> some View {
        Text(description)
            .font(.caption)
            .foregroundStyle(Color.gray)
    }
}

#Preview {
    CommunitiesListItemView(community: .mock)
}
