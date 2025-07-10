import SwiftUI

struct FoodProfileView: View {
    @StateObject var foodProfileModel =  FoodProfileViewModel()
    @State var isEdit = false
    @State var isSign = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isDeleted = false
    @State private var showDeleteConfirmation = false
    
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
                    Text("Profile")
                        .InterBold(size: 24, color: Color(red: 236/255, green: 72/255, blue: 153/255))
                    
                    Spacer()
                    
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / -40)
            
            ScrollView(showsIndicators: false) {
                VStack {
                    VStack(spacing: 0) {
                        Button(action: {
                            isEdit = true
                        }) {
                            Image(.profile)
                                .resizable()
                                .frame(width: 115, height: 115)
                        }
                        
                        VStack(spacing: 7) {
                            Text("\(UserdefaultsManager().getName() ?? "Guest")")
                                .InterBold(size: 20)
                            
                            Text("\(UserdefaultsManager().getEmail() ?? "Guest email")")
                                .Inter(size: 16)
                        }
                    }
                    
                    if !UserdefaultsManager().isGuest() {
                        Rectangle()
                            .fill(.white)
                            .overlay {
                                VStack(spacing: 20) {
                                    HStack {
                                        Text("Settings")
                                            .InterBold(size: 18)
                                        
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        HStack {
                                            Image(.notif)
                                                .resizable()
                                                .frame(width: 30, height: 32)
                                            
                                            Text("Notifications")
                                                .Inter(size: 16)
                                            
                                            Toggle("", isOn: $foodProfileModel.isNotif)
                                                .toggleStyle(CustomToggleStyle())
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 107)
                            .cornerRadius(16)
                            .padding(.horizontal)
                            .padding(.top)
                            .shadow(radius: 0.5)
                    }
                    
                    if !UserdefaultsManager().isGuest() {
                        VStack(spacing: 15) {
                            Button(action: {
                                UserdefaultsManager().saveLoginStatus(false)
                                UserdefaultsManager().clearAllUserData()
                                isSign = true
                            }) {
                                Rectangle()
                                    .fill(.clear)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color(red: 236/255, green: 72/255, blue: 153/255), lineWidth: 2)
                                        Text("Log Out")
                                            .InterBold(size: 16, color: Color(red: 236/255, green: 72/255, blue: 153/255))
                                    }
                                    .frame(height: 54)
                                    .cornerRadius(16)
                                    .padding(.horizontal)
                            }
                            
                            Button(action: {
                                showDeleteConfirmation = true
                            }) {
                                Rectangle()
                                    .fill(Color(red: 236/255, green: 72/255, blue: 153/255))
                                    .overlay {
                                        Text("Delete account")
                                            .InterBold(size: 16, color: .white)
                                    }
                                    .frame(height: 54)
                                    .cornerRadius(16)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                    } else {
                        VStack(spacing: 15) {
                            Button(action: {
                                UserdefaultsManager().quitQuest()
                                UserdefaultsManager().deleteName()
                                isSign = true
                            }) {
                                Rectangle()
                                    .fill(Color(red: 236/255, green: 72/255, blue: 153/255))
                                    .overlay {
                                        Text("Create account")
                                            .InterBold(size: 16, color: .white)
                                    }
                                    .frame(height: 54)
                                    .cornerRadius(16)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                    }
                }
                .padding(.top, 120)
            }
        }
        .fullScreenCover(isPresented: $isEdit) {
            FoodEditView()
        }
        .fullScreenCover(isPresented: $isSign) {
            FoodSignView()
        }
        .confirmationDialog("Are you sure you want to delete your account?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                deleteAccount()
            }
            Button("Cancel", role: .cancel) { }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func deleteAccount() {
        guard !userId.isEmpty else {
            alertMessage = "User ID is missing"
            showAlert = true
            return
        }
        
        NetworkManager.shared.deleteAccount(userId: userId) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    UserdefaultsManager().clearAllUserData()
                    UserdefaultsManager().saveLoginStatus(false)
                    isSign = true
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    alertMessage = error.localizedDescription
                    showAlert = true
                    isSign = true
                }
            }
        }
    }
}

#Preview {
    FoodProfileView()
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? Color(red: 236/255, green: 72/255, blue: 153/255) : Color(red: 225/255, green: 227/255, blue: 232/255))
                .frame(width: 44, height: 22)
                .overlay(
                    Circle()
                        .fill(configuration.isOn ? .white : Color(red: 156/255, green: 163/255, blue: 175/255))
                        .frame(width: 16, height: 16)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .animation(.easeInOut, value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}
