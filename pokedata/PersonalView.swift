//
//  PersonalView.swift
//  pokedata
//
//  Created by Kamal on 2024-08-27.
//

import SwiftUI

struct PersonalView: View {
    @Binding var showLoginView: Bool
    @Binding var showRegisterView: Bool
    @Binding var userData: UserInfo
    @Binding var message: String
    @Binding var errorCode: String
    @Binding var fault: Bool
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var birthDate = Date()
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var nameError: String? = nil
    @State private var birthDateError: String? = nil
    @State private var emailError: String? = nil
    @State private var usernameError: String? = nil
    @State private var existingUserData: Dictionary = [:]
    @State private var shown: Bool = false
    @State private var date: String = ""
    init(showLoginView: Binding<Bool>, showRegisterView: Binding<Bool>, userData: Binding<UserInfo>, message: Binding<String>, errorCode: Binding<String>, fault: Binding<Bool>, onDismiss: @escaping () -> Void) {
        self._showLoginView = showLoginView
        self._showRegisterView = showRegisterView
        self._userData = userData
        self._message = message
        self._errorCode = errorCode
        self._fault = fault
        self._date = State(initialValue: userData.wrappedValue.date_of_birth)
        self.onDismiss = onDismiss
    }
    
    @FocusState private var focused: RegisterField?
    let startDate = Calendar.current.date(byAdding: .year, value: -129, to: Date())!
    let endDate = Date()
    let onDismiss: () -> Void
    var body: some View {
        GeometryReader { geometry in
            let isNotchDevice = geometry.safeAreaInsets.top == 24
            
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
                        formContent
                    }
                    .cornerRadius(10)
                    .shadow(radius: 10)
                }
                .padding()
                Spacer()
            }
            .alert(isPresented: $fault) {
                Alert(
                    title: Text("Status Code: \(errorCode)"),
                    message: Text("Something went wrong: \(message)"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .if(!isNotchDevice) { view in
                ScrollView { view }
            }
        }
    }
    
    @ViewBuilder
    private var formContent: some View {
        VStack {
            HStack {
                Text("Personal Details")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                Spacer()
            }
            .padding(.bottom)
//            Divider()
            HStack {
                Text("Name")
                    .font(.title3)
                    .fontWeight(.heavy)
                Spacer()
            }
            
            HStack {
                TextField(userData.first_name, text: $firstName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 3)
                    )
                    .focused($focused, equals: .firstName)
                    .onChange(of: firstName) {
                        nameError = nil
                    }
                TextField(userData.last_name, text: $lastName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 3)
                    )
                    .focused($focused, equals: .lastName)
                    .onChange(of: lastName) {
                        nameError = nil
                    }
            }
            .multilineTextAlignment(.leading)
            .autocorrectionDisabled(true)
            .font(.system(size: 20, weight: .medium))
            .padding(.top, -8)
            .padding(.bottom, 8)
            
            // displays name error message
            if let error = nameError {
                Text(error).foregroundStyle(Color.red)
            }
            
            HStack {
                Text("Date of Birth")
                    .font(.title3)
                    .fontWeight(.heavy)
                // maybe make fully capitlized
                Spacer()
            }
            GroupBox {
                HStack {
                    Text(dateShift(date))
                        .font(.system(size: 20, weight: .semibold))
                    Spacer()
                    Button {
                        withAnimation(.easeInOut) {
                            birthDateError = nil
                            focused = .birthDate
                            shown.toggle()
                        }
                    } label: {
                        
                        
                        
                        // old format
                        
                        Text(date)
                            .font(.system(size: 15, weight: .medium))
                        
                        
                    
                    }
                    .disabled(shown)
                }
                if shown {
                    DatePicker("", selection: $birthDate, in: startDate...endDate, displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .padding(-20)
                    Divider()
                    Button(action: {
                        let calendar = Calendar.current
                        let year = calendar.component(.year, from: birthDate)
                        let month = calendar.component(.month, from: birthDate)
                        let day = calendar.component(.day, from: birthDate)
                        date = "\(month)/\(day)/\(String(format: "%i", year))"
                        // Handle the submission of the selected date
//                        print("Selected date: \(birthDate)")
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
                    .stroke(Color.black, lineWidth: 3)
            )
            .padding(.top, -8)
            .padding(.bottom, 8)
            
            // displays birthdate error message
            if let error = birthDateError {
                Text(error).foregroundStyle(Color.red)
            }
            
            HStack {
                Text("Email")
                    .font(.title3)
                    .fontWeight(.heavy)
                Spacer()
            }
            TextField(userData.email, text: $email)
                .font(.system(size: 20, weight: .medium))
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
                .padding()
                .multilineTextAlignment(.leading)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 3)
                )
                .padding(.top, -8)
                .padding(.bottom, 8)
                .focused($focused, equals: .email)
                .onChange(of: email) {
                    emailError = nil
                }
            
            // displays email error message
            if let error = emailError {
                Text(error).foregroundStyle(Color.red)
            }
            
            HStack {
                Text("Username")
                    .font(.title3)
                    .fontWeight(.heavy)
                Spacer()
            }
            TextField(userData.username, text: $username)
                .font(.system(size: 20, weight: .medium))
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
                .padding()
                .multilineTextAlignment(.leading)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 3)
                )
                .padding(.top, -8)
                .focused($focused, equals: .username)
                .onChange(of: username) {
                    usernameError = nil
                }

            // displays username error message
            if let error = usernameError {
                Text(error).foregroundStyle(Color.red)
            }
            
            
//            SecureField("Password", text: $password)
//                .font(.system(size: 20, weight: .medium))
//                .autocapitalization(.none)
//                .autocorrectionDisabled(true)
//                .padding()
//                .multilineTextAlignment(.leading)
//                .background(Color.white)
//                .cornerRadius(10)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.black, lineWidth: 3)
//                )
//                .padding(.top, 8)
//                .textContentType(.oneTimeCode)
//                .focused($focused, equals: .password)
//                .onChange(of: password) {
//                    passwordError = nil
//                }
//            
//            // displays password error message
//            if let error = passwordError {
//                Text(error).foregroundStyle(Color.red)
//            }
            
//            SecureField("Confirm Password", text: $confirmPassword)
//                .font(.system(size: 20, weight: .medium))
//                .autocapitalization(.none)
//                .autocorrectionDisabled(true)
//                .padding()
//                .multilineTextAlignment(.leading)
//                .background(Color.white)
//                .cornerRadius(10)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.black, lineWidth: 3)
//                )
//                .padding(.top, 8)
//                .textContentType(.oneTimeCode)
//                .focused($focused, equals: .confirmPassword)
//                .onChange(of: confirmPassword) {
//                    confirmPasswordError = nil
//                }
//            
//            // displays confirmation password error message
//            if let error = confirmPasswordError {
//                Text(error).foregroundStyle(Color.red)
//            }
            
            HStack {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showRegisterView.toggle()
                        showLoginView.toggle()
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
                    if firstName.isEmpty || lastName.isEmpty {
                        nameError = "*Please enter your first & last Name"
                    }
                    if dateClipper(birthDate) == dateClipper(Date()) {
                        birthDateError = "*Please enter your date of birth"
                    }
                    if !isValidEmail(email) {
                        emailError = "*Please enter your date of birth"
                    } else if let existingUsernames = existingUserData["email"] as? [String] {
                        if existingUsernames.contains(email) {
                            emailError = "Email already registered"
                        }
                    }
                    if username.isEmpty {
                        usernameError = "*Please enter a username"
                    } else if let existingUsernames = existingUserData["username"] as? [String] {
                        if existingUsernames.contains(username) {
                            usernameError = "*Username already taken"
                        }
                    }
//                    if password.isEmpty {
//                        passwordError = "*Please enter a password"
//                    }
//                    if confirmPassword.isEmpty {
//                        confirmPasswordError = "*Please confirm password"
//                    } else if confirmPassword != password {
//                        confirmPasswordError = "Password confirmation doesn't match"
//                    }
//                    
//                    focused = nil
//                    
//                    // frontend error checking
//                    if nameError == nil && birthDateError == nil && emailError == nil && usernameError == nil && passwordError == nil {
//                        // submits registration data to backend
//                        submitRegistration { fault in
//                            // backend errror checking
//                            if !fault {
//                                withAnimation(.easeInOut) {
//                                    showRegisterView.toggle()
//                                }
//                            }
//                        }
//                    }

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
//        .onAppear {
//            getUserData()
//        }
    }
}

#Preview {
    PersonalView(showLoginView: .constant(false), showRegisterView: .constant(true), userData: .constant(UserInfo(id: 0, username: "kamal7", email: "kamalxchahal@gmail.com", first_name: "Kamal", last_name: "Chahal", date_of_birth: "2/22/2007", registration_time_EST: "2024-08-26 00:18:51", collection: 0)), message: .constant("OK"), errorCode: .constant("Status Code: 200"), fault: .constant(false), onDismiss: {})
}

func dateShift(_ dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "M/dd/yyyy"
    
    if let date = dateFormatter.date(from: dateString) {
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMMM dd, yyyy"
        return displayFormatter.string(from: date)
    } else {
        return "Invalid date format"
    }
}

