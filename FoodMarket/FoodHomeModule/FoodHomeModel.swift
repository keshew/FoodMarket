import SwiftUI

enum Category: String, CaseIterable, Identifiable, Codable {
    case All = "All"
    case Favourites = "Favourites"
    case CandiesAndSweets = "Lollipops and Candies"
    case CakesAndPastries = "Cakes and Pastries"
    case FruitDesserts = "Fruit Desserts"
    
    var id: String { self.rawValue }
}

struct Food: Codable, Identifiable {
    var id = UUID() 
    var imageName: String
    var name: String
    var category: Category
    var price: String
    var shortDescription: String
    var ingredients: [String]
    var ration: String
    var isFavourite: Bool = false
    var isAdded: Bool = false
    var quantity: Int = 0
}

struct FoodHomeModel {
    let arrayOfSearch = ["1", "2", "3", "4", "5"]
    let arrayWidth: [CGFloat] = [48, 107, 181, 164, 129]
    
    var arrayModel: [Food] = [
        Food(
            imageName: "lollipop--",
            name: "Lollipop",
            category: .CandiesAndSweets,
            price: "10",
            shortDescription: "Classic colorful lollipop with fruity flavor.",
            ingredients: ["Sugar", "Corn syrup", "Flavoring", "Food coloring"],
            ration: "4.5",
            isFavourite: false,
            isAdded: false,
            quantity: 0
        ),
        Food(
            imageName: "gummy-candy-",
            name: "Gummy Candy",
            category: .CandiesAndSweets,
            price: "8",
            shortDescription: "Chewy fruit-flavored gummy candies.",
            ingredients: ["Gelatin", "Sugar", "Fruit juice", "Citric acid"],
            ration: "4.2",
            isFavourite: false,
            isAdded: false,
            quantity: 0
        ),
        Food(
            imageName: "caramel-toffee-",
            name: "Caramel Toffee",
            category: .CandiesAndSweets,
            price: "12",
            shortDescription: "Soft and chewy caramel toffee.",
            ingredients: ["Butter", "Sugar", "Cream", "Vanilla"],
            ration: "4.7",
            isFavourite: false,
            isAdded: false,
            quantity: 0
        ),
        Food(
            imageName: "marshmallow-",
            name: "Marshmallow",
            category: .CandiesAndSweets,
            price: "9",
            shortDescription: "Fluffy and sweet marshmallow treats.",
            ingredients: ["Sugar", "Gelatin", "Corn syrup", "Vanilla"],
            ration: "4.3",
            isFavourite: false,
            isAdded: false,
            quantity: 0
        ),
        Food(
            imageName: "fruit-cake--",
            name: "Fruit Cake",
            category: .CakesAndPastries,
            price: "35",
            shortDescription: "Rich and moist cake with dried fruits.",
            ingredients: ["Flour", "Eggs", "Dried fruits", "Spices"],
            ration: "4.6",
            isFavourite: false,
            isAdded: false,
            quantity: 0
        ),
        Food(
            imageName: "berry-muffin-",
            name: "Berry Muffin",
            category: .CakesAndPastries,
            price: "20",
            shortDescription: "Soft muffin filled with fresh berries.",
            ingredients: ["Flour", "Sugar", "Berries", "Milk"],
            ration: "4.4",
            isFavourite: false,
            isAdded: false,
            quantity: 0
        ),
        Food(
            imageName: "macaron-",
            name: "Macaron",
            category: .CakesAndPastries,
            price: "25",
            shortDescription: "French almond-based delicate pastry.",
            ingredients: ["Almond flour", "Egg whites", "Sugar", "Buttercream"],
            ration: "4.8",
            isFavourite: false,
            isAdded: false,
            quantity: 0
        ),
        Food(
            imageName: "confetti-cake-",
            name: "Confetti Cake",
            category: .CakesAndPastries,
            price: "30",
            shortDescription: "Colorful layered cake with sprinkles.",
            ingredients: ["Flour", "Eggs", "Sugar", "Sprinkles"],
            ration: "4.5",
            isFavourite: false,
            isAdded: false,
            quantity: 0
        ),
        Food(
            imageName: "fruit-salad--",
            name: "Fruit Salad",
            category: .FruitDesserts,
            price: "15",
            shortDescription: "Healthy mix of fresh fruits.",
            ingredients: ["Banana", "Apple", "Grapes", "Watermelon"],
            ration: "4.7",
            isFavourite: false,
            isAdded: false,
            quantity: 0
        ),
        Food(
            imageName: "smoothie-bowl-",
            name: "Smoothie Bowl",
            category: .FruitDesserts,
            price: "18",
            shortDescription: "Thick smoothie topped with fruits and nuts.",
            ingredients: ["Banana", "Berries", "Yogurt", "Granola"],
            ration: "4.6",
            isFavourite: false,
            isAdded: false,
            quantity: 0
        ),
        Food(
            imageName: "ice-cream-with-fruits--",
            name: "Ice Cream with Fruits",
            category: .FruitDesserts,
            price: "22",
            shortDescription: "Creamy ice cream served with fresh fruits.",
            ingredients: ["Milk", "Sugar", "Fruits", "Vanilla"],
            ration: "4.8",
            isFavourite: false,
            isAdded: false,
            quantity: 0
        ),
        Food(
            imageName: "apple-strudel-",
            name: "Apple Strudel",
            category: .FruitDesserts,
            price: "28",
            shortDescription: "Crispy pastry filled with cinnamon apples.",
            ingredients: ["Apples", "Cinnamon", "Puff pastry", "Sugar"],
            ration: "4.9",
            isFavourite: false,
            isAdded: false,
            quantity: 0
        )
    ]
}
