//
//  ProfileTabView.swift
//  pokedata
//
//  Created by Kamal on 2024-08-24.
//

import SwiftUI

struct ProfileTabView: View {
    @AppStorage("user_id") var user_id: Int = 0
    @Environment(\.openURL) var openURL
    @State private var username: String = ""
//    @Binding var date: Date
    @Binding var showLoginView: Bool
    @Binding var showPersonalView: Bool
    @Binding var showPasswordChangeView: Bool
    @Binding var showHistoryView: Bool
    @Binding var showCreditsView: Bool
    @Binding var userData: UserInfo
    
    let collectionCount: Int
//    var shortMonthName: String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM"
//        return dateFormatter.string(from: date)
//    }
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                HStack{
                    Spacer()
                    Image("pikachu")
                        .resizable()
                        .scaledToFit()
                        .frame(height: geometry.size.height * 0.2)
                        .clipShape(RoundedRectangle(cornerRadius: 1000))
                            .overlay(RoundedRectangle(cornerRadius: 1000).stroke(Color.black, lineWidth: 3))
                    Spacer()
                }
                Text(userData.username)
                    .font(.title)
                    .fontWeight(.bold)
//                let calendar = Calendar.current
//                let components = calendar.dateComponents([.year, .month], from: date)
//                let year = components.year
//                Text("Joined \(shortMonthName) \(String(format: "%i", year!))")
//                    .padding(.bottom, 8)
                
                                    
//                    Text("Total Views: ")
                Text("Cards Collected: \(userData.collection)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(12)
                    .background(Color(red: 255 / 255, green: 215 / 255, blue: 0 / 255))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                Divider()
                    .padding(.top, 10)
                
                List {
                    Section(header: Text("Account")) {
                        Button(action: {
                            withAnimation(.easeInOut) {
                                showPersonalView.toggle()
                            }
                        }) {
                            Text("Personal Details")
                        }
                        Button(action: {
                            withAnimation(.easeInOut) {
                                showPasswordChangeView.toggle()
                            }
                        }) {
                            Text("Change Password")
                        }
                        Button(action: {
                            withAnimation(.easeInOut) {
                                showHistoryView.toggle()
                            }
                        }) {
                            Text("View History")
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    Section(header: Text("Legal")) {
                        Button(action: {
                            if let url = URL(string: "http://127.0.0.1:5500/legal/terms_and_conditions.html") {
                                openURL(url)
                            }
                        }) {
                            Text("Terms and Conditions")
                        }
                        Button(action: {
                            if let url = URL(string: "http://127.0.0.1:5500/legal/privacy_policy.html") {
                                openURL(url)
                            }
                        }) {
                            Text("Privacy Policy")
                        }
                        Button(action: {
                            if let url = URL(string: "http://127.0.0.1:5500/legal/eula_agreement.html") {
                                openURL(url)
                            }
                        }) {
                            Text("EULA Agreement")
                        }
                        Button(action: {
                            if let url = URL(string: "http://127.0.0.1:5500/legal/disclaimer.html") {
                                openURL(url)
                            }
                        }) {
                            Text("Disclaimer")
                        }
                        Button(action: {
                            withAnimation(.easeInOut) {
                                showCreditsView.toggle()
                            }
                        }) {
                            Text("Credits and Acknowledgement")
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    Section {
                        Button(action: {
                            if user_id != 0 {
                                print("USER ID: \(user_id)")
                            }
                            user_id = 0
                            if user_id == 0 {
                                print("USER ID AFTER: \(user_id)")
                            }
                            withAnimation(.easeInOut) {
                                showLoginView = true
                            }
                        }) {
                            Text("Sign Out")
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                }
                .scrollContentBackground(.hidden)
                .foregroundStyle(Color.black)
                .padding(-16)
                .padding(.top, 16)
                Spacer()
            }
        }
    }
}

#Preview {
    ProfileTabView(showLoginView: .constant(false), showPersonalView: .constant(false), showPasswordChangeView: .constant(false), showHistoryView: .constant(false), showCreditsView: .constant(false), userData: .constant(UserInfo(id: 0, username: "kamal7", email: "kamalxchahal@gmail.com", first_name: "Kamal", last_name: "Chahal", date_of_birth: "2007-02-22", registration_time_EST: "2024-08-26 00:18:51", collection: 0)), collectionCount: 0)
}
