//
//  PhotosSectionView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 18.09.2024.
//

import SwiftUI

struct PhotosSectionView: View {
    
    let photosSizes: [PhotoSize]
    let isPhotoLoading: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(photosSizes) { model in
                    AsyncImage(url: model.url)
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: Constants.imageSize / 1.25,
                            height: Constants.imageSize
                        )
                        .clipShape(.rect(cornerRadius: 8))
                }
            }
            .padding(.horizontal)
        }
        .roundedContainer(
            isContentLoading: isPhotoLoading,
            isContentEmpty: photosSizes.isEmpty,
            emptyStateMessage: Constants.emptyStateMessage
        )
    }
}

fileprivate enum Constants {
    static let imageSize: Double = 144
    static let emptyStateMessage = "У вас нет фотографий"
}

#Preview {
    ZStack {
        Color.systemGray6.ignoresSafeArea()
        
        PhotosSectionView(
            photosSizes: (1...5).map{ _ in PhotoSize.mock },
            isPhotoLoading: false
        )
        .padding()
    }
}
