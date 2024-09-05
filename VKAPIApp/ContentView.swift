//
//  ContentView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 04.09.2024.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage(UserStorageKey.token.rawValue) var token: String = ""
    
    var body: some View {
        if token.isEmpty, let url = AuthURLBuilder.current.url {
            AuthWebView(authURL: url)
        } else {
            Text("Вы зарегистрированы")
        }
    }
}

#Preview {
    ContentView()
}
