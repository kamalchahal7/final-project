//
//  HistoryView.swift
//  pokedata
//
//  Created by Kamal on 2024-08-27.
//

import SwiftUI

struct HistoryView: View {
    let onDismiss: () -> Void
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                HStack {
                    Button("Back") {
                        onDismiss()
                    }
                    Spacer()
                }
                .padding([.leading, .top])
                VStack {
                    ZStack {
                        GroupBox {
                            HStack {
                                Text("View History")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            Divider()
                            List {
                                
                            }
                        }
                    }
                    
                }
                .padding()
            }
        }
    }
}

#Preview {
    HistoryView(onDismiss: {})
}
