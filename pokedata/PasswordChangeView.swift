//
//  PasswordChangeView.swift
//  pokedata
//
//  Created by Kamal on 2024-08-27.
//

import SwiftUI

enum PasswordChangeField {
    case email
    case password
    case newPassword
    case confirmNewPassword
}

struct PasswordChangeView: View {
    @AppStorage("user_id") var user_id: Int = 0
    @Binding var userData: UserInfo
    @Binding var message: String
    @Binding var errorCode: String
    @Binding var fault: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var newPassword: String = ""
    @State private var confirmNewPassword: String = ""
    
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var newPasswordError: String? = nil
    @State private var confirmNewPasswordError: String? = nil
    
    @State private var loggedIn: Bool = false
    
    @State private var check: Bool = false
    @State private var existingUserData: Dictionary = [:]
    @State private var usernameError: Bool = false
    @State private var showAlert: Bool = false
    
    @FocusState private var focused: PasswordChangeField?
    
    let onDismiss: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack {
                    Button("Back") {
                        onDismiss()
                    }
                    Spacer()
                }
                .padding([.leading, .top])
            }
            VStack {
                Spacer()
                ZStack {
                    GroupBox {
                        HStack {
                            Text("Password Change")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundStyle(Color.black)
                            Spacer()
                        }
                        TextField("Email", text: $email)
                            .font(.system(size: 20, weight: .medium))
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                            .padding()
                            .multilineTextAlignment(.leading)
                            .background(Color.white)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: 3)
                            )
                            .focused($focused, equals: .email)
                            .onChange(of: email) {
                                emailError = nil
                            }
                        
                        if let error = emailError {
                            Text(error).foregroundStyle(Color.red)
                        }
                        
                        SecureField("Password", text: $password)
                            .font(.system(size: 20, weight: .medium))
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
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
                                .onAppear {
                                    message = ""
                                }
                        }
                        
                        SecureField("New Password", text: $newPassword)
                            .font(.system(size: 20, weight: .medium))
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                            .padding()
                            .multilineTextAlignment(.leading)
                            .background(Color.white)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: 3)
                            )
                            .textContentType(.oneTimeCode)
                            .focused($focused, equals: .newPassword)
                            .onChange(of: newPassword) {
                                newPasswordError = nil
                            }
                        if let error = newPasswordError {
                            Text(error).foregroundStyle(Color.red)
                        }
                        
                        SecureField("Confirm New Password", text: $confirmNewPassword)
                            .font(.system(size: 20, weight: .medium))
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                            .padding()
                            .multilineTextAlignment(.leading)
                            .background(Color.white)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: 3)
                            )
                            .textContentType(.oneTimeCode)
                            .focused($focused, equals: .confirmNewPassword)
                            .onChange (of: confirmNewPassword) {
                                confirmNewPasswordError = nil
                            }
                        if let error = confirmNewPasswordError {
                            Text(error).foregroundStyle(Color.red)
                        }
                        
                        HStack {
                            Button(action: {
                                resetFields()
                            }) {
                                Text("Revert Changes")
                                    .font(.system(size: 15, weight: .bold))
                                    .padding([.top, .bottom])
                                    .foregroundStyle(Color.blue)
                                    .cornerRadius(50)
                            }
                            
                            Spacer()
                            Button(action: {
                                if email.isEmpty {
                                    emailError = "*Missing email"
                                } else if !isValidEmail(email) {
                                    emailError = "*Please enter a valid email"
                                } else if email != userData.email {
                                    emailError = "*Incorrect Email Provided"
                                }
                                if password.isEmpty {
                                    passwordError = "*Missing password"
                                }
                                if !password.isEmpty && email.isEmpty {
                                    passwordError = "Email required before password"
                                }
                                if newPassword.isEmpty {
                                    newPasswordError = "*Missing new password"
                                } else if newPassword == password {
                                    newPasswordError = "*New password must be different"
                                }
                                if confirmNewPassword.isEmpty {
                                    confirmNewPasswordError = "*Missing new password confirmation"
                                } else if confirmNewPassword != newPassword {
                                    confirmNewPasswordError = "*New passwords don't match"
                                }
                                
                                if emailError == nil && !password.isEmpty {
                                    submitPasswordChange { fault in
                                        // backend errror checking
                                        if message == "Password Incorrect" {
                                            passwordError = "*Password Incorrect"
                                        } else {
                                            passwordError = nil
                                        }
                                        if newPasswordError == nil && confirmNewPasswordError == nil {
                                            if !fault {
                                                withAnimation(.easeInOut(duration: 0.5)) {
                                                    onDismiss()
                                                }
                                            }
                                        }
                                    }
                                }
                            }) {
                                Text("Update")
                                    .font(.system(size: 15, weight: .bold))
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundStyle(Color.white)
                                    .cornerRadius(50)
                            }
                        }
                        .padding(.top, 8)
                    }
                    .cornerRadius(10) // Optional: to match the GroupBox's shape
                    .shadow(radius: 10)
                }
                .padding()
                Spacer()
            }
            .onChange(of: fault) {
                showAlert = fault && passwordError != "*Password Incorrect"
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Status Code: \(errorCode)"),
                    message: Text("Something went wrong: \(message)"),
                    dismissButton: .default(Text("OK"), action : {
                        fault = false
                    })
                )
            }
        }
    }
    func submitPasswordChange(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/change") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        var bodyData = ""
        if user_id != 0 {
            bodyData = "user_id=\(user_id)&email=\(email)&password=\(password)&newPassword=\(newPassword)&confirmNewPassword=\(confirmNewPassword)"
        }
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
                            print(message)
                            errorCode = "\(httpResponse.statusCode)"
                            fault = true
                            completion(fault)
                        }
                    } else {
                        // Handle successful response
                        fault = false
                        completion(fault)
                    }
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
                completion(fault)
            }
        }.resume()
    }
    func resetFields() {
        email = ""
        password = ""
        newPassword = ""
        confirmNewPassword = ""
    }
}

#Preview {
    PasswordChangeView(userData: .constant(UserInfo(id: 0, username: "kamal7", email: "kamalxchahal@gmail.com", first_name: "Kamal", last_name: "Chahal", date_of_birth: "2/22/2007", registration_time_EST: "2024-08-26 00:18:51", collection: 0)), message: .constant("OK"), errorCode: .constant("Status Code: 200"), fault: .constant(false), onDismiss: {})
}
