import SwiftUI

class FoodHomeViewModel: ObservableObject {
    let contact = FoodHomeModel()
    @Published var selectedCategory: Category = .All
    @Published var selectedFood: Food? = nil
    @Published var foods: [Food] = []
    private let userDefaultsKey = "SavedFoods"
    
    @Published var searchText: String = ""

    var searchedFoods: [Food] {
        if searchText.isEmpty {
            return filteredFoods
        } else {
            return filteredFoods.filter { food in
                food.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var filteredFoods: [Food] {
        switch selectedCategory {
        case .All:
            return foods
        case .Favourites:
            return foods.filter { $0.isFavourite }
        case .CandiesAndSweets:
            return foods.filter { $0.category == .CandiesAndSweets }
        case .CakesAndPastries:
            return foods.filter { $0.category == .CakesAndPastries }
        case .FruitDesserts:
            return foods.filter { $0.category == .FruitDesserts }
        }
    }
    
    func updateFood(_ updatedFood: Food) {
        if let index = foods.firstIndex(where: { $0.id == updatedFood.id }) {
            foods[index] = updatedFood
            saveFoods()
        }
    }
    
    func toggleFavourite(for food: Food) {
        if let index = foods.firstIndex(where: { $0.id == food.id }) {
            foods[index].isFavourite.toggle()
            saveFoods()
        }
    }
    
    init() {
           loadFoods()
       }
    
    private func loadFoods() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let savedFoods = try? JSONDecoder().decode([Food].self, from: data) {
            self.foods = savedFoods
        } else {
            self.foods = contact.arrayModel
        }
    }
    
    private func saveFoods() {
        if let data = try? JSONEncoder().encode(foods) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    func toggleAdded(for food: Food) {
        if let index = foods.firstIndex(where: { $0.id == food.id }) {
            foods[index].isAdded.toggle()
            saveFoods()
        }
    }
    
    func addToCart(food: Food) {
        if let index = foods.firstIndex(where: { $0.id == food.id }) {
            foods[index].isAdded = true
            if foods[index].quantity == 0 {
                foods[index].quantity = 100
            }
            saveFoods()
        }
    }
    
    func increaseQuantity(for food: Food) {
        if let index = foods.firstIndex(where: { $0.id == food.id }) {
            foods[index].quantity += 100
            saveFoods()
        }
    }
    
    func decreaseQuantity(for food: Food) {
        if let index = foods.firstIndex(where: { $0.id == food.id }) {
            foods[index].quantity = max(0, foods[index].quantity - 100) 
            if foods[index].quantity == 0 {
                foods[index].isAdded = false
            }
            saveFoods()
        }
    }
}
