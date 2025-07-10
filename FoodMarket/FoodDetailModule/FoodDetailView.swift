import SwiftUI

struct FoodDetailView: View {
    @StateObject var foodDetailModel =  FoodDetailViewModel()
    @Binding var food: Food
    @Environment(\.presentationMode) var presentationMode
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
            }
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / -40)
            
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(.white)
                    .frame(height: 161)
                
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: 0.8)
            }
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.width > 600 ? UIScreen.main.bounds.height / 1.08 : UIScreen.main.bounds.height / 1.17)
            
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(.backArrow)
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            food.isFavourite.toggle()
                        }) {
                            Image(food.isFavourite ? .fav : .notFav2)
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    }
                    .padding(.horizontal)
                    
                    Image(food.imageName)
                        .resizable()
                        .frame(height: UIScreen.main.bounds.width > 420 ? 400 : 330)
                        .clipShape(RoundedCorners(radius: 66, corners: [.bottomLeft, .bottomRight]))
                        .padding(.top, 8)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 15) {
                            Text(food.name)
                                .InterBold(size: 24)
                            
                            HStack {
                                Image(.stars)
                                    .resizable()
                                    .frame(width: 92, height: 16)
                                Text(food.ration)
                                    .Inter(size: 16, color: Color(red: 107/255, green: 114/255, blue: 128/255))
                            }
                            
                            Text(food.shortDescription)
                                .Inter(size: 16, color: Color(red: 75/255, green: 85/255, blue: 99/255))
                            
                            Text("Ingredients")
                                .InterBold(size: 16)
                            
                            HStack {
                                LazyVGrid(columns: [GridItem(.flexible()),
                                                    GridItem(.flexible()),
                                                    GridItem(.flexible())], spacing: 15) {
                                    ForEach(0..<food.ingredients.count, id: \.self) { index in
                                        VStack {
                                            Text(food.ingredients[index])
                                                .Inter(size: 14, color: foodDetailModel.contact.colorFont[index])
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.7)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 5)
                                                .background(
                                                    foodDetailModel.contact.colorBack[index]
                                                )
                                                .cornerRadius(16)
                                            
                                        }
                                    }
                                }
                                                    .frame(width: UIScreen.main.bounds.width / 1.7)
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        Spacer()
                    }
                    
                    VStack {
                        HStack {
                            HStack(spacing: 15) {
                                Button(action: {
                                    if food.quantity > 0 {
                                        food.quantity = max(0, food.quantity - 100)
                                    }
                                }) {
                                    Image(.minus)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                    
                                }
                                
                                Text("\(food.quantity)g")
                                    .InterBold(size: 15)
                                
                                Button(action: {
                                    food.quantity = food.quantity + 100
                                }) {
                                    Image(.plus2)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                    
                                }
                            }
                            
                            Spacer()
                            
                            Text("$\(food.price)")
                                .InterBold(size: 20)
                        }
                        
                        Button(action: {
                            if food.quantity == 0 {
                                food.isAdded = true
                                food.quantity += 100
                            } else {
                                food.quantity = food.quantity + food.quantity
                            }
                        }) {
                            Rectangle()
                                .fill(Color(red: 236/255, green: 72/255, blue: 153/255))
                                .overlay {
                                    Text("Add to order")
                                        .InterBold(size: 20, color: .white)
                                }
                                .frame(height: 56)
                                .cornerRadius(24)
                        }
                    }
                    .padding(.top, UIScreen.main.bounds.width > 900 ? 520 : UIScreen.main.bounds.width > 600 ? 350 : 50)
                    .padding(.horizontal)
                }
            }
            .scrollDisabled(UIScreen.main.bounds.width > 380  ? true : false)
        }
    }
}

#Preview {
    FoodDetailView(food: .constant(Food(imageName: "", name: "", category: .All, price: "", shortDescription: "", ingredients: ["aqwerwq", "asdasdasd", "aqwerwq"], ration: "")))
}

struct RoundedCorners: Shape {
    var radius: CGFloat = 16
    var corners: UIRectCorner = [.bottomLeft, .bottomRight]
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
