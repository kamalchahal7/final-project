//
//  PokemonCardInfo.swift
//  pokedata
//
//  Created by Kamal on 2024-08-18.
//

import SwiftUI

struct PokemonCardInfo: View {
    // Indicates whether a section is shown or not

    var pokemonCard: PokemonCard
    let onDismiss: () -> Void
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    HStack {
                        Button("Back") {
                            onDismiss()
                        }
                        .padding(10)
                        .background(Color.gray)
                        .foregroundStyle(Color.white)
                        .cornerRadius(10)
                        
                        
                        
                        Spacer()
                    }
                    .padding(.top, 40)
                    
                    
                    Spacer()
                    
                    AsyncImage(url: URL(string: pokemonCard.highImageURL)) { image in
                        image.resizable().scaledToFit().padding().shadow(color: .white, radius: 100).frame(height: geometry.size.height * 0.55)
                    } placeholder: {
                        Text("Image of Pokemon Card")
                    }
                    
                    GroupBox {
                        HStack {
                            Text("\(pokemonCard.name)")
                                .fontWeight(.bold)
                                .font(.largeTitle)
                            Spacer()
                            AsyncImage(url: URL(string: pokemonCard.setImagesSymbol!)) { image in
                                image.resizable().scaledToFit().padding(5).shadow(color: .black, radius: 5).frame(height:50)
                            } placeholder: {
                                Text("Image of Pokemon Card")
                            }
                        }
                        HStack {
                            Text("\(pokemonCard.setSeries) - \(pokemonCard.setName)")
                                .font(.title)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    GroupBox {
                        
                    }
                    
                    
// bottom spacer
//                    Spacer()
                }
                .padding()
            }
            .background(VStack(spacing: .zero) { Color.indigo })
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    PokemonCardInfo(pokemonCard: PokemonCard(id: "xy10-78", name: "Lugia", supertype: "Pokémon", subtypes: ["Basic"], hp: "120",types: ["Colorless"], evolvesFrom: nil, rules: nil, ancientTraitName: nil, ancientTraitText: nil, abilitiesName: ["Pressure"], abilitiesText: ["As long as this Pokémon is your Active Pokémon, any damage done by attacks from your opponent's Active Pokémon is reduced by 20 (before applying Weakness and Resistance)."], abilitiesType: ["Ability"], attacksCost: ["Colorless", "Colorless", "Colorless"], attacksName: ["Intensifying Burn"], attacksText: ["If your opponent's Active Pokémon is a Pokémon-EX, this attack does 60 more damage."], attacksDamage: ["60+"], attacksConvertedEnergyCost: [3], weaknessesType: ["Lightning"], weaknessesValue: ["×2"], resistancesType: ["Fighting"], resistancesValue: ["-20"], retreatCost: ["Colorless", "Colorless"], convertedRetreatCost: 2, number: "78", artist: "TOKIYA", rarity: "Rare", flavorText: "It is said to be the guardian of the seas. It is rumored to have been seen on the night of a storm.", nationalPokedexNumbers: [249], legalitiesStandard: nil, legalitiesExpanded: "Legal", legalitiesUnlimited: "Legal", regulationMark: nil, lowImageURL: "https://images.pokemontcg.io/xy10/78.png", highImageURL: "https://images.pokemontcg.io/xy10/78_hires.png", tcgURL: "https://prices.pokemontcg.io/tcgplayer/xy10-78", tcgUpdatedAt: "2024/08/18", tcgPricesType: ["normal", "reverseHolofoil"], tcgPricesLow: ["normal": nil, "reverseHolofoil": nil], tcgPricesMid: ["normal": 0.56, "reverseHolofoil": 1.92], tcgPricesHigh: ["normal": 5.0, "reverseHolofoil": 10.0], tcgPricesMarket: ["normal": 0.55, "reverseHolofoil": 2.39], tcgPricesDirectLow: ["normal": nil, "reverseHolofoil": nil], setId: "xy10", setName: "Fates Collide", setSeries: "XY", setPrintedTotal: 124, setTotal: 129, setLegalitiesStandard: nil, setLegalitiesExpanded: "Legal", setLegalitiesUnlimited: "Legal", setPtcgoCode: "FCO", setReleaseDate: "2016/05/02", setUpdatedAt: "2018/09/03 11:49:00", setImagesSymbol: "https://images.pokemontcg.io/xy10/symbol.png", setImagesLogo: "https://images.pokemontcg.io/xy10/logo.png"), onDismiss: {})
}
