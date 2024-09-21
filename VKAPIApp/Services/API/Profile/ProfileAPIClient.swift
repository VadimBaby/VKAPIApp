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
    
    var getProfile: (_ userType: UserType) async throws -> User
    var getPhotos: (_ userType: UserType, _ album: AlbumIndentifier?) async throws -> [Photo]
}

extension ProfileAPIClient: DependencyKey {
    static var liveValue = ProfileAPIClient(
        getProfile: { userType in
            let data = try await sendRequest(with: .getProfile(of: userType), [ServerUserModel].self)
            
            guard let profile = data.first else { throw NetworkError.decode(nil) }
            
            return .init(from: profile)
        },
        getPhotos: { userType, indentifier in
            let data = try await sendRequest(with: .getPhotos(of: userType, album: indentifier), ServerResponseModel<ServerPhotoModel>.self)
            
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
