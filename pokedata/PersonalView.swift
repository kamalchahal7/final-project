//
//  PersonalView.swift
//  pokedata
//
//  Created by Kamal on 2024-08-27.
//

import SwiftUI

enum PersonalField {
    case password
    case firstName
    case lastName
    case birthDate
    case email
    case username
}

struct PersonalView: View {
    @AppStorage("user_id") var user_id: Int = 0
    
    
    @Binding var userData: UserInfo
    @Binding var message: String
    @Binding var errorCode: String
    @Binding var fault: Bool
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var birthDate = Date()
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var nameError: String? = nil
    @State private var birthDateError: String? = nil
    @State private var emailError: String? = nil
    @State private var usernameError: String? = nil
    @State private var passwordError: String? = nil
    
    @State private var existingUserData: Dictionary = [:]
    @State private var shown: Bool = false
    @State private var date: String = ""
    
    @State private var personal: Bool = false
    @State private var confirmation: Bool = true
    
    @State private var showAlert: Bool = false
    @State private var changed: Bool = false
    @State private var same: Bool = false
    
    init(userData: Binding<UserInfo>, message: Binding<String>, errorCode: Binding<String>, fault: Binding<Bool>, onDismiss: @escaping () -> Void) {
        self._userData = userData
        self._message = message
        self._errorCode = errorCode
        self._fault = fault
        self._date = State(initialValue: userData.wrappedValue.date_of_birth)
        self.onDismiss = onDismiss
    }
    
