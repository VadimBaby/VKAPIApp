//
//  NetworkClient.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 11.09.2024.
//

import ComposableArchitecture
import AsyncNetwork

extension AsyncNetwork: DependencyKey {
    public static let liveValue = AsyncNetwork(
        options: .default,
        eventManager: .init(receivers: [NetworkableLogger(systemLogsEnabled: false)])
    )
}

extension DependencyValues {
    var networkClient: AsyncNetwork {
        get { self[AsyncNetwork.self] }
        set { self[AsyncNetwork.self] = newValue }
    }
}
