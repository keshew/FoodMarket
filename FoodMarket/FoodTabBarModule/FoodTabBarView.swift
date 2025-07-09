import SwiftUI

struct FoodTabBarView: View {
    @StateObject var foodTabBarModel =  FoodTabBarViewModel()
    @State private var selectedTab: CustomTabBar.TabType = .Home

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                if selectedTab == .Home {
                    FoodHomeView()
                } else if selectedTab == .Cart {
                    FoodCartView()
                } else if selectedTab == .Orders {
                    FoodOrdersView()
                } else if selectedTab == .Profile {
                    FoodProfileView()
                }
            }
            .frame(maxHeight: .infinity)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 0)
            }
            
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    FoodTabBarView()
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabType
    
    enum TabType: Int {
        case Home
        case Cart
        case Orders
        case Profile
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                Rectangle()
                    .fill(.white)
                    .frame(height: 110)
                    .edgesIgnoringSafeArea(.bottom)
                    .offset(y: 35)
            }
            
            HStack(spacing: 65) {
                TabBarItem(imageName: "tab1", tab: .Home, selectedTab: $selectedTab)
                TabBarItem(imageName: "tab2", tab: .Cart, selectedTab: $selectedTab)
                TabBarItem(imageName: "tab3", tab: .Orders, selectedTab: $selectedTab)
                TabBarItem(imageName: "tab4", tab: .Profile, selectedTab: $selectedTab)
            }
            .padding(.top, 10)
            .frame(height: 60)
        }
    }
}

struct TabBarItem: View {
    let imageName: String
    let tab: CustomTabBar.TabType
    @Binding var selectedTab: CustomTabBar.TabType
    
    var body: some View {
        Button(action: {
            withAnimation {
                selectedTab = tab
            }
        }) {
            VStack {
                Image(selectedTab == tab ? "\(imageName)Picked" : imageName)
                    .resizable()
                    .frame(
                        width: tab == CustomTabBar.TabType.Home ? 15 : tab == CustomTabBar.TabType.Cart ? 24 : 20,
                        height: 22
                    )
                
                Text("\(tab)")
                    .Inter(
                        size: 12,
                        color: selectedTab == tab
                        ? Color(red: 236/255, green: 72/255, blue: 153/255) : Color(red: 156/255, green: 163/255, blue: 175/255))
            }
        }
    }
}