    @FocusState private var focused: PersonalField?
    let startDate = Calendar.current.date(byAdding: .year, value: -129, to: Date())!
    let endDate = Date()
    let onDismiss: () -> Void
    var body: some View {
        GeometryReader { geometry in
            let isNotchDevice = geometry.safeAreaInsets.top == 24
            
            ZStack {
                HStack {
                    if confirmation {
                        Button(action: {
                            onDismiss()
                        }) {
                            HStack {
                                Image(systemName: "chevron.backward")
                                Text("Profile")
                                Spacer()
                            }
                            .padding([.leading, .top])
                        }
                    }
                }
            }
            VStack {
                HStack {
                    if !confirmation {
                        Button(action: {
                            withAnimation(.easeInOut) {
                                confirmation.toggle()
                            }
                        }) {
                            HStack {
                                Image(systemName: "chevron.backward")
                                Text("Back")
                                Spacer()
                            }
                            .padding([.leading, .top])
                        }
                    }
                }
                Spacer()
                ZStack {
                    if confirmation {
                        GroupBox {
                            confirmationView
                        }
                        .cornerRadius(10)
                        .shadow(radius: 10)
                    }
                    else {
                        GroupBox {
                            formContent
                        }
                        .cornerRadius(10)
                        .shadow(radius: 10)
                    }
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
            .if(!isNotchDevice) { view in
                Group {
                    if !confirmation {
                        ScrollView { view }
                    }
                    else {
                        view
                    }
                }
            }
        }
        .onAppear {
            fetchInfo()
        }
    }
    
    @ViewBuilder
    var confirmationView: some View {
        VStack {
            HStack {
                Text("Confirm Password")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            SecureField("Password", text: $password)
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
                .padding(.top, 8)
                .padding(.bottom, 8)
                .textContentType(.oneTimeCode)
                .focused($focused, equals: .password)
                .onChange(of: password) {
                    passwordError = nil
                }
            
            if let error = passwordError {
                Text(error).foregroundStyle(Color.red)
            }

            Button(action: {
                if password.isEmpty {
                    passwordError = "*Please enter your password"
                }
                focused = nil
                // front end checking
                if passwordError == nil {
                    submitConfirmation { fault in
                    // backend errror checking
                        //print(fault)
                        if fault {
                            passwordError = "*Password Incorrect"
                        } else {
                            withAnimation(.easeInOut) {
                                confirmation.toggle()
                            }
                        }
                    }
                }
            }) {
                HStack {
                    Spacer()
                    Text("Confirm")
                        .font(.system(size: 15, weight: .bold))
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(Color.white)
                        .cornerRadius(50)
                }
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
            
            
            // displays name error message
            if let error = nameError {
                if same {
                    Text(error).foregroundStyle(Color.blue)
                } else {
                    Text(error).foregroundStyle(Color.red)
                }
            }
            
            HStack {
                Text("Date of Birth")
                    .font(.title3)
                    .fontWeight(.heavy)
                // maybe make fully capitlized
                Spacer()
            }
            .padding(.top, 1)
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
                        changed = true
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
            
            // displays birthdate error message
            if let error = birthDateError {
                if same {
                    Text(error).foregroundStyle(Color.blue)
                } else {
                    Text(error).foregroundStyle(Color.red)
                }
            }
            
            HStack {
                Text("Email")
                    .font(.title3)
                    .fontWeight(.heavy)
                Spacer()
            }
            .padding(.top, 1)
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
                .focused($focused, equals: .email)
                .onChange(of: email) {
                    emailError = nil
                }
            
            // displays email error message
            if let error = emailError {
                if same {
                    Text(error).foregroundStyle(Color.blue)
                } else {
                    Text(error).foregroundStyle(Color.red)
                }
            }
            
            HStack {
                Text("Username")
                    .font(.title3)
                    .fontWeight(.heavy)
                Spacer()
            }
            .padding(.top, 1)
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
                if same {
                    Text(error).foregroundStyle(Color.blue)
                } else {
                    Text(error).foregroundStyle(Color.red)
                }
            }
            
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
                    same = false
                   // print(userData.date_of_birth)
                    if firstName == userData.first_name && lastName == userData.last_name {
                        nameError = "*First & last name are unchanged"
                        same = true
                    } else if firstName == userData.first_name {
                        nameError = "*First name is unchanged"
                        same = true
                    } else if lastName == userData.last_name {
                        nameError = "*Last name is unchanged"
                        same = true
                    }
                    if dateClipper(birthDate) == userData.date_of_birth {
                        birthDateError = "*Date of birth is unchanged"
                        same = true
                    } else if dateClipper(birthDate) == dateClipper(Date()) && changed {
                        birthDateError = "*Must be older than 1 day"
                    }
                    if email == userData.email {
                        emailError = "*Email is unchanged"
                        same = true
                    } else if !isValidEmail(email) && !email.isEmpty {
                        emailError = "*Please enter a valid email"
                    } else if let existingUsernames = existingUserData["email"] as? [String] {
                        if existingUsernames.contains(email) {
                            emailError = "*Email already registered"
                        }
                    }
                    if username == userData.username {
                        usernameError = "*Username is unchanged"
                        same = true
                    } else if let existingUsernames = existingUserData["username"] as? [String] {
                        if existingUsernames.contains(username) {
                            usernameError = "*Username already taken"
                        }
                    }

//                    focused = nil
                    
                    // frontend error checking
                    if nameError == nil && birthDateError == nil && emailError == nil && usernameError == nil && !same {
                       // print("Global: \(user_id)")
                       // print("Local: \(userData.id)")
                        // submits registration data to backend
                        submitChange { fault in
                            // backend errror checking
                            if !fault {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    onDismiss()
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
    }
    func submitConfirmation(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/personal") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        var bodyData = ""
        if user_id != 0 {
            bodyData = "user_id=\(user_id)&password=\(password)"
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
    
    func submitChange(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/personal") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        var bodyData = ""
        if user_id != 0 {
            bodyData = "user_id=\(user_id)&firstName=\(firstName)&lastName=\(lastName)&birthDate=\(birthDate)&email=\(email)&username=\(username)"
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
    
    func fetchInfo() {
        guard let url = URL(string: "http://127.0.0.1:5000/personal") else {
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
                            //print(existingUserData)
                        }
                    }
                } catch {
                    print("Error \(error)")
                    DispatchQueue.main.async {
                        existingUserData = [:]
                    }
                }
                //print("response \(String(data: data, encoding: .utf8) ?? "No response")")
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }.resume()
    }
    
    func resetFields() {
        firstName = ""
        lastName = ""
        date = userData.date_of_birth
        birthDate = Date()
        email = ""
        username = ""
    }
    
}

#Preview {
    PersonalView(userData: .constant(UserInfo(id: 0, username: "kamal7", email: "kamalxchahal@gmail.com", first_name: "Kamal", last_name: "Chahal", date_of_birth: "2/22/2007", registration_time_EST: "2024-08-26 00:18:51", collection: 0)), message: .constant("OK"), errorCode: .constant("Status Code: 200"), fault: .constant(false), onDismiss: {})
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

