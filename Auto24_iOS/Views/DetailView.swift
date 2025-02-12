//
//  DetailView.swift
//  Auto24_iOS
//
//  Created by Александр Меслюк on 10.02.2025.
//

import SwiftUI

struct DetailView: View {
    let item: ItemResponse
    @State private var selectedImageIndex = 0

    var body: some View {
        VStack {
            TabView(selection: $selectedImageIndex) {
                ForEach(Array(item.images.enumerated()), id: \.offset) { index, image in
                    AsyncImage(url: URL(string: image.path)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipped()
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .tag(index)
                }
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("\(item.make) \(item.model)")
                    .font(.title)
                    .bold()
                Text("Year: \(item.year)")
                    .font(.subheadline)
                if let mileage = item.mileage {
                    Text("Mileage: \(mileage) км")
                        .font(.subheadline)
                }
            }
            .padding()

            Spacer()
        }
        .navigationTitle("Details:")
    }
}
