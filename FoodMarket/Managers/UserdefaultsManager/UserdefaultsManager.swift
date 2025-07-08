import Foundation

class UserdefaultsManager {
    
    private static let ordersKey = "SavedOrders"
    
    static func saveOrder(products: [Food]) {
        var orders = getOrders()
        
        let newOrderId = String(Int.random(in: 20000...99999))
        
        let newOrder = Order(
            id: newOrderId,
            date: Date(),
            status: .preparing,
            products: products
        )
        
        orders.append(newOrder)
        
        if let data = try? JSONEncoder().encode(orders) {
            UserDefaults.standard.set(data, forKey: ordersKey)
        }
        
        resetCartState()
    }
    
    static func getOrders() -> [Order] {
        guard let data = UserDefaults.standard.data(forKey: ordersKey) else {
            return []
        }
        if var orders = try? JSONDecoder().decode([Order].self, from: data) {
            
            let now = Date()
            var updated = false
            
            for i in orders.indices {
                let order = orders[i]
                if order.status == .preparing {
                    if now.timeIntervalSince(order.date) >= 10 * 60 {
                        orders[i].status = .completed
                        updated = true
                    }
                }
            }
            
            if updated {
                if let newData = try? JSONEncoder().encode(orders) {
                    UserDefaults.standard.set(newData, forKey: ordersKey)
                }
            }
            
            return orders
        }
        return []
    }

    
    static func updateOrderStatus(orderId: String, newStatus: OrderStatus) {
        var orders = getOrders()
        
        if let index = orders.firstIndex(where: { $0.id == orderId }) {
            orders[index].status = newStatus
            
            if let data = try? JSONEncoder().encode(orders) {
                UserDefaults.standard.set(data, forKey: ordersKey)
            }
        }
    }
    
    static func resetCartState() {
        guard let data = UserDefaults.standard.data(forKey: "SavedFoods"),
              var foods = try? JSONDecoder().decode([Food].self, from: data) else {
            return
        }
        
        for i in foods.indices {
            foods[i].isAdded = false
            foods[i].quantity = 0
        }
        
        if let newData = try? JSONEncoder().encode(foods) {
            UserDefaults.standard.set(newData, forKey: "SavedFoods")
        }
    }
    
    func enterAsGuest() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "guest")
    }
    
    func isGuest() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: "guest")
    }
    
    func quitQuest() {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "guest")
    }
    
    func checkLogin() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: "isLoggedIn")
    }
    
    func saveLoginStatus(_ isLoggedIn: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(isLoggedIn, forKey: "isLoggedIn")
    }
    
    func getEmail() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "currentEmail")
    }
    
    func getPassword() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "password")
    }
    
    func logout() {
        saveLoginStatus(false)
    }
    
    func saveCurrentEmail(_ email: String) {
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "currentEmail")
    }
    
    func savePassword(_ password: String) {
        let defaults = UserDefaults.standard
        defaults.set(password, forKey: "password")
    }
    
    func deletePassword() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "password")
    }
    
    func deletePhone() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "currentEmail")
    }
    
    func saveName(_ name: String) {
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "name")
    }
    
    func getName() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "name")
    }
    
    func deleteName() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "name")
    }
    
    func saveID(_ name: String) {
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "id")
    }
    
    func getID() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "id")
    }
    
    func deleteID() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "id")
    }
    
    func clearAllUserData() {
        let defaults = UserDefaults.standard
        
        let keysToRemove = [
            UserdefaultsManager.ordersKey, 
            "currentEmail",
            "password",
            "name",
            "id"
        ]
        
        for key in keysToRemove {
            defaults.removeObject(forKey: key)
        }
        
        defaults.synchronize()
    }

}

enum OrderStatus: String, Codable {
    case preparing = "Preparing"
    case completed = "Completed"
    case cancelled = "Cancelled"
}

struct Order: Codable, Identifiable {
    var id: String
    var date: Date
    var status: OrderStatus
    var products: [Food]
}
