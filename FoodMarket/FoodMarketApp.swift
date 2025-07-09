import SwiftUI

@main
struct FoodMarketApp: App {
    var body: some Scene {
        WindowGroup {
            if UserdefaultsManager().checkLogin() {
                FoodTabBarView()
            } else {
                FoodSignView()
                    .onAppear() {
                        UserdefaultsManager().quitQuest()
                    }
            }
        }
    }
}
