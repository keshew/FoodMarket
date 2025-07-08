import SwiftUI

class FoodCartViewModel: ObservableObject {
    @Published var foods: [Food] = []
    
    @Published var selectedCategory: Category = .All
    
    init() {
        loadFoods()
    }
    
     func loadFoods() {
        if let data = UserDefaults.standard.data(forKey: "SavedFoods") {
            do {
                let savedFoods = try JSONDecoder().decode([Food].self, from: data)
                self.foods = savedFoods
            } catch {
                print("Ошибка декодирования данных из UserDefaults: \(error)")
                self.foods = []
            }
        } else {
            self.foods = []
        }
    }
    
     func saveFoods() {
        if let data = try? JSONEncoder().encode(foods) {
            UserDefaults.standard.set(data, forKey: "SavedFoods")
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
