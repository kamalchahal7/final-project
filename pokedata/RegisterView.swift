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
    @Binding var currentDate: Date
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var birthDate = Date()
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var registered: Bool = false
    @State private var focused: [Bool] = [false, false, false, false, false, false]
    @State private var existingUserData: Dictionary = [:]
    @State private var uniqueCheck: [Bool] = [false, false]
    @State private var shown: Bool = false
    
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
                    .onTapGesture {
                        focused[0] = true
                    }
                TextField("Last Name", text: $lastName)
                    .padding()
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 3)
                    )
                    .onTapGesture {
                        focused[0] = true
                    }
            }
            .multilineTextAlignment(.leading)
            .autocorrectionDisabled(true)
            .font(.system(size: 20, weight: .medium))
            .background(Color.white)
            if registered && !focused[0] && (firstName.isEmpty || lastName.isEmpty) {
                Text("*Please enter your first & last Name")
                    .foregroundStyle(Color.red)
                    .onAppear {
                        print("Condition met")
                    }
            }
            
            GroupBox {
                HStack {
                    Text("Date of Birth")
                        .font(.system(size: 20, weight: .semibold))
                    Spacer()
                    Button {
                        withAnimation(.easeInOut) {
                            focused[1] = true
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
                        print("Selected date: \(birthDate)")
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
            if registered && !focused[1] && dateClipper(birthDate) == dateClipper(Date()) {
                Text("*Please enter your date of birth")
                    .foregroundStyle(Color.red)
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
                .onTapGesture {
                    focused[2] = true
                }
                .onChange(of: email) {
                        // Update the state when username changes
                        if let existingUsernames = existingUserData["email"] as? [String] {
                            if existingUsernames.contains(email) {
                                uniqueCheck[0] = true
                            } else {
                                uniqueCheck[0] = false
                            }
                        }
                    }
            
            if registered && !focused[2] {
                if !isValidEmail(email) {
                    Text("*Please enter a valid email address")
                        .foregroundStyle(Color.red)
                } else if uniqueCheck[0] {
                    Text("*Username already taken")
                        .foregroundColor(.red)
                }
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
                .onTapGesture {
                    focused[3] = true
                }
                .onChange(of: username) {
                        // Update the state when username changes
                        if let existingUsernames = existingUserData["username"] as? [String] {
                            if existingUsernames.contains(username) {
                                uniqueCheck[1] = true
                            } else {
                                uniqueCheck[1] = false
                            }
                        }
                    }

            // Now conditionally display the error message
            if registered && !focused[3] {
                if username.isEmpty {
                    Text("*Please enter a username")
                        .foregroundStyle(Color.red)
                } else if uniqueCheck[1] {
                    Text("*Username already taken")
                        .foregroundColor(.red)
                }
            }
            
            SecureField("Password", text: $password)
                .font(.system(size: 20, weight: .medium))
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
                .padding()
                .multilineTextAlignment(.leading)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 3)
                )
                .padding(.top, 8)
                .textContentType(.oneTimeCode)
                .onTapGesture {
                    focused[4] = true
                }
            if registered && !focused[4] && password.isEmpty {
                Text("*Please enter a password")
                    .foregroundStyle(Color.red)
            }
            
            SecureField("Confirm Password", text: $confirmPassword)
                .font(.system(size: 20, weight: .medium))
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
                .padding()
                .multilineTextAlignment(.leading)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 3)
                )
                .padding(.top, 8)
                .textContentType(.oneTimeCode)
                .onTapGesture {
                    focused[5] = true
                }
            if registered && !focused[5] {
                if confirmPassword.isEmpty {
                    Text("*Please confirm password")
                        .foregroundStyle(Color.red)
                }
                else if confirmPassword != password {
                    Text("*Password confirmation doesn't match")
                        .foregroundStyle(Color.red)
                }
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
                    registered = true
                    for index in focused.indices {
                        focused[index] = false
                    }
                    if !firstName.isEmpty && !lastName.isEmpty && dateClipper(birthDate) != dateClipper(Date()) && !email.isEmpty && !username.isEmpty && !password.isEmpty && password == confirmPassword && !uniqueCheck[0] && !uniqueCheck[1] {
                        currentDate = Date()
                        submitRegistration()
                        withAnimation(.easeInOut) {
                            showRegisterView.toggle()
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
    
    func submitRegistration() {
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
                print("Error \(error)")
                return
            }
            if let data = data {
                print("response \(String(data: data, encoding: .utf8) ?? "No response")")
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
    RegisterView(showLoginView: .constant(false), showRegisterView: .constant(true), currentDate: .constant(Date()))
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

