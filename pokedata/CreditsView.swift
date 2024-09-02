//
//  CreditsView.swift
//  pokedata
//
//  Created by Kamal on 2024-08-27.
//

import SwiftUI

struct CreditsView: View {
    let onDismiss: () -> Void
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack {
                    Button("Back") {
                        onDismiss()
                    }
                    Spacer()
                }
                .padding([.leading, .top])
            }
            VStack {
                Spacer()
                ZStack {
                    GroupBox { //  to do all the link stuff here go to profile tab view and look at all the legal stuff
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
                            
                        }) {
                            Text("DataSet")
                            // url link
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 2)
                        )
                        
                        Button(action: {
                            
                        }) {
                            Text("Pokemon TCG Api")
                            // url link
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
//                        .background(Color.green)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 2)
                        )
                        
                        Button(action: {
                            
                        }) {
                            Text("RapiApi/Open AI (Image Comparison)")
                            // url link
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
//                        .background(Color.green)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 2)
                        )
                        
                        Text("And of course: ")
                            .padding(.top, 4)
                        
                        Button(action: {
                            
                        }) {
                            Text("Harvard CS50x")
                            // url link
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
//                        .background(Color.green)
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
