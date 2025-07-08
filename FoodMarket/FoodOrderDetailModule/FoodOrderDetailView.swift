import SwiftUI

struct FoodOrderDetailView: View {
    @StateObject var foodOrderDetailModel =  FoodOrderDetailViewModel()
    @Binding var order: Order?
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isProcessingCancel = false
    
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
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color(red: 219/255, green: 39/255, blue: 119/255))
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("Order #\(order!.id)")
                            .InterBold(size: 20, color: Color(red: 236/255, green: 72/255, blue: 153/255))
                        
                        Text("\(order!.status.rawValue)")
                            .Inter(size: 14, color: Color(red: 156/255, green: 163/255, blue: 175/255))
                    }
                    .padding(.trailing, 10)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / -40)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    ForEach(order!.products, id: \.id) { product in
                        Rectangle()
                            .fill(.white)
                            .overlay {
                                HStack(alignment: .bottom) {
                                    Image(product.imageName)
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(12)
                                    
                                    VStack(alignment: .leading, spacing: 40) {
                                        Text(product.name)
                                            .InterBold(size: 16)
                                        
                                        let pricePer100g = Double(product.price) ?? 0
                                        let quantityInGrams = Double(product.quantity)
                                        let totalPrice = pricePer100g * quantityInGrams / 100.0
                                        
                                        Text("$\(String(format: "%.2f", totalPrice))")
                                            .InterBold(size: 16, color: Color(red: 236/255, green: 72/255, blue: 153/255))
                                    }
                                    .padding(.leading, 5)
                                    
                                    Spacer()
                                    
                                    Text("\(product.quantity)g")
                                        .Inter(size: 16)
                                        .padding(.trailing)
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 116)
                            .cornerRadius(16)
                            .padding(.horizontal)
                            .shadow(radius: 1)
                    }
                    
                    Color.clear.frame(height: 80)
                }
                .padding(.top)
            }
            .padding(.top, 70)
            
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(.white)
                    .frame(height: 171)
                
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: 0.8)
                
                VStack(spacing: 25) {
                    HStack {
                        Text("Total Amount")
                            .Inter(size: 16, color: Color(red: 107/255, green: 114/255, blue: 128/255))
                        
                        Spacer()
                        
                        Text("$\(String(format: "%.2f", calculateTotalPrice(for: order!.products)))")
                            .InterBold(size: 20, color: Color(red: 219/255, green: 39/255, blue: 119/255))
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        cancelOrder()
                    }) {
                        Rectangle()
                            .fill(Color(red: 252/255, green: 227/255, blue: 227/255))
                            .overlay {
                                Text("Cancel the order")
                                    .InterBold(size: 16, color: Color(red: 236/255, green: 72/255, blue: 73/255))
                            }
                            .frame(height: 54)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .disabled(isProcessingCancel || order?.status == .cancelled || order?.status == .completed)
                    .opacity((isProcessingCancel || order?.status == .cancelled || order?.status == .completed) ? 0.5 : 1)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Order Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
                .padding(.top, 20)
            }
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 1.17)
        }
     
    }
    func calculateTotalPrice(for products: [Food]) -> Double {
        products.reduce(0) { total, food in
            let pricePer100g = Double(food.price) ?? 0
            let quantityInGrams = Double(food.quantity)
            return total + pricePer100g * (quantityInGrams / 100.0)
        }
    }
    
    func cancelOrder() {
        guard let order = order else { return }
        guard order.status != .cancelled && order.status != .completed else {
            alertMessage = "Order is already \(order.status.rawValue)."
            showAlert = true
            return
        }
        
        isProcessingCancel = true
        
        UserdefaultsManager.updateOrderStatus(orderId: order.id, newStatus: .cancelled)
        
        self.order?.status = .cancelled
        
        alertMessage = "Your order has been cancelled."
        showAlert = true
        
        isProcessingCancel = false
    }
}

#Preview {
    FoodOrderDetailView(order: .constant(Order(id: "", date: Date(), status: .cancelled, products: [Food(imageName: "", name: "", category: Category.All, price: "", shortDescription: "", ingredients: [""], ration: "")])))
}

