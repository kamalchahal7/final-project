//
//  ProfileTabView.swift
//  pokedata
//
//  Created by Kamal on 2024-08-24.
//

import SwiftUI

struct ProfileTabView: View {
    @State private var username: String = ""
    @Binding var date: Date
    @Binding var showLoginView: Bool
    
    let collectionCount: Int
    var shortMonthName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date)
    }
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
                Text(username)
                    .font(.title)
                    .fontWeight(.bold)
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month], from: date)
                let year = components.year
                Text("Joined \(shortMonthName) \(String(format: "%i", year!))")
                    .padding(.bottom, 8)
                
                                    
//                    Text("Total Views: ")
                Text("Cards Collected: \(collectionCount)")
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
                        Text("Personal Details")
                        Text("View History")
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    Section(header: Text("Legal")) {
                        Text("Terms and Conditions")
                        Text("Credits and Acknowledgement")
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    Section {
                        Button(action: {
                            withAnimation(.easeInOut) {
                                showLoginView.toggle()
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
    ProfileTabView(date: .constant(Date()), showLoginView: .constant(false), collectionCount: 0)
}
