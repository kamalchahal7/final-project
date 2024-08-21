//
//  PokemonCardInfo.swift
//  pokedata
//
//  Created by Kamal on 2024-08-18.
//

import SwiftUI

struct PokemonCardInfo: View {
    // Indicates whether a section is shown or not
    @State private var shown: [Bool] = [true, true, true, true, true, true]
    @Binding var market: String
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
                        HStack {
                            Spacer()
                            Text("Market Price: ")
                                .fontWeight(.bold)
                            + Text("\(market)")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color(red: 0.0, green: 0.5, blue: 0.0))
                            Spacer()
                        }
                        .font(.title2)
                        
                        
                        //                        Text("")\(pokemonCard.subtypes[0]) \(pokemonCard.supertype) Card")
                        Divider()
                        GroupBox {
                            HStack {
                                Text("Additional Pricing")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                Spacer()
                                Button {
                                    withAnimation {
                                        shown[0].toggle()
                                    }
                                } label: {
                                    Image (systemName: shown[0] ? "chevron.up" : "chevron.down")
                                    //                                        .symbolVariant(.circle.fill)
                                }
                                .font(.title2)
                                //                                .foregroundStyle(.gray.opacity(0.5))
                            }
//                            .padding(.bottom, shown[0] ? 10 : 0)
                            if shown[0] {
                                Divider()
                            }
                            
                            if shown[0] {
                                
                                // Market Prices
                                Text("Market Price")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 1)
                                ForEach(pokemonCard.tcgPricesMarket.keys.sorted(), id: \.self) { key in
                                    if let price = pokemonCard.tcgPricesMarket[key] {
                                        if price != nil {
                                            if let type = pokemonCard.tcgPricesType[key] {
                                                if type != nil {
                                                    VStack (alignment: .leading) {
                                                        Text(String(format: "\(type!) Card: $%.2f", price!))
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                if !isPriceAvailable(in: pokemonCard.tcgPricesMarket) {
                                    Text("Price Unavailable")
                                }
                                Divider()
                                
                                // Low Prices
                                Text("Low Price")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 1)
                                ForEach(pokemonCard.tcgPricesLow.keys.sorted(), id: \.self) { key in
                                    if let price = pokemonCard.tcgPricesLow[key] {
                                        if price != nil {
                                            if let type = pokemonCard.tcgPricesType[key] {
                                                if type != nil {
                                                    Text(String(format: "\(type!) Card: $%.2f", price!))
                                                }
                                            }
                                        }
                                    }
                                }
                                if !isPriceAvailable(in: pokemonCard.tcgPricesLow) {
                                    Text("Price Unavailable")
                                }
                                Divider()
                                
                                // Mid Prices
                                Text("Mid Prices")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 1)
                                ForEach(pokemonCard.tcgPricesMid.keys.sorted(), id: \.self) { key in
                                    if let price = pokemonCard.tcgPricesMid[key] {
                                        if price != nil {
                                            if let type = pokemonCard.tcgPricesType[key] {
                                                if type != nil {
                                                    Text(String(format: "\(type!) Card: $%.2f", price!))
                                                }
                                            }
                                        }
                                    }
                                }
                                if !isPriceAvailable(in: pokemonCard.tcgPricesMid) {
                                    Text("Price Unavailable")
                                }
                                Divider()
                                
                                // High Prices
                                Text("High Price")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 1)
                                ForEach(pokemonCard.tcgPricesHigh.keys.sorted(), id: \.self) { key in
                                    if let price = pokemonCard.tcgPricesHigh[key] {
                                        if price != nil {
                                            if let type = pokemonCard.tcgPricesType[key] {
                                                if type != nil {
                                                    Text(String(format: "\(type!) Card: $%.2f", price!))
                                                }
                                            }
                                        }
                                    }
                                }
                                if !isPriceAvailable(in: pokemonCard.tcgPricesHigh) {
                                    Text("Price Unavailable")
                                }
                                Divider()
                                
                                // Direct Low Prices
                                Text("Direct Low Price")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 1)
                                ForEach(pokemonCard.tcgPricesDirectLow.keys.sorted(), id: \.self) { key in
                                    if let price = pokemonCard.tcgPricesDirectLow[key] {
                                        if price != nil {
                                            if let type = pokemonCard.tcgPricesType[key] {
                                                if type != nil {
                                                    Text(String(format: "\(type!) Card: $%.2f", price!))
                                                }
                                            }
                                        }
                                    }
                                }
                                if !isPriceAvailable(in: pokemonCard.tcgPricesDirectLow) {
                                    Text("Price Unavailable")
                                }
                            }
                        }
                    }
                    .padding(.bottom, 100)
