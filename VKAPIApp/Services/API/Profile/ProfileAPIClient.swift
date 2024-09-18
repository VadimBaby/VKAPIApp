//
//  ProfileAPIClient.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 17.09.2024.
//

import AsyncNetwork
import ComposableArchitecture

struct ProfileAPIClient {
    @Dependency(\.networkClient) private static var networkClient
    
    var getProfile: () async throws -> User
    var getPhotos: (_ album: AlbumIndentifier?) async throws -> [Photo]
}

extension ProfileAPIClient: DependencyKey {
    static var liveValue = ProfileAPIClient(
        getProfile: {
            let data = try await sendRequest(with: .getMyProfile, [ServerUserModel].self)
            
            guard let profile = data.first else { throw NetworkError.decode(nil) }
            
            print("aaaaa: \(profile)")
            
            return .init(from: profile)
        },
        getPhotos: { indentifier in
            let data = try await sendRequest(with: .getPhotos(indentifier), ServerResponseModel<ServerPhotoModel>.self)
            
            let localData = data.toLocal()
            
            return localData.items
        }
    )
}

private extension ProfileAPIClient {
    static func sendRequest<T: Decodable>(
        with endpoint: ProfileEndpoint,
        _ responseType: T.Type
    ) async throws -> T {
        try await networkClient.sendRequest(with: endpoint)
            .decode(
                to: responseType,
                at: "response"
            )
    }
}

extension DependencyValues {
    var profileClient: ProfileAPIClient {
        get { self[ProfileAPIClient.self] }
        set { self[ProfileAPIClient.self] = newValue }
    }
}
