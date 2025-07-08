import SwiftUI

class FoodProfileViewModel: ObservableObject {
    let contact = FoodProfileModel()
    
    @Published var isNotif: Bool {
        didSet {
            UserDefaults.standard.set(isNotif, forKey: "isNotif")
        }
    }
    init() {
        self.isNotif = UserDefaults.standard.bool(forKey: "isNotif")
    }
}