// bottom spacer
//                    Spacer()
                }
                .padding()
            }
            .background(VStack(spacing: .zero) { Color.indigo })
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
    }
    
    func isPriceAvailable(in prices: [String: Double?]) -> Bool {
        for key in prices.keys {
            if let price = prices[key], price != nil {
                return true
            }
        }
        return false
    }
}

#Preview {
    PokemonCardInfo(market: .constant("0.55 USD"), pokemonCard: PokemonCard(id: "xy10-78", name: "Lugia", supertype: "Pokémon", subtypes: ["Basic"], hp: "120", types: ["Colorless"], evolvesFrom: nil, rules: nil, ancientTraitName: nil, ancientTraitText: nil, abilitiesName: ["Pressure"], abilitiesText: ["As long as this Pokémon is your Active Pokémon, any damage done by attacks from your opponent's Active Pokémon is reduced by 20 (before applying Weakness and Resistance)."], abilitiesType: ["Ability"], attacksCost: ["Colorless", "Colorless", "Colorless"], attacksName: ["Intensifying Burn"], attacksText: ["If your opponent's Active Pokémon is a Pokémon-EX, this attack does 60 more damage."], attacksDamage: ["60+"], attacksConvertedEnergyCost: [3], weaknessesType: ["Lightning"], weaknessesValue: ["×2"], resistancesType: ["Fighting"], resistancesValue: ["-20"], retreatCost: ["Colorless", "Colorless"], convertedRetreatCost: 2, number: "78", artist: "TOKIYA", rarity: "Rare", flavorText: "It is said to be the guardian of the seas. It is rumored to have been seen on the night of a storm.", nationalPokedexNumbers: [249], legalitiesStandard: nil, legalitiesExpanded: "Legal", legalitiesUnlimited: "Legal", regulationMark: nil, lowImageURL: "https://images.pokemontcg.io/xy10/78.png", highImageURL: "https://images.pokemontcg.io/xy10/78_hires.png", tcgURL: "https://prices.pokemontcg.io/tcgplayer/xy10-78", tcgUpdatedAt: "2024/08/18", tcgPricesType: ["normal": "Normal", "reverseHolofoil": "Reverse Holofoil"], tcgPricesLow: ["normal": nil, "reverseHolofoil": nil], tcgPricesMid: ["normal": 0.56, "reverseHolofoil": 1.92], tcgPricesHigh: ["normal": 5.0, "reverseHolofoil": 10.0], tcgPricesMarket: ["normal": 0.55, "reverseHolofoil": 2.39], tcgPricesDirectLow: ["normal": nil, "reverseHolofoil": nil], setId: "xy10", setName: "Fates Collide", setSeries: "XY", setPrintedTotal: 124, setTotal: 129, setLegalitiesStandard: nil, setLegalitiesExpanded: "Legal", setLegalitiesUnlimited: "Legal", setPtcgoCode: "FCO", setReleaseDate: "2016/05/02", setUpdatedAt: "2018/09/03 11:49:00", setImagesSymbol: "https://images.pokemontcg.io/xy10/symbol.png", setImagesLogo: "https://images.pokemontcg.io/xy10/logo.png"), onDismiss: {})
}
