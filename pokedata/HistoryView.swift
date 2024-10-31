//
//  HistoryView.swift
//  pokedata
//
//  Created by Kamal on 2024-08-27.
//

import SwiftUI

struct HistoryView: View {
    @AppStorage("user_id") var user_id: Int = 0
    let onDismiss: () -> Void
    @State private var enabled: Bool = true
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                HStack {
                    Button("Back") {
                        onDismiss()
                    }
                    
                    Spacer()
                    Button (action: {
                        withAnimation {
                            enabled.toggle()
                        }
                    }) {
                        Text(enabled ? "Disable" : "Enable")
                    }
                    .padding(10)
                    .background(Color.indigo)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)

                }
                .padding([.leading, .top, .trailing])
                VStack {
                    ZStack {
                        GroupBox {
                            HStack {
                                Text("View History")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                Spacer()
                                Button (action: {
                                    withAnimation {
                                        enabled.toggle()
                                    }
                                }) {
                                    Text("Clear All")
                                }
                                .padding(10)
                                .background(Color.red)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                            }
//                            Divider()
//                            List {
//                                
//                            }
                        }
                    }
                    
                }
                .padding([.leading, .trailing, .bottom])
            }
        }
        .onAppear {
            if enabled {
//                fetchHistory()
            }
        }
    }
//    func fetchHistory() {
//        if user_id == 0 {
//            print("No user ID provided")
//            return
//        }
//        
//        let urlString = "http://127.0.0.1:5000/history?user_id=\(user_id)"
//        
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL")
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error resetting sets:", error)
//                return
//            }
//            print("Fetches history successfully")
//        }.resume()
//    }
}

#Preview {
    HistoryView(onDismiss: {})
}
