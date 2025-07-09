import SwiftUI

struct FoodLoginView: View {
    @StateObject var FoodLoginModel =  FoodLoginViewModel()
    
    @State var email = ""
    @State var password = ""
    @State var isSign = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State var isTab = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 252/255, green: 231/255, blue: 243/255), Color(red: 237/255, green: 233/255, blue: 254/255)], startPoint: .leading, endPoint: .trailing)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack {
                    Image(.onb)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: UIScreen.main.bounds.width > 420 ? 436 : 360)
                        .padding(.top, 30)
                    
                    Rectangle()
                        .fill(Color(red: 247/255, green: 245/255, blue: 247/255))
                        .overlay {
                            VStack(spacing: 15) {
                                CustomTextFiled(text: $email, placeholder: "Email")
                                
                                CustomSecureField(text: $password, placeholder: "Password")
                                
                                Button(action: {
                                    logIn()
                                }) {
                                    Rectangle()
                                        .fill(Color(red: 236/255, green: 72/255, blue: 153/255))
                                        .overlay {
                                            Text("Log in")
                                                .InterBold(size: 16)
                                        }
                                        .frame(height: 50)
                                        .cornerRadius(12)
                                        .padding(.horizontal)
                                }
                                
                                Button(action: {
                                    isTab = true
                                    UserdefaultsManager().enterAsGuest()
                                }) {
                                    Rectangle()
                                        .fill(.clear)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color(red: 236/255, green: 72/255, blue: 153/255))
                                            
                                            Text("Skip")
                                                .InterBold(size: 16, color: Color(red: 236/255, green: 72/255, blue: 153/255))
                                        }
                                        .frame(height: 50)
                                        .cornerRadius(12)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .frame(height: 278)
                        .cornerRadius(16)
                        .padding(.horizontal)
                        .shadow(radius: 8)
                        .padding(.top, 20)
                    
                    HStack {
                        Button(action: {
                            isSign = true
                        }) {
                            Text("Register")
                                .InterBold(size: 16, color: Color(red: 236/255, green: 72/255, blue: 153/255))
                        }
                    }
                    .padding(.top, 60)
                }
            }
            .scrollDisabled(UIScreen.main.bounds.width > 380  ? true : false)
        }
        .fullScreenCover(isPresented: $isSign) {
            FoodSignView()
        }
        .fullScreenCover(isPresented: $isTab) {
            FoodTabBarView()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Login Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func logIn() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }
        
        NetworkManager.shared.login(email: email, password: password) { result in
            switch result {
            case .success(let user):
                print("Login successful: \(user)")
                
                let manager = UserdefaultsManager()
                if let userId = user["user_id"] as? String {
                    manager.saveID(userId)
                }
                if let userEmail = user["email"] as? String {
                    manager.saveCurrentEmail(userEmail)
                }
                manager.savePassword(password)
                if let userName = user["name"] as? String {
                    manager.saveName(userName)
                }
                manager.saveLoginStatus(true)
                
                DispatchQueue.main.async {
                    isTab = true
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }

}

#Preview {
    FoodLoginView()
}

