//
//  LoginView.swift
//  pokedata
//
//  Created by Kamal on 2024-08-23.
//

import SwiftUI

enum LoginField {
    case account
    case password
}

struct LoginView: View {
    @AppStorage("user_id") var user_id: Int?
    
    @Binding var showLoginView: Bool
    @Binding var showRegisterView: Bool
    // backend error message
    @Binding var message: String
    // backend error code
    @Binding var errorCode: String
    // checks if backend pciked up a fault
    @Binding var fault: Bool
    
    @State private var account: String = ""
    @State private var password: String = ""
    
    @State private var accountError: String? = nil
    @State private var passwordError: String? = nil
    
    @State private var loggedIn: Bool = false
    
    @State private var check: Bool = false
    @State private var existingUserData: Dictionary = [:]
    @State private var usernameError: Bool = false
    
    @FocusState private var focused: LoginField?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack {
                    GroupBox {
                        HStack {
                            Text("Login")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundStyle(Color.black)
                            Spacer()
                        }
                        TextField("Username/Email", text: $account)
                            .font(.system(size: 20, weight: .medium))
                            .autocapitalization(.none)
                            .padding()
                            .multilineTextAlignment(.leading)
                            .background(Color.white)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: 3)
                            )
                            .focused($focused, equals: .account)
                            .onChange(of: account) {
                                accountError = nil
                            }
                        
                        if let error = accountError {
                            Text(error).foregroundStyle(Color.red)
                        }
                        
                        SecureField("Password", text: $password)
                            .font(.system(size: 20, weight: .medium))
                            .autocapitalization(.none)
                            .padding()
                            .multilineTextAlignment(.leading)
                            .background(Color.white)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: 3)
                            )
                            .textContentType(.oneTimeCode)
                            .focused($focused, equals: .password)
                            .onChange (of: password) {
                                passwordError = nil
                            }
                        if let error = passwordError {
                            Text(error).foregroundStyle(Color.red)
                        }
                        
                        
                        
                        HStack {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showRegisterView.toggle()
                                    showLoginView.toggle()
                                }
                            }) {
                                Text("Don't Have an Account?")
                                    .font(.system(size: 15, weight: .bold))
                                    .padding([.top, .bottom])
                                    .foregroundStyle(Color.blue)
                                    .cornerRadius(50)
                            }
                            
                            Spacer()
                            Button(action: {
                                if account.isEmpty {
                                    accountError = "*Missing username"
                                } else if let existingUsernames = existingUserData["username"] as? [String], let existingEmails = existingUserData["email"] as? [String] {
                                    if !(existingUsernames.contains(account) || existingEmails.contains(account)) {
                                        accountError = "*Username/email not registered"
                                    }
                                }
                                if password.isEmpty {
                                    passwordError = "*Missing password"
                                }
                                
                                if accountError == nil && passwordError == nil {
                                    submitLogin { fault in
                                        if fault {
                                            passwordError = "*Password Incorrect"
                                        } else {
                                        // backend errror checking
                                            withAnimation(.easeInOut) {
                                                showLoginView.toggle()
                                            }
                                        }
                                    }
                                }
                                
                                //                        withAnimation(.easeInOut(duration: 1.0)) {
                                //                            isSearchActive.toggle()
                                //                            isSearchFieldFocused = false
                            }) {
                                Text("Log In")
                                    .font(.system(size: 15, weight: .bold))
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundStyle(Color.white)
                                    .cornerRadius(50)
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                .background(Color.white) // Ensure the background is set
                .cornerRadius(10) // Optional: to match the GroupBox's shape
                .shadow(radius: 10)
                Spacer()
            }
            .onAppear {
                getData()
            }
        }
    }
    
    func submitLogin(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/login") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let bodyData = "account=\(account)&password=\(password)"
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            }
            if let data = data {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode >= 400 {
                        DispatchQueue.main.async {
                            message = String(data: data, encoding: .utf8) ?? "No response"
                            errorCode = "\(httpResponse.statusCode)"
                            fault = true
                            completion(fault)
                        }
                    } else {
                        // Handle successful response
                        if let userID = try? JSONDecoder().decode(Int.self, from: data) {
                            fault = false
                            user_id = userID
                        }
                        completion(fault)
                    }
                }
                
            } else if let error = error {
                print("HTTP Request Failed \(error)")
                completion(fault)
            }
        }.resume()
    }
    
    func getData() {
        guard let url = URL(string: "http://127.0.0.1:5000/login") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            existingUserData = json
                            print(existingUserData)
                        }
                    }
                } catch {
                    print("Error \(error)")
                    DispatchQueue.main.async {
                        existingUserData = [:]
                    }
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }.resume()
    }
}

#Preview {
    LoginView(showLoginView: .constant(true), showRegisterView: .constant(false), message: .constant("OK"), errorCode: .constant("Status Code: 200"), fault: .constant(false))
}
