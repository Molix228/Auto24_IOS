//
//  RootView.swift
//  Auto24_iOS
//
//  Created by Александр Меслюк on 15.02.2025.
//


import SwiftUI

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            if authViewModel.isLoggedIn {
                ExpandedAccountView()
            } else if authViewModel.isRegistered {
                LoginView()
            } else {
                RegistrationView()
            }
        }
        .onAppear {
            authViewModel.checkAuthStatus()
        }
    }
}

#Preview {
    RootView().environmentObject(AuthViewModel())
}