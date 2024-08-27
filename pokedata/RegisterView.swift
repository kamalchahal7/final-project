//
//  RegisterView.swift
//  pokedata
//
//  Created by Kamal on 2024-08-23.
//

import SwiftUI

enum RegisterField {
    case firstName
    case lastName
    case birthDate
    case email
    case username
    case password
    case confirmPassword
}
struct RegisterView: View {
    @Binding var showLoginView: Bool
    @Binding var showRegisterView: Bool
    // backend error message
    @Binding var message: String
    // backend error code
    @Binding var errorCode: String
    // checks if backend pciked up a fault
    @Binding var fault: Bool
    
    // text field values
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var birthDate = Date()
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    // text field errors
    @State private var nameError: String? = nil
    @State private var birthDateError: String? = nil
    @State private var emailError: String? = nil
    @State private var usernameError: String? = nil
    @State private var passwordError: String? = nil
    @State private var confirmPasswordError: String? = nil
    
    @State private var existingUserData: Dictionary = [:]
    @State private var shown: Bool = false
    
    @FocusState private var focused: RegisterField?

    
    let startDate = Calendar.current.date(byAdding: .year, value: -129, to: Date())!
    let endDate = Date()
    
    var body: some View {
        GeometryReader { geometry in
            let isNotchDevice = geometry.safeAreaInsets.top == 24
            
            VStack {
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
                Text("Register")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                Spacer()
            }
            HStack {
                TextField("First Name", text: $firstName)
                    .padding()
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 3)
                    )
                    .focused($focused, equals: .firstName)
                    .onChange(of: firstName) {
                        nameError = nil
                    }
                TextField("Last Name", text: $lastName)
                    .padding()
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
            .background(Color.white)
            
            // displays name error message
            if let error = nameError {
                Text(error).foregroundStyle(Color.red)
            }
            
            GroupBox {
                HStack {
                    Text("Date of Birth")
                        .font(.system(size: 20, weight: .semibold))
                    Spacer()
                    Button {
                        withAnimation(.easeInOut) {
                            birthDateError = nil
                            focused = .birthDate
                            shown.toggle()
                        }
                    } label: {
                        let calendar = Calendar.current
                        let year = calendar.component(.year, from: birthDate)
                        let month = calendar.component(.month, from: birthDate)
                        let day = calendar.component(.day, from: birthDate)
                        
                        Text("\(month)/\(day)/\(String(format: "%i", year))")
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
            .padding(.top, 8)
            
            // displays birthdate error message
            if let error = birthDateError {
                Text(error).foregroundStyle(Color.red)
            }
            
            
            TextField("Email", text: $email)
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
                .focused($focused, equals: .email)
                .onChange(of: email) {
                    emailError = nil
                }
            
            // displays email error message
            if let error = emailError {
                Text(error).foregroundStyle(Color.red)
            }
            
            TextField("Username", text: $username)
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
                .focused($focused, equals: .username)
                .onChange(of: username) {
                    usernameError = nil
                }

            // displays username error message
            if let error = usernameError {
                Text(error).foregroundStyle(Color.red)
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
                .textContentType(.oneTimeCode)
                .focused($focused, equals: .password)
                .onChange(of: password) {
                    passwordError = nil
                }
            
            // displays password error message
            if let error = passwordError {
                Text(error).foregroundStyle(Color.red)
            }
            
            SecureField("Confirm Password", text: $confirmPassword)
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
                .textContentType(.oneTimeCode)
                .focused($focused, equals: .confirmPassword)
                .onChange(of: confirmPassword) {
                    confirmPasswordError = nil
                }
            
            // displays confirmation password error message
            if let error = confirmPasswordError {
                Text(error).foregroundStyle(Color.red)
            }
            
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
                    if password.isEmpty {
                        passwordError = "*Please enter a password"
                    }
                    if confirmPassword.isEmpty {
                        confirmPasswordError = "*Please confirm password"
                    } else if confirmPassword != password {
                        confirmPasswordError = "Password confirmation doesn't match"
                    }
                    
                    focused = nil
                    
                    // frontend error checking
                    if nameError == nil && birthDateError == nil && emailError == nil && usernameError == nil && passwordError == nil {
                        // submits registration data to backend
                        submitRegistration { fault in
                            // backend errror checking
                            if !fault {
                                withAnimation(.easeInOut) {
                                    showRegisterView.toggle()
                                }
                            }
                        }
                    }

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
        .onAppear {
            fetchUserData()
        }
    }
    
    func submitRegistration(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/register") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let bodyData = "firstName=\(firstName)&lastName=\(lastName)&birthDate=\(birthDate)&email=\(email)&username=\(username)&password=\(password)&confirmPassword=\(confirmPassword)"
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
                        completion(fault)
                    }
                }
                
            } else if let error = error {
                print("HTTP Request Failed \(error)")
                completion(fault)
            }
        }.resume()
    }
    
    func fetchUserData() {
        guard let url = URL(string: "http://127.0.0.1:5000/register") else {
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
                print("response \(String(data: data, encoding: .utf8) ?? "No response")")
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }.resume()
    }
}

func dateClipper(_ date: Date) -> Date? {
    let calendar = Calendar.current
    var components = calendar.dateComponents([.year, .month, .day], from: date)
    components.hour = 0
    components.minute = 0
    components.second = 0
    return calendar.date(from: components)
}

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

#Preview {
    RegisterView(showLoginView: .constant(false), showRegisterView: .constant(true), message: .constant("OK"), errorCode: .constant("Status Code: 200"), fault: .constant(false))
}

// CODE TO MAKE AN ERROR VIEW PAGE


//@State private var showErrorView = false

//func handleResponse(response: URLResponse?) {
//    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 404 {
//        showErrorView = true
//    }
//}

//var body: some View {
//    VStack {
//        if showErrorView {
//            ErrorView() // Your custom error view
//        } else {
//            MainView() // Your main content view
//        }
//    }
//}

// MORE ERRORS

//func handleResponse(response: URLResponse?) {
//    if let httpResponse = response as? HTTPURLResponse, (400...599).contains(httpResponse.statusCode) {
//        showErrorView = true
//    }

