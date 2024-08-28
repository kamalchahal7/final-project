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
            VStack {
                Button("Dismiss", action: onDismiss)
                Text("View History")
            }
        }
    }
}

#Preview {
    HistoryView(onDismiss: {})
}
