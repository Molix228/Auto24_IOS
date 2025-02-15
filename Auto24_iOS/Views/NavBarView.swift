//
//  NavBarView.swift
//  Auto24_iOS
//
//  Created by Александр Меслюк on 30.10.2024.
//

import SwiftUI

struct NavBarView: View {
    @State private var tabSelection = 1
    @State private var keyboardVisible = false
    @StateObject var authViewModel = AuthViewModel()
    @State private var languageShow: Bool = false
    var body: some View {
        TabView(selection: $tabSelection){
            HomeView()
                .preferredColorScheme(.dark)
                .tag(1)
            SearchView()
                .tag(2)
            FavView().tag(3)
            RootView()
                .environmentObject(authViewModel)
                .tag(4)
            NotificationView()
                .tag(5)
            
        }
        .overlay(alignment: .bottom) {
            if !keyboardVisible {
                CustomTabView(tabSelection: $tabSelection)
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
                DispatchQueue.main.async {
                    keyboardVisible = true
                }
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                DispatchQueue.main.async {
                    keyboardVisible = false
                }
            }
        }
    }
}

#Preview {
    NavBarView()
}
