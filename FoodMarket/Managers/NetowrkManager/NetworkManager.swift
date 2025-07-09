import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private let baseURL = URL(string: "https:/foodshop.click/app.php")!
    
    // MARK: - Регистрация
    func register(name: String, email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let params: [String: Any] = [
            "method": "registration",
            "name": name,
            "email": email,
            "password": password
        ]
        sendRequest(params: params) { result in
            switch result {
            case .success(let json):
                if let userId = json["user_id"] as? String {
                    completion(.success(userId))
                } else if let error = json["error"] as? String {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: error])))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Вход
    func login(email: String, password: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let params: [String: Any] = [
            "method": "login",
            "email": email,
            "password": password
        ]
        sendRequest(params: params) { result in
            switch result {
            case .success(let json):
                if let user = json["user"] as? [String: Any] {
                    completion(.success(user))
                } else if let error = json["error"] as? String {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: error])))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Удаление аккаунта
    func deleteAccount(userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let params: [String: Any] = [
            "method": "delete_account",
            "user_id": userId
        ]
        sendRequest(params: params) { result in
            switch result {
            case .success(let json):
                if let success = json["success"] as? String {
                    completion(.success(success))
                } else if let error = json["error"] as? String {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: error])))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Редактирование профиля (имя и email)
    func editProfile(userId: String, newName: String?, newEmail: String?, completion: @escaping (Result<String, Error>) -> Void) {
        var params: [String: Any] = [
            "method": "edit_profile",
            "user_id": userId
        ]
        if let name = newName {
            params["name"] = name
        }
        if let email = newEmail {
            params["email"] = email
        }
        
        sendRequest(params: params) { result in
            switch result {
            case .success(let json):
                if let success = json["success"] as? String {
                    completion(.success(success))
                } else if let error = json["error"] as? String {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: error])))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func sendRequest(params: [String: Any], completion: @escaping (Result<[String: Any], Error>) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = data
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    DispatchQueue.main.async {
                        completion(.success(json))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"])))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
