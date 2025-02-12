import SwiftUI

struct HomeView: View {
    @State private var items: [ItemResponse] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            ScrollView {
                if isLoading {
                    ProgressView("Загрузка...")
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    HStack {
                        LazyVStack{
                            ForEach(items) { item in
                                NavigationLink(destination: DetailView(item: item)) {
                                    ItemRow(item: item)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Home")
            .task {
                await fetchItems()
            }
        }
    }

    func fetchItems() async {
        do {
            items = try await APIService.shared.fetchItems()
            isLoading = false
        } catch {
            errorMessage = "Ошибка: \(error.localizedDescription)"
            isLoading = false
        }
    }
}
