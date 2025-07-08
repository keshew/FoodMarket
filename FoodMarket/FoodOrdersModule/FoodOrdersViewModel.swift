import Foundation

class FoodOrdersViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var isDetail = false
    @Published var selectedOrder: Order? = nil
    private let ordersKey = "SavedOrders"
    
    init() {
        loadOrders()
    }
    
    func loadOrders() {
        guard let data = UserDefaults.standard.data(forKey: ordersKey) else {
            orders = []
            return
        }
        
        do {
            let decodedOrders = try JSONDecoder().decode([Order].self, from: data)
            orders = decodedOrders
        } catch {
            print("Ошибка при загрузке заказов из UserDefaults: \(error)")
            orders = []
        }
    }
}
