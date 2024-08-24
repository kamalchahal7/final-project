//
//  RegisterView.swift
//  pokedata
//
//  Created by Kamal on 2024-08-23.
//

import SwiftUI

struct RegisterView: View {
    @Binding var showLoginView: Bool
    @Binding var showRegisterView: Bool
    @Binding var date: Date
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var selectedDate = Date()
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var shown: Bool = false
    
    
    let startDate = Calendar.current.date(byAdding: .year, value: -129, to: Date())!
    let endDate = Date()
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                    ZStack {
                        GroupBox {
                            HStack {
                                Text("Register")
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                    .foregroundStyle(Color.black)
                                
                                Spacer()
                            }
                            HStack {
                                TextField("First Name", text: $firstName)
                                    .font(.system(size: 20, weight: .medium))
                                    .autocapitalization(.none)
                                    .padding()
                                    .multilineTextAlignment(.leading)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black, lineWidth: 2)
                                    )
                                TextField("Last Name", text: $lastName)
                                    .font(.system(size: 20, weight: .medium))
                                    .autocapitalization(.none)
                                    .padding()
                                    .multilineTextAlignment(.leading)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black, lineWidth: 2)
                                    )
                            }
                            .padding(.bottom, 8)
                            
                            GroupBox {
                                HStack {
                                    Text("Date of Birth")
                                        .font(.system(size: 20, weight: .semibold))
                                    Spacer()
                                    Button {
                                        withAnimation(.easeInOut) {
                                            shown.toggle()
                                        }
                                    } label: {
                                        let calendar = Calendar.current
                                        let year = calendar.component(.year, from: selectedDate)
                                        let month = calendar.component(.month, from: selectedDate)
                                        let day = calendar.component(.day, from: selectedDate)
                                        
                                        Text("\(month)/\(day)/\(String(format: "%i", year))")
                                            .font(.system(size: 15, weight: .medium))
                                    }
                                    .disabled(shown)
                                }
                                if shown {
                                    DatePicker("", selection: $selectedDate, in: startDate...endDate, displayedComponents: .date)
                                        .datePickerStyle(WheelDatePickerStyle())
                                        .labelsHidden()
                                        .padding(-20)
                                    Divider()
                                    Button(action: {
                                        // Handle the submission of the selected date
                                        print("Selected date: \(selectedDate)")
                                        withAnimation(.easeInOut) {
                                            shown.toggle()
                                        }
                                    }) {
                                        Text("Confirm")
                                            .font(.system(size: 17.5, weight: .semibold))
                                            .foregroundColor(Color.blue)
                                            .padding(4)
                                            .padding(.bottom, -6)
                                    }
                                }
                            }
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            .padding(.bottom, 8)
                            
                            HStack {
                                TextField("Email", text: $email)
                                    .font(.system(size: 20, weight: .medium))
                                    .autocapitalization(.none)
                                    .padding()
                                    .multilineTextAlignment(.leading)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black, lineWidth: 2)
                                    )
                            }
                            .padding(.bottom, 8)
                            
                            HStack {
                                TextField("Username", text: $username)
                                    .font(.system(size: 20, weight: .medium))
                                    .autocapitalization(.none)
                                    .padding()
                                    .multilineTextAlignment(.leading)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black, lineWidth: 2)
                                    )
                            }
                            .padding(.bottom, 8)
                            
                            SecureField("Password", text: $password)
                                .font(.system(size: 20, weight: .medium))
                                .autocapitalization(.none)
                                .padding()
                                .multilineTextAlignment(.leading)
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                            HStack {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        showRegisterView.toggle()
                                        showLoginView.toggle()
                                    }
                                }) {
                                    Text("Already Have an Account?")
                                        .font(.system(size: 15, weight: .bold))
                                        .padding([.top, .bottom])
                                        .foregroundStyle(Color.blue)
                                        .cornerRadius(50)
                                }
                                Spacer()
                                Button(action: {
                                    if firstName != "" && lastName != "" && selectedDate !=
                                        Date() && email != "" && username != "" && password != "" {
                                        date = Date()
                                        withAnimation(.easeInOut) {
                                            showRegisterView.toggle()
                                        }
                                    }
                                    
                                    //                        withAnimation(.easeInOut(duration: 1.0)) {
                                    //                            isSearchActive.toggle()
                                    //                            isSearchFieldFocused = false
                                }) {
                                    Text("Register")
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
    RegisterView(showLoginView: .constant(false), showRegisterView: .constant(true), date: .constant(Date()))
}
