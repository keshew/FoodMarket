import SwiftUI

struct FoodOrdersView: View {
    @StateObject var foodOrdersModel =  FoodOrdersViewModel()

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 252/255, green: 231/255, blue: 243/255), Color(red: 237/255, green: 233/255, blue: 254/255)], startPoint: .leading, endPoint: .trailing)
                .ignoresSafeArea()
            
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(.white)
                    .frame(height: 161)
                
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: 0.8)
                
                HStack {
                    Text("Orders")
                        .InterBold(size: 24, color: Color(red: 236/255, green: 72/255, blue: 153/255))
                    
                    Spacer()
                    
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / -40)
       
            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    ForEach(foodOrdersModel.orders) { order in
                        Rectangle()
                            .fill(.white)
                            .overlay {
                                VStack(spacing: 18) {
                                    HStack(alignment: .top) {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text("Order #\(order.id)")
                                                .InterBold(size: 16)
                                            
                                            Text(order.date.formatted(date: .abbreviated, time: .shortened))
                                                .Inter(size: 14, color: Color(red: 107/255, green: 114/255, blue: 128/255))
                                        }
                                        
                                        Spacer()
                                        
                                        Text(order.status.rawValue)
                                            .Inter(size: 14, color: order.status.textColor)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(order.status.backgroundColor)
                                            .cornerRadius(16)
                                    }
                                    
                                    Rectangle()
                                        .fill(.gray.opacity(0.3))
                                        .frame(height: 0.4)
                                    
                                    HStack {
                                        let totalPrice = calculateTotalPrice(for: order.products)
                                        
                                        Text("$\(String(format: "%.2f", totalPrice))")
                                            .InterBold(size: 16, color: Color(red: 219/255, green: 39/255, blue: 119/255))
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            foodOrdersModel.selectedOrder = order
                                            foodOrdersModel.isDetail = true
                                        }) {
                                            HStack {
                                                Text("View Details")
                                                    .Inter(size: 14, color: Color(red: 124/255, green: 58/255, blue: 237/255))
                                                
                                                Image(systemName: "chevron.right")
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .foregroundStyle(Color(red: 124/255, green: 58/255, blue: 237/255))
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 127)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    
                    Color.clear.frame(height: 80)
                }
                .padding(.top, 70)
            }
        }
        .fullScreenCover(isPresented: $foodOrdersModel.isDetail) {
            FoodOrderDetailView(order: $foodOrdersModel.selectedOrder)
        }
    }
    
    func calculateTotalPrice(for products: [Food]) -> Double {
        products.reduce(0) { total, food in
            let pricePer100g = Double(food.price) ?? 0
            let quantityInGrams = Double(food.quantity)
            let priceForQuantity = pricePer100g * (quantityInGrams / 100.0)
            return total + priceForQuantity
        }
    }
}

#Preview {
    FoodOrdersView()
}

import SwiftUI

extension OrderStatus {
    var textColor: Color {
        switch self {
        case .preparing:
            return Color(red: 156/255, green: 163/255, blue: 175/255)
        case .completed:
            return Color.green
        case .cancelled:
            return Color(red: 236/255, green: 72/255, blue: 73/255)
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .preparing:
            return Color(red: 221/255, green: 221/255, blue: 221/255)
        case .completed:
            return Color(red: 198/255, green: 255/255, blue: 198/255)
        case .cancelled:
            return Color(red: 252/255, green: 227/255, blue: 227/255)
        }
    }
}
