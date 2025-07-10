import SwiftUI

struct FoodCartView: View {
    @StateObject var foodCartModel =  FoodCartViewModel()
    @State var time1 = true
    @State var time2 = false
    @State var time3 = false
    @State var textView = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 252/255, green: 231/255, blue: 243/255), Color(red: 237/255, green: 233/255, blue: 254/255)], startPoint: .leading, endPoint: .trailing)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack {
                    VStack(spacing: 15) {
                        ForEach(foodCartModel.foods.filter { $0.isAdded }) { food in
                            Rectangle()
                                .fill(.white)
                                .overlay {
                                    HStack(alignment: .bottom) {
                                        Image(food.imageName)
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(12)
                                        
                                        VStack(alignment: .leading, spacing: 40) {
                                            Text(food.name)
                                                .InterBold(size: 16)
                                            
                                            Text("$\(food.price)")
                                                .InterBold(size: 16, color: Color(red: 236/255, green: 72/255, blue: 153/255))
                                         
                                        }
                                        .padding(.leading, 5)
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 15) {
                                            Button(action: {
                                                foodCartModel.decreaseQuantity(for: food)
                                            }) {
                                                Image(.minus)
                                                    .resizable()
                                                    .frame(width: 32, height: 32)
                                            }
                                            
                                            Text("\(food.quantity)g")
                                                .InterBold(size: 16)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                            
                                            Button(action: {
                                                foodCartModel.increaseQuantity(for: food)
                                            }) {
                                                Image(.plus2)
                                                    .resizable()
                                                    .frame(width: 32, height: 32)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(height: 116)
                                .cornerRadius(16)
                                .padding(.horizontal)
                                .shadow(radius: 1)
                        }
                        
                    }
                    .padding(.top, 70)
                    
                    Rectangle()
                        .fill(.white)
                        .overlay {
                            VStack(spacing: 20) {
                                HStack {
                                    Text("Pickup Time")
                                        .InterBold(size: 16)
                                    
                                    Spacer()
                                    
                                    Image(.pick)
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                }
                                
                                HStack {
                                    Button(action: {
                                        withAnimation {
                                            time1 = true
                                            time2 = false
                                            time3 = false
                                        }
                                    }) {
                                        Rectangle()
                                            .fill(time1 ? Color(red: 245/255, green: 243/255, blue: 255/255) : Color(red: 249/255, green: 250/255, blue: 252/255))
                                            .overlay {
                                                HStack {
                                                    VStack(alignment: .leading, spacing: 10) {
                                                        Text("Today")
                                                            .Inter(size: 14, color: time1 ? Color(red: 124/255, green: 58/255, blue: 237/255) : Color(red: 107/255, green: 114/255, blue: 128/255))
                                                        
                                                        Text("14:30")
                                                            .InterBold(size: 18, color: time1 ? Color(red: 109/255, green: 40/255, blue: 217/255) : Color(red: 75/255, green: 85/255, blue: 99/255))
                                                    }
                                                    
                                                    Spacer()
                                                }
                                                .padding(.horizontal)
                                            }
                                            .frame(height: 72)
                                            .cornerRadius(12)
                                    }
                                    
                                    Button(action: {
                                        withAnimation {
                                            time1 = false
                                            time2 = true
                                            time3 = false
                                        }
                                    }) {
                                        Rectangle()
                                            .fill(time2 ? Color(red: 245/255, green: 243/255, blue: 255/255) : Color(red: 249/255, green: 250/255, blue: 252/255))
                                            .overlay {
                                                HStack {
                                                    VStack(alignment: .leading, spacing: 10) {
                                                        Text("Today")
                                                            .Inter(size: 14, color: time2 ? Color(red: 124/255, green: 58/255, blue: 237/255) : Color(red: 107/255, green: 114/255, blue: 128/255))
                                                        
                                                        Text("15:00")
                                                            .InterBold(size: 18, color: time2 ? Color(red: 109/255, green: 40/255, blue: 217/255) : Color(red: 75/255, green: 85/255, blue: 99/255))
                                                    }
                                                    
                                                    Spacer()
                                                }
                                                .padding(.horizontal)
                                            }
                                            .frame(height: 72)
                                            .cornerRadius(12)
                                    }
                                    
                                    Button(action: {
                                        withAnimation {
                                            time1 = false
                                            time2 = false
                                            time3 = true
                                        }
                                    }) {
                                        Rectangle()
                                            .fill(time3 ? Color(red: 245/255, green: 243/255, blue: 255/255) : Color(red: 249/255, green: 250/255, blue: 252/255))
                                            .overlay {
                                                HStack {
                                                    VStack(alignment: .leading, spacing: 10) {
                                                        Text("Today")
                                                            .Inter(size: 14, color: time3 ? Color(red: 124/255, green: 58/255, blue: 237/255) : Color(red: 107/255, green: 114/255, blue: 128/255))
                                                        
                                                        Text("15:30")
                                                            .InterBold(size: 18, color: time3 ? Color(red: 109/255, green: 40/255, blue: 217/255) : Color(red: 75/255, green: 85/255, blue: 99/255))
                                                    }
                                                    
                                                    Spacer()
                                                }
                                                .padding(.horizontal)
                                            }
                                            .frame(height: 72)
                                            .cornerRadius(12)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 144)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .shadow(radius: 1)
                    
                    Rectangle()
                        .fill(.white)
                        .overlay {
                            VStack(spacing: 20) {
                                HStack {
                                    Text("Order Notes")
                                        .InterBold(size: 16)
                                    
                                    Spacer()
                                    
                                    Image(.order)
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                }
                                
                                CustomTextView(text: $textView, placeholder: "Add any special instructions...")
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 168)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .shadow(radius: 1)
                    
                    Color.clear.frame(height: 190)
                }
            }
            
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(.white)
                    .frame(height: 161)
                
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: 0.8)
                
                HStack {
                    Text("Cart")
                        .InterBold(size: 24, color: Color(red: 236/255, green: 72/255, blue: 153/255))
                    
                    Spacer()
                    
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / -40)
            
            if !UserdefaultsManager().isGuest() {
                ZStack(alignment: .top) {
                    Rectangle()
                        .fill(.white)
                        .frame(height: 271)
                    
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                        .frame(height: 0.8)
                    
                    Button(action: {
                        placeOrder()
                    }) {
                        Rectangle()
                            .fill(Color(red: 236/255, green: 72/255, blue: 153/255))
                            .overlay {
                                Text("Place order")
                                    .InterBold(size: 16, color: .white)
                            }
                            .frame(height: 54)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)
                }
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.width > 900 ? UIScreen.main.bounds.height / 1.06 : UIScreen.main.bounds.width > 600 ? UIScreen.main.bounds.height / 1.07 : UIScreen.main.bounds.width > 430 ? UIScreen.main.bounds.height / 1.13 : UIScreen.main.bounds.height / 1.15)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Order Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    
    func placeOrder() {
        let productsInCart = foodCartModel.foods.filter { $0.isAdded && $0.quantity > 0 }
        
        guard !productsInCart.isEmpty else {
            alertMessage = "Your cart is empty. Please add some items before placing an order."
            showAlert = true
            return
        }
        
        UserdefaultsManager.saveOrder(products: productsInCart)
        
        alertMessage = "Your order has been placed successfully!"
        showAlert = true
        
        foodCartModel.loadFoods()
    }
    
}

#Preview {
    FoodCartView()
}

struct CustomTextView: View {
    @Binding var text: String
    @FocusState var isTextFocused: Bool
    var placeholder: String
    var height: CGFloat = 96
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color(red: 249/255, green: 250/255, blue: 250/255))
                .cornerRadius(16)
            
            TextEditor(text: $text)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 10)
                .padding(.top, 5)
                .frame(height: height)
                .font(.custom("Inter-Regular", size: 14))
                .focused($isTextFocused)
            
            if text.isEmpty && !isTextFocused {
                VStack {
                    Text(placeholder)
                        .Inter(size: 14, color: Color(red: 153/255, green: 173/255, blue: 200/255))
                        .padding(.leading, 15)
                    //                        .padding(.horizontal)
                        .padding(.top, 10)
                        .onTapGesture {
                            isTextFocused = true
                        }
                    Spacer()
                }
            }
        }
        .frame(height: height)
    }
}
