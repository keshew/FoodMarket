import SwiftUI

struct FoodEditView: View {
    @StateObject var foodEditModel = FoodEditViewModel()
    @State var email = ""
    @State var name = ""
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var userId: String = UserdefaultsManager().getID() ?? ""
    
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
                    
                    Text("Edit")
                        .InterBold(size: 20, color: Color(red: 236/255, green: 72/255, blue: 153/255))
                        .padding(.trailing, 10)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 15)
            }
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / -40)
            
            ScrollView(showsIndicators: false) {
                VStack {
                    Rectangle()
                        .fill(.white)
                        .overlay {
                            VStack(spacing: 15) {
                                CustomTextFiled(text: $name, placeholder: "\(UserdefaultsManager().getName() ?? "")")
                                
                                CustomTextFiled(text: $email, placeholder: "\(UserdefaultsManager().getEmail() ?? "")")
                                
                                Button(action: {
                                    saveProfile()
                                }) {
                                    Rectangle()
                                        .fill(Color(red: 236/255, green: 72/255, blue: 153/255))
                                        .overlay {
                                            Text("Save")
                                                .InterBold(size: 16, color: .white)
                                        }
                                        .frame(height: 54)
                                        .cornerRadius(16)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .frame(height: 228)
                        .cornerRadius(16)
                        .padding(.horizontal)
                        .shadow(radius: 0.5)
                }
                .padding(.top, 10)
            }
            .padding(.top, 80)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func saveProfile() {
        guard !name.isEmpty, !email.isEmpty else {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }
        
        NetworkManager.shared.editProfile(userId: userId, newName: name, newEmail: email) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss()
                    UserdefaultsManager().saveName(name)
                    UserdefaultsManager().saveCurrentEmail(email)
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
    FoodEditView()
}

