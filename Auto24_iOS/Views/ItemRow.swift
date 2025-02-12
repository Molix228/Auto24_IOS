import SwiftUI

struct ItemRow: View {
    let item: ItemResponse
    @State private var selectedImageIndex = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !item.images.isEmpty {
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
                .frame(height: 200)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
            }

            HStack(spacing: 10) {
                Text("\(item.make) \(item.model)")
                    .font(.headline)
                Text("Год: \(String(item.year))")
                    .font(.subheadline)
                if let mileage = item.mileage {
                    Text("Пробег: \(mileage) км")
                        .font(.subheadline)
                }
            }
            .padding(.horizontal)
        }
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground)).shadow(radius: 3))
        .padding(.horizontal)
    }
}
