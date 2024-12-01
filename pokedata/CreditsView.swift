//
//  CreditsView.swift
//  pokedata
//
//  Created by Kamal on 2024-08-27.
//

import SwiftUI

struct CreditsView: View {
    @Environment(\.openURL) var openURL
    let onDismiss: () -> Void
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Button(action: {
                    onDismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Profile")
                        Spacer()
                    }
                    .padding([.leading, .top], 20)
                    .padding(.top, 40)
                }
            }
            VStack {
                Spacer()
                ZStack {
                    GroupBox { 
                        HStack {
                            Text("Credits & Acknowledgement")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        Divider()
                        
                        Text("This app would not be possible without the following resources: ")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Button(action: {
                            if let url = URL(string: "https://www.kaggle.com/datasets/mariotormo/complete-pokemon-dataset-updated-090420") {
                                openURL(url)
                            }
                        }) {
                            Text("DataSet")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 2)
                        )
                        
                        Button(action: {
                            if let url = URL(string: "https://docs.pokemontcg.io/") {
                                openURL(url)
                            }
                        }) {
                            Text("Pokemon TCG Api")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 2)
                        )
                        
//   Future Implementation (CameraView)
//                        Button(action: {
//                            if let url = URL(string: "https://roboflow.com/") {
//                                openURL(url)
//                            }
//                        }) {
//                            Text("Roboflow")
//                        }
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .cornerRadius(10)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.black, lineWidth: 2)
//                        )
                        
                        Text("And of course: ")
                            .padding(.top, 4)
                        
                        Button(action: {
                            if let url = URL(string: "https://cs50.harvard.edu/x/2024/") {
                                openURL(url)
                            }
                        }) {
                            Text("Harvard CS50x")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 2)
                        )
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    CreditsView(onDismiss: {})
}
