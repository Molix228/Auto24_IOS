import SwiftUI

struct SearchView: View {
    @State private var make: String = ""
    @State private var model: String = ""
    @State private var year: String = ""
    @State private var minMileage: String = ""
    @State private var maxMileage: String = ""

    @State private var items: [ItemResponse] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    @State private var showFilters: Bool = true // Фильтры занимают весь экран
    @State private var showSorting: Bool = false // Флаг отображения сортировки (выпадающий список)
    @State private var sortOption: SortOption = .priceAscending

    enum SortOption: String, CaseIterable, Identifiable {
        case priceAscending = "Цена: по возрастанию"
        case priceDescending = "Цена: по убыванию"
        case mileageAscending = "Пробег: по возрастанию"
        case mileageDescending = "Пробег: по убыванию"
        case yearDescending = "Год: новые сначала"
        case yearAscending = "Год: старые сначала"

        var id: String { self.rawValue }
    }

    var sortedItems: [ItemResponse] {
        switch sortOption {
        case .priceAscending:
            return items.sorted { $0.price < $1.price }
        case .priceDescending:
            return items.sorted { $0.price > $1.price }
        case .mileageAscending:
            return items.sorted { ($0.mileage ?? 0) < ($1.mileage ?? 0) }
        case .mileageDescending:
            return items.sorted { ($0.mileage ?? 0) > ($1.mileage ?? 0) }
        case .yearDescending:
            return items.sorted { $0.year > $1.year }
        case .yearAscending:
            return items.sorted { $0.year < $1.year }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // Верхняя панель с кнопками фильтрации и сортировки
                    HStack {
                        Spacer()

                        // Кнопка сортировки
                        Button(action: {
                            withAnimation {
                                showSorting.toggle()
                            }
                        }) {
                            Image(systemName: "list.bullet.indent")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.blue)
                        }
                        .popover(isPresented: $showSorting) {
                            VStack {
                                Text("Сортировка")
                                    .font(.headline)
                                    .padding()
                                ForEach(SortOption.allCases) { option in
                                    Button(action: {
                                        sortOption = option
                                        showSorting = false
                                    }) {
                                        Text(option.rawValue)
                                            .padding()
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .frame(width: 250)
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding()
                        }
                    }
                    .padding(.horizontal)

                    if isLoading {
                        ProgressView("Загрузка...")
                    } else if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .padding()
                    } else {
                        List(sortedItems) { item in
                            ItemRow(item: item)
                        }
                    }
                }

                // Полноэкранные фильтры, которые исчезают только после поиска
                if showFilters {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                        .onTapGesture {
                            hideKeyboard() // Скрываем клавиатуру при тапе вне полей ввода
                        }

                    VStack {
                        Text("Фильтры")
                            .font(.title2)
                            .bold()
                            .padding(.top, 20)

                        Form {
                            Section(header: Text("Марка и модель")) {
                                TextField("Марка", text: $make)
                                    .textInputAutocapitalization(.words)
                                TextField("Модель", text: $model)
                                    .textInputAutocapitalization(.words)
                            }

                            Section(header: Text("Год выпуска")) {
                                TextField("Год", text: $year)
                                    .keyboardType(.numberPad)
                            }

                            Section(header: Text("Пробег (км)")) {
                                TextField("Мин. пробег", text: $minMileage)
                                    .keyboardType(.numberPad)
                                TextField("Макс. пробег", text: $maxMileage)
                                    .keyboardType(.numberPad)
                            }

                            Button {
                                Task {
                                    await performSearch()
                                }
                            } label: {
                                Text("Применить фильтры")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundStyle(.white)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .transition(.opacity)
                }
            }
            .navigationTitle("Поиск авто")
        }
        .onTapGesture {
            hideKeyboard() // Скрываем клавиатуру при нажатии на любое пустое место
        }
    }

    func performSearch() async {
        isLoading = true
        errorMessage = nil
        do {
            let results = try await APIService.shared.searchItems(
                make: make.isEmpty ? nil : make,
                model: model.isEmpty ? nil : model,
                year: Int(year),
                minMileage: Int(minMileage) ?? 0,
                maxMileage: Int(maxMileage) ?? 0
            )
            items = results
            withAnimation {
                showFilters = false // Фильтры скрываются только после поиска
            }
        } catch {
            errorMessage = "Ошибка: \(error.localizedDescription)"
        }
        isLoading = false
    }
}

// Расширение для скрытия клавиатуры
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    SearchView()
}
