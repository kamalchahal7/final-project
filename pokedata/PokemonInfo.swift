//
//  SwiftUIView.swift
//  pokedata
//
//  Created by Kamal on 2024-08-07.
//

import SwiftUI

struct PokemonInfo: View {
    var pokemon: Pokemon
    let onDismiss: () -> Void
    var body: some View {
        VStack {
            HStack {
                Button("Back") {
                    onDismiss()
                }
                Spacer()
            }
            .padding()

            Spacer()

            Text("Detail view for \(pokemon.name)")
                .font(.largeTitle)
                .padding()

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 8)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
    }
}

#Preview {
    PokemonInfo(pokemon: Pokemon(id: 0, name: "Placeholder", pokedex_num: 0), onDismiss: {})
}
