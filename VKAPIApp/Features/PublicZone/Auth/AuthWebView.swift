//
//  AuthWebView.swift
//  VKAPIApp
//
//  Created by Вадим Мартыненко on 04.09.2024.
//

import SwiftUI
import WebKit

struct AuthWebView: UIViewRepresentable {
    let authURL: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.navigationDelegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: authURL)
        
        DispatchQueue.main.async {
            uiView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}

extension AuthWebView {
    final class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            guard let url = webView.url, url.absoluteString.contains(Consts.token) else { return }
            
            guard let creds = getCredentials(from: url) else { return }
            
            UserStorage.shared.token = creds.token
            UserStorage.shared.userID = creds.token
        }
    }
}

private extension AuthWebView.Coordinator {
    func getCredentials(from url: URL) -> AuthCredentials? {
        guard let fragmentString = url.fragment() else { return nil }
        
        let strings = fragmentString.components(separatedBy: "&")
        
        guard let tokenRange = strings.first?.range(of: Consts.token.appending("=")) else { return nil }
        
        let creds = AuthCredentials()
        let token = strings.first?[tokenRange.upperBound...]
        
        if let token {
            creds.token = String(token)
        }
        
        guard let userIdRange = strings.last?.range(of: Consts.userID.appending("=")) else { return creds }
        
        let userID = strings.last?[userIdRange.upperBound...]
        
        if let userID {
            creds.userID = String(userID)
        }
        
        return creds
    }
    
    enum Consts {
        static let token = "access_token"
        static let userID = "user_id"
    }
}
