//
//  NotificationView.swift
//  Auto24_iOS
//
//  Created by Александр Меслюк on 05.11.2024.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(1...20, id: \.self) { _ in
                        NavigationLink(destination: DetailMessageView()) {
                            MessageView()
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("Notifications")
        }
    }
    
    @ViewBuilder
    func MessageView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8){
                Image(systemName: "message.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Text("Text")
                
                Spacer()

                NavigationLink(destination: DetailMessageView()) {
                    Image(systemName: "arrow.right")
                        .foregroundStyle(.blue)
                }
            }
        }
        .padding()
        .background(.tertiary)
        .foregroundStyle(.secondary)
    }
}

#Preview {
    NotificationView()
}
