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
            VStack {
                Button("Dismiss", action: onDismiss)
                Text("Credits and Acknowledgement")
            }
        }
        .background(Color.red.ignoresSafeArea())
    }
}

#Preview {
    CreditsView(onDismiss: {})
}
