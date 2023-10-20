//
//  UserLoginView.swift
//  Assignment1
//
//  Created by Leo Cheung on 6/10/2023.
//

import SwiftUI

struct UserLoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loginError: String = ""
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        if isLoggedIn {
            ItemManagementView(loggedIn: $isLoggedIn)
        } else {
            NavigationView {
                VStack {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8.0)
                        .padding(.bottom, 20)
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8.0)
                        .padding(.bottom, 20)
                    Button(action: {
                        print("Login Button Pressed")
                        loginUser()
                    }) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color.blue)
                            .cornerRadius(15.0)
                    }
                    if !loginError.isEmpty {
                        Text(loginError)
                            .foregroundColor(.red)
                            .padding(.bottom, 20)
                    }
                }
                .padding()
                .navigationBarTitle("Login")
            }
        }
    }
    
    func loginUser() {
        let user = User(email: email, password: password)
        guard let url = URL(string: "https://comp4107.azurewebsites.net/user/login") else {
            loginError = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            loginError = "Error encoding user data: \(error.localizedDescription)"
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                loginError = "Error: \(error.localizedDescription)"
                return
            }
            
            guard let data = data else {
                loginError = "No data received"
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(LoginResponse.self, from: data)
                
                if let token = response.token {
                    DispatchQueue.main.async {
                        isLoggedIn = true
                        //print("Token: \(token)  ")
                    }
                } else {
                    loginError = response.message ?? "Login unsuccessful"
                }
            } catch {
                loginError = "Error decoding response data: \(error.localizedDescription)"
            }
        }.resume()
    }
}

struct UserLoginView_Previews: PreviewProvider {
    static var previews: some View {
        UserLoginView()
    }
}

struct User: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let firstName: String?
    let lastName: String?
    let token: String?
    let message: String?
}


