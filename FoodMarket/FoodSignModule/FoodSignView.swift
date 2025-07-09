import SwiftUI

struct FoodSignView: View {
    @StateObject var foodSignModel =  FoodSignViewModel()
    
    @State var name = ""
    @State var email = ""
    @State var password = ""
    @State var isLog = false
    
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
                        .frame(height: UIScreen.main.bounds.width > 420 ? 396 : 330)
                        .padding(.top, 30)
                    
                    Rectangle()
                        .fill(Color(red: 247/255, green: 245/255, blue: 247/255))
                        .overlay {
                            VStack(spacing: 15) {
                                CustomTextFiled(text: $name, placeholder: "Name")
                                
                                CustomTextFiled(text: $email, placeholder: "Email")
                                
                                CustomSecureField(text: $password, placeholder: "Password")
                                
                                Button(action: {
                                    signUp()
                                }) {
                                    Rectangle()
                                        .fill(Color(red: 236/255, green: 72/255, blue: 153/255))
                                        .overlay {
                                            Text("Sign Up")
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
                        .frame(height: 344)
                        .cornerRadius(16)
                        .padding(.horizontal)
                        .shadow(radius: 8)
                        .padding(.top, 20)
                    
                    HStack {
                        Text("Alerady have an account?")
                            .Inter(size: 16, color: Color(red: 76/255, green: 85/255, blue: 99/255))
                        
                        Button(action: {
                            isLog = true
                        }) {
                            Text("Log in")
                                .InterBold(size: 16, color: Color(red: 236/255, green: 72/255, blue: 153/255))
                        }
                    }
                    .padding(.top, 20)
                }
            }
            .scrollDisabled(UIScreen.main.bounds.width > 380  ? true : false)
        }
        .fullScreenCover(isPresented: $isLog) {
            FoodLoginView()
        }
        .fullScreenCover(isPresented: $isTab) {
            FoodTabBarView()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Registration Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func signUp() {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }
        
        NetworkManager.shared.register(name: name, email: email, password: password) { result in
            switch result {
            case .success(let userId):
                print("Registration successful")
                let manager = UserdefaultsManager()
                manager.saveID(userId)
                manager.saveCurrentEmail(email)
                manager.savePassword(password)
                manager.saveName(name)
                manager.saveLoginStatus(true)
                isTab = true
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
    FoodSignView()
}

extension Text {
    func Inter(size: CGFloat,
             color: Color = .black)  -> some View {
        self.font(.custom("Inter-Regular", size: size))
            .foregroundColor(color)
    }
    
    func InterBold(size: CGFloat,
            color: Color = .black)  -> some View {
        self.font(.custom("Inter-Bold", size: size))
            .foregroundColor(color)
    }
}

struct CustomTextFiled: View {
    @Binding var text: String
    @FocusState var isTextFocused: Bool
    var placeholder: String
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(red: 251/255, green: 208/255, blue: 231/255), lineWidth: 2)
                }
                .frame(height: 50)
                .cornerRadius(12)
                .padding(.horizontal, 15)
            
            TextField("", text: $text, onEditingChanged: { isEditing in
                if !isEditing {
                    isTextFocused = false
                }
            })
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .padding(.horizontal, 16)
            .frame(height: 47)
            .font(.custom("Inter-Regular", size: 15))
            .cornerRadius(9)
            .foregroundStyle(.black)
            .focused($isTextFocused)
            .padding(.horizontal, 15)
            
            if text.isEmpty && !isTextFocused {
                Text(placeholder)
                    .Inter(size: 16, color: Color(red: 141/255, green: 160/255, blue: 179/255))
                    .frame(height: 50)
                    .padding(.leading, 30)
                    .onTapGesture {
                        isTextFocused = true
                    }
            }
        }
    }
}

struct CustomSecureField: View {
    @Binding var text: String
    @FocusState var isTextFocused: Bool
    var placeholder: String
    
    @State private var isSecure: Bool = true
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(red: 251/255, green: 208/255, blue: 231/255), lineWidth: 2)
                }
                .frame(height: 50)
                .cornerRadius(12)
                .padding(.horizontal, 15)
            
            HStack {
                if isSecure {
                    SecureField("", text: $text)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .font(.custom("Inter-Regular", size: 16))
                        .foregroundStyle(.black)
                        .focused($isTextFocused)
                } else {
                    TextField("", text: $text)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .font(.custom("Inter-Regular", size: 16))
                        .foregroundStyle(.black)
                        .focused($isTextFocused)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 50)
            .cornerRadius(9)
            .padding(.horizontal, 15)
            
            if text.isEmpty && !isTextFocused {
                Text(placeholder)
                    .font(.custom("Inter-Regular", size: 16))
                    .foregroundColor(Color(red: 141/255, green: 160/255, blue: 179/255))
                    .frame(height: 50)
                    .padding(.leading, 30)
                    .onTapGesture {
                        isTextFocused = true
                    }
            }
        }
    }
}
