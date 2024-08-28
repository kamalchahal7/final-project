//
//  PasswordChangeView.swift
//  pokedata
//
//  Created by Kamal on 2024-08-27.
//

import SwiftUI

struct PasswordChangeView: View {
    @State private var account: String = ""
    @State private var password: String = ""
    
    @State private var accountError: String? = nil
    @State private var passwordError: String? = nil
    
    @State private var loggedIn: Bool = false
    
    @State private var check: Bool = false
    @State private var existingUserData: Dictionary = [:]
    @State private var usernameError: Bool = false
    
    @FocusState private var focused: LoginField?
    
    let onDismiss: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Button("Back") {
                        onDismiss()
                    }
                    .padding()
                    Spacer()
                }
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
                        
                        SecureField("New Password", text: $password)
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
                        
                        SecureField("Confirm New Password", text: $password)
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
//                                    showRegisterView.toggle()
//                                    showLoginView.toggle()
                                }
                            }) {
                                Text("Revert Changes")
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
//                                    submitLogin { fault in
//                                        if fault {
//                                            passwordError = "*Password Incorrect"
//                                        } else {
//                                        // backend errror checking
//                                            withAnimation(.easeInOut) {
//                                                showLoginView.toggle()
//                                            }
//                                        }
//                                    }
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
                }
                .background(Color.white) // Ensure the background is set
                .cornerRadius(10) // Optional: to match the GroupBox's shape
                .shadow(radius: 10)
                Spacer()
            }
//            .onAppear {
//                getData()
//            }
        }
    }
}

#Preview {
    PasswordChangeView(onDismiss: {})
}
