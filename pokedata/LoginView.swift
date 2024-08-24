//
//  LoginView.swift
//  pokedata
//
//  Created by Kamal on 2024-08-23.
//

import SwiftUI

struct LoginView: View {
    @Binding var showLoginView: Bool
    @Binding var showRegisterView: Bool
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
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
                        TextField("Username/Email", text: $username)
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
                                if username != "" && password != "" {
                                    withAnimation(.easeInOut) {
                                        showLoginView.toggle()
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
        }
    }
}

#Preview {
    LoginView(showLoginView: .constant(true), showRegisterView: .constant(false))
}
