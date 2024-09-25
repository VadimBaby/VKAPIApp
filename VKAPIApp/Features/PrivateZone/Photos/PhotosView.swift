//
//  PhotosView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 19.09.2024.
//

import ComposableArchitecture
import SwiftUI

struct PhotosView: View {
    
    @Bindable var store: StoreOf<PhotosFeature>
    
    var body: some View {
        LoadableView(store: store.scope(state: \.loadableView, action: \.loadableView)) {
            ScrollView {
                LazyVGrid(
                    columns: Constants.gridItems,
                    alignment: .center,
                    spacing: 10
                ) {
                    ForEach(store.photos) { photo in
                        AsyncImage(url: photo.url) { phase in
                            phase.image?
                                .resizable()
                                .aspectRatio(contentMode: photo.isHorizontal ? .fill : .fit)
                        }
                        .frame(width: Constants.gridSize, height: Constants.gridSize)
                        .clipShape(.rect(cornerRadius: 8))
                    }
                }
            }
            .refreshable {
                try? await Task.sleep(for: .seconds(1))
                refreshAction()
            }
        }
        .navigationTitle(Constants.navigationTitle)
        .onAppear(perform: appearAction)
    }
}

// MARK: - Constants

private extension PhotosView {
    func appearAction() {
        store.send(.onAppear)
    }
    
    func refreshAction() {
        store.send(.onRefresh)
    }
}

fileprivate enum Constants {
    static let navigationTitle = "Фотографии"
    static let gridSize = (UIScreen.main.bounds.width - 32 - 20) / 3
    static let gridItems: [GridItem] = Array(
        repeating: .init(.fixed(gridSize)),
        count: 3
    )
}

#Preview {
    PhotosView(store: .init(
        initialState: PhotosFeature.State(userType: .me),
        reducer: { PhotosFeature() }
    ))
}
