import SwiftUI

struct FoodHomeView: View {
    @StateObject var foodHomeModel = FoodHomeViewModel()
    @State private var searchText = ""
    @State private var selectedIndices: Set<Int> = []
    
    let grid = [GridItem(.flexible(), spacing: -30),
                GridItem(.flexible(), spacing: -30)]
    
    @State private var selectedCategory: Category = .All
    @State var isDetail = false

    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 252/255, green: 231/255, blue: 243/255), Color(red: 237/255, green: 233/255, blue: 254/255)], startPoint: .leading, endPoint: .trailing)
                .ignoresSafeArea()
            
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(.white)
                    .frame(height: 241)
                
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: 0.8)
            }
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 80)
            
            VStack {
                VStack(spacing: 25) {
                    HStack {
                        Text("Home")
                            .InterBold(size: 24, color: Color(red: 219/255, green: 39/255, blue: 119/255))
                        
                        Spacer()
                    }
                    
                    CustomSearchBar(text: $foodHomeModel.searchText, placeholder: "Search sweets...")
                    
                }
                .padding(.horizontal)
                
                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<foodHomeModel.contact.arrayOfSearch.count, id: \.self) { index in
                                let baseName = foodHomeModel.contact.arrayOfSearch[index]
                                let categoryForIndex: Category = {
                                    switch index {
                                    case 0: return .All
                                    case 1: return .Favourites
                                    case 2: return .CandiesAndSweets
                                    case 3: return .CakesAndPastries
                                    case 4: return .FruitDesserts
                                    default: return .All
                                    }
                                }()
                                let imageName = (foodHomeModel.selectedCategory == categoryForIndex) ? baseName + "p" : baseName
                                
                                Image(imageName)
                                    .resizable()
                                    .frame(width: foodHomeModel.contact.arrayWidth[index], height: 35)
                                    .onTapGesture {
                                        foodHomeModel.selectedCategory = categoryForIndex
                                    }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 30)
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: grid, spacing: 20) {
                        ForEach(foodHomeModel.searchedFoods) { food in
                            Rectangle()
                                .fill(.white)
                                .overlay {
                                    VStack(alignment: .leading) {
                                        Image(food.imageName)
                                            .resizable()
                                            .overlay {
                                                Button(action: {
                                                    foodHomeModel.toggleFavourite(for: food)
                                                }) {
                                                    Image(food.isFavourite ? .fav : .notFav)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 32, height: 32)
                                                }
//                                                .offset(x: 45, y: -40)
                                                .offset(x: UIScreen.main.bounds.width > 900 ? 185 : UIScreen.main.bounds.width > 600 ? 185 : 45, y: UIScreen.main.bounds.width > 900 ? -80 : UIScreen.main.bounds.width > 600 ? -80 : -40)
                                            }
//                                            .frame(width: 147, height: 138)
//                                            .frame(width: 441, height: 236)
                                            .frame(width: UIScreen.main.bounds.width > 900 ? 441 : UIScreen.main.bounds.width > 600 ? 341 : 147, height: UIScreen.main.bounds.width > 900 ? 236 : UIScreen.main.bounds.width > 600 ? 236 : 138)
                                            .cornerRadius(16)
                                        
                                        HStack {
                                            Text(food.name)
                                                .Inter(size: 14, color: .black)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.7)
                                        }
                                        .padding(.top, 5)
                                        
                                        HStack(spacing: 5 ){
                                            Image(systemName: "star.fill")
                                                .foregroundStyle(Color(red: 245/255, green: 158/255, blue: 12/255))
                                            
                                            Text(food.ration)
                                                .Inter(size: 14)
                                        }
                                        .padding(.top, 5)
                                        
                                        HStack {
                                            Text("$\(food.price)")
                                                .InterBold(size: 14, color: Color(red: 236/255, green: 72/255, blue: 153/255))
                                                .minimumScaleFactor(0.5)
                                            
                                            Spacer()
                                            
                                            if food.isAdded {
                                                HStack {
                                                    Button(action: {
                                                        foodHomeModel.decreaseQuantity(for: food)
                                                    }) {
                                                        Image(.minus)
                                                            .resizable()
                                                            .frame(width: 32, height: 32)
                                                    }
                                                    
                                                    Text("\(food.quantity)g")
                                                        .Inter(size: 10)
                                                        .lineLimit(1)
                                                        .frame(width: 30)
                                                    
                                                    Button(action: {
                                                        foodHomeModel.increaseQuantity(for: food)
                                                    }) {
                                                        Image(.plus2)
                                                            .resizable()
                                                            .frame(width: 32, height: 32)
                                                    }
                                                }
                                            } else {
                                                Button(action: {
                                                    foodHomeModel.addToCart(food: food)
                                                }) {
                                                    Image(.plus)
                                                        .resizable()
                                                        .frame(width: 32, height: 32)
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 15)
                                }
//                                .frame(width: 181, height: 268)
//                                .frame(width: 481, height: 368)
                                .frame(width: UIScreen.main.bounds.width > 900 ? 481 : UIScreen.main.bounds.width > 600 ? 381 : 181, height: UIScreen.main.bounds.width > 900 ? 368 : UIScreen.main.bounds.width > 600 ? 368 : 268)
                                .cornerRadius(16)
                                .shadow(radius: 2)
                                .onTapGesture {
                                    foodHomeModel.selectedFood = food
                                    isDetail = true
                                }
                        }
                        
                        Color.clear.frame(height: 80)
                    }
                    .padding(.top)
                }
            }
        }
        .fullScreenCover(isPresented: $isDetail, onDismiss: {
            if let updatedFood = foodHomeModel.selectedFood {
                foodHomeModel.updateFood(updatedFood)
            }
        }) {
            FoodDetailView(food: $foodHomeModel.selectedFood)
        }
    }
}


#Preview {
    FoodHomeView()
}

struct CustomSearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search sweets..."
    
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .padding(15)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .font(.system(size: 18, weight: .semibold))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing && !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .onTapGesture {
                    self.isEditing = true
                }
        }
    }
}
