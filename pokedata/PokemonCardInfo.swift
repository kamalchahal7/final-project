//
//  PokemonCardInfo.swift
//  pokedata
//
//  Created by Kamal on 2024-08-18.
//

import SwiftUI

struct PokemonCardInfo: View {
    @AppStorage("user_id") var user_id: Int = 0
    @Binding var collectionEdit: Bool
    @Binding var market: String
    @Binding var collection: [PokemonCard]
    var pokemonCard: PokemonCard
    @Binding var showLoginView: Bool
    @Binding var showRegisterView: Bool
    @Binding var message: String
    @Binding var errorCode: String
    @Binding var fault: Bool
    let onDismiss: () -> Void
    // Indicates whether a section is shown or not
    @State private var shown: [Bool] = [true, true, true, true, true, true]
    @State private var collectRequest: Bool = false
    @State private var notLoggedIn: Bool = false
    init(collectionEdit: Binding<Bool>, market: Binding<String>, collection: Binding<[PokemonCard]>, pokemonCard: PokemonCard, showLoginView: Binding<Bool>, showRegisterView: Binding<Bool>, message: Binding<String>, errorCode: Binding<String>, fault: Binding<Bool>, onDismiss: @escaping () -> Void) {
        self.pokemonCard = pokemonCard
        self._collectionEdit = collectionEdit
        self._market = market
        self._collection = collection
        self._showLoginView = showLoginView
        self._showRegisterView = showRegisterView
        self._message = message
        self._errorCode = errorCode
        self._fault = fault
        self.onDismiss = onDismiss
        _collectRequest = State(initialValue: UserDefaults.standard.bool(forKey: "collectRequest_\(pokemonCard.id)"))
    }
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
                        Button {
                            withAnimation {
                                if user_id == 0 {
                                    notLoggedIn = true
                                } else {
                                    DispatchQueue.main.async {
                                        collectionEdit = true
                                    }
                                    collectRequest.toggle()
                                    UserDefaults.standard.set(collectRequest, forKey: "collectRequest_\(pokemonCard.id)")
                                    if collectRequest {
                                        collection.append(pokemonCard)
                                    }
                                    else {
                                        if let index = collection.firstIndex(of: pokemonCard) {
                                            collection.remove(at: index)
                                        }
                                    }
                                    submitCollect()
                                }
                            }
                        } label: {
                            Text (collectRequest && !notLoggedIn && user_id != 0 ? "Remove" : "Add")
//                                        .symbolVariant(.circle.fill)
                        }
                        .padding(10)
                        .background(Color.gray)
                        .foregroundStyle(Color.white)
                        .cornerRadius(10)
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
                                Text("Image of Set Symbol")
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
                            + Text("$\(market)")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color(red: 0.0, green: 0.5, blue: 0.0))
                            Spacer()
                        }
                        .font(.title2)
                        
                        Divider()
                        GroupBox {
                            HStack {
                                Text("Card Details")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                Spacer()
                                Button {
                                    withAnimation {
                                        shown[1].toggle()
                                    }
                                } label: {
                                    Image (systemName: shown[1] ? "chevron.up" : "chevron.down")
//                                        .symbolVariant(.circle.fill)
                                }
                                .font(.title2)
//                                .foregroundStyle(.gray.opacity(0.5))
                            }
                            //                            .padding(.bottom, shown[0] ? 10 : 0)
                            if shown[1] {
                                Divider()
                            }
                            if shown[1] {
                                //for multiple subtypes
                                if let subtypes = pokemonCard.subtypes {
                                    let num = subtypes.count
                                    if num == 1 {
                                        Text("\(subtypes[0]) \(pokemonCard.supertype) Card")
                                            .font(.title3)
                                    } else if num == 2 {
                                        Text("\(subtypes[0]) \(subtypes[1]) \(pokemonCard.supertype) Card")
                                            .font(.title3)
                                    } else if num == 3 {
                                        Text("\(subtypes[0]) \(subtypes[1]) \(subtypes[2]) | \(pokemonCard.supertype)")
                                            .font(.title3)
                                    }
                                    
                                    if let preEvo = pokemonCard.evolvesFrom {
                                        Text("Evolves From: \(preEvo)")
                                            .padding(.bottom, 4)
                                    }
                                }
                                
                                
                                
                                
                                //                                else {
                                //                                    HStack {
                                //                                        ForEach(pokemonCard.subtypes.indices, id: \.self) { index in
                                //                                            Text("\(pokemonCard.subtypes[index])")
                                //                                        }
                                //                                        Text("|")
                                //                                        Text("\(pokemonCard.supertype) Card")
                                //                                    }
                                //                                }
                                // ------------------------- FOR THIS SECTION: CHECK TYPES AND HP MIGHT CAUSE A CRASH
                                // for multiple types
                                if let types = pokemonCard.types {
                                    if types.count == 1 {
                                        Text("Type: \(types[0])")
                                            .font(.title3)
                                    }
                                    else if types.count == 2 {
                                        Text("Types: \(types[0])/\(types[1])")
                                            .font(.title3)
                                    }
                                }
                                
                                // card number
                                Text("Card Number: \(pokemonCard.number)/\(pokemonCard.setPrintedTotal)")
                                    .font(.title3)
                                
                                // rarity
                                if let rarity = pokemonCard.rarity {
                                    Text("Rarity: \(rarity)")
                                        .font(.title3)
                                }
                                
                                // pokedex number
                                if let pokedex = pokemonCard.nationalPokedexNumbers {
                                    let num = pokedex.count
                                    if num == 1 {
                                        Text("Pokedex #: \(pokedex[0])")
                                    }
                                    else {
                                        HStack {
                                            ForEach(pokedex.indices, id: \.self) { index in
                                                
                                                if index == 0 {
                                                    Text("Pokedex #(s):")
                                                }
                                                if index < num - 1 {
                                                    Text("\(pokedex[index]),")
                                                }
                                                if index == num - 1 {
                                                    Text("\(pokedex[index])")
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                
                                Text("TCG Info")
                                    .font(.title3)
                                let standard = pokemonCard.legalitiesStandard != nil ? "Standard," : ""
                                let expanded = pokemonCard.legalitiesExpanded != nil ? "Expanded," : ""
                                let unlimited = pokemonCard.legalitiesUnlimited != nil ? "Unlimited" : ""
                                
                                Text("Legal in:")
                                if standard != "" {
                                    Text(standard)
                                }
                                if expanded != "" {
                                    Text(expanded)
                                }
                                if unlimited != "" {
                                    Text(unlimited)
                                }
                                
                                if let mark = pokemonCard.regulationMark {
                                    Text("Regulation Mark: \(mark)")
                                }
                                

                                // hp
                                if let hp = pokemonCard.hp {
                                    Text("HP: \(hp)")
                                        .font(.title3)
                                }
                                
                                if pokemonCard.ancientTraitName != nil && pokemonCard.ancientTraitText != nil {
                                    Text("Ancient Trait: \(pokemonCard.ancientTraitName!)")
                                        .font(.title3)
                                    Text(pokemonCard.ancientTraitText!)
                                        .font(.title3)
                                }
                                if pokemonCard.abilitiesName != nil && pokemonCard.abilitiesText != nil && pokemonCard.abilitiesType != nil {
                                    ForEach(pokemonCard.abilitiesName!.indices, id: \.self) { index in
                                        Text("\(pokemonCard.abilitiesType![index]): \(pokemonCard.abilitiesName![index])")
                                            .font(.title3)
                                        Text(pokemonCard.abilitiesText![index])
                                        
                                    }
                                }
                                
                                if let attacksName = pokemonCard.attacksName, let attacksDamage = pokemonCard.attacksDamage, let attacksText = pokemonCard.attacksText, let attacksConvertedEnergyCost = pokemonCard.attacksConvertedEnergyCost {
                                    ForEach(attacksName.indices, id: \.self) { index in
                                        Text("Attack #\(index + 1)")
                                            .font(.title3)
                                        HStack {
                                            Text("[\(attacksConvertedEnergyCost[index])]")
                                            Text(attacksName[index])
                                            if let damage = attacksDamage[index]{
                                                Text(damage)
                                            }
                                            Spacer()
                                        }
                                        if attacksText[index] != "" {
                                            Text(attacksText[index])
                                        }
                                        
                                    }
                                }
                                
                                // maybe make it side by side using a lazyvgrid or lazyhgrid
                                // rmr TO ADD THE COLOUR
                                // weakness
                                if pokemonCard.weaknessType != nil && pokemonCard.weaknessValue != nil {
                                    Text("Weakness: \(pokemonCard.weaknessType!) [\(pokemonCard.weaknessValue!)]")
                                        .font(.title3)
                                        .foregroundStyle(Color.red)
                                }
                                
                                // resistances
                                if pokemonCard.resistanceType != nil && pokemonCard.resistanceValue != nil {
                                    Text("Resistance: \(pokemonCard.resistanceType!) [\(pokemonCard.resistanceValue!)]")
                                        .font(.title3)
                                        .foregroundStyle(Color.green)
                                }
                                
                                // retreat cost
                                if let retreat = pokemonCard.convertedRetreatCost {
                                    Text("Retreat Cost: \(retreat) Colorless Energies")
                                        .font(.title3)
                                }
                                
                                
                                
                                // rules for exs, gxs, vstars etc
                                if let rules = pokemonCard.rules {
                                    Text("Rules")
                                        .font(.title3)
                                    ForEach(pokemonCard.rules!.indices, id: \.self) { index in
                                        HStack {
                                            Text(rules[index])
                                                .padding(10)
                                                .background(Color.indigo)
                                                .foregroundStyle(Color.white)
                                                .cornerRadius(20)
                                            Spacer()
                                        }
                                        
                                    }
                                }

                                if let description = pokemonCard.flavorText {
                                    HStack {
                                        Text("Description")
                                            .font(.title3)
                                        Spacer()
                                    }
                                    HStack {
                                        Text(description)
                                            .padding(10)
                                            .background(Color.indigo)
                                            .foregroundStyle(Color.white)
                                            .cornerRadius(20)
                                        Spacer()
                                    }
                                    
                                        
                                }
                                
                                // artist name
                                if let artist = pokemonCard.artist {
                                    Text("Illustrations by: \(artist)")
                                }
                                
                            }
                        }
                        GroupBox {
                            HStack {
                                Text("Additional Pricing (USD)")
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
                                Divider()
                                Text("Updated: \(pokemonCard.tcgUpdatedAt)")
                                    .padding(.top, 4)
                                    .foregroundStyle(Color.gray)
                            }
                        }
                    }
                    .padding(.bottom, 100)
// bottom spacer
//                    Spacer()
                }
                .padding()
                .onChange(of: pokemonCard) {
                    // Update the collectRequest when a new card is selected
                    collectRequest = UserDefaults.standard.bool(forKey: "collectRequest_\(pokemonCard.id)")
                }
            }
            .background(VStack(spacing: .zero) { Color.indigo })
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .sheet(isPresented: $notLoggedIn) {
                VStack {
                    HStack {
                        Spacer()
                        Button("Close") {
                            notLoggedIn = false
                        }
                        .padding([.top, .trailing], !showRegisterView ? 0 : 16)
                    }
                    if showLoginView {
                        LoginView(showLoginView: $showLoginView, showRegisterView: $showRegisterView, message: $message, errorCode: $errorCode, fault: $fault, onLoginSuccess: {
                            notLoggedIn = false
                        })
                    }
                    if showRegisterView {
                        RegisterView(showLoginView: $showLoginView, showRegisterView: $showRegisterView, message: $message, errorCode: $errorCode, fault: $fault)
//                                .padding(.top, isNotchDevice > 25 ? 35 : 0)
                    }
                }
                .padding(showRegisterView ? 0 : 16)
                .background(Color(red: 0.82, green: 0.71, blue: 0.55).edgesIgnoringSafeArea(.all))
            }
        }
    }
    func submitCollect() {
        guard let url = URL(string: "http://127.0.0.1:5000/collection") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let bodyData = "user_id=\(user_id)&id=\(pokemonCard.id)&add=\(collectRequest)"
        
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("Server error: \(httpResponse.statusCode)")
                return
            }
        }.resume()
    }
    
    func isPriceAvailable(in prices: [String: Double?]) -> Bool {
        for key in prices.keys {
            if let price = prices[key], price != nil {
                return true
            }
        }
        return false
    }
    
    func updateLoginState() {
        if !showRegisterView && !showLoginView {
            notLoggedIn = false
        }
    }
}

#Preview {
    PokemonCardInfo(collectionEdit: .constant(false), market: .constant("0.55 USD"), collection: .constant([PokemonCard( // Collection list with one element
        id: "xy10-78",
        name: "Lugia",
        supertype: "Pokémon",
        subtypes: ["Basic"],
        hp: "120",
        types: ["Colorless"],
        evolvesFrom: "Lugia Jr.",
        rules: nil,
        ancientTraitName: nil,
        ancientTraitText: nil,
        abilitiesName: ["Pressure"],
        abilitiesText: ["As long as this Pokémon is your Active Pokémon, any damage done by attacks from your opponent's Active Pokémon is reduced by 20 (before applying Weakness and Resistance)."],
        abilitiesType: ["Ability"],
        attacksCost: ["Colorless", "Colorless", "Colorless"],
        attacksName: ["Intensifying Burn"],
        attacksText: ["If your opponent's Active Pokémon is a Pokémon-EX, this attack does 60 more damage."],
        attacksDamage: ["60+"],
        attacksConvertedEnergyCost: [3],
        weaknessType: "Lightning",
        weaknessValue: "×2",
        resistanceType: "Fighting",
        resistanceValue: "-20",
        retreatCost: ["Colorless", "Colorless"],
        convertedRetreatCost: 2,
        number: "78",
        artist: "TOKIYA",
        rarity: "Rare",
        flavorText: "It is said to be the guardian of the seas. It is rumored to have been seen on the night of a storm.",
        nationalPokedexNumbers: [249],
        legalitiesStandard: "Legal",
        legalitiesExpanded: "Legal",
        legalitiesUnlimited: "Legal",
        regulationMark: nil,
        lowImageURL: "https://images.pokemontcg.io/xy10/78.png",
        highImageURL: "https://images.pokemontcg.io/xy10/78_hires.png",
        tcgURL: "https://prices.pokemontcg.io/tcgplayer/xy10-78",
        tcgUpdatedAt: "2024/08/18",
        tcgPricesType: ["normal": "Normal", "reverseHolofoil": "Reverse Holofoil"],
        tcgPricesLow: ["normal": nil, "reverseHolofoil": nil],
        tcgPricesMid: ["normal": 0.56, "reverseHolofoil": 1.92],
        tcgPricesHigh: ["normal": 5.0, "reverseHolofoil": 10.0],
        tcgPricesMarket: ["normal": 0.55, "reverseHolofoil": 2.39],
        tcgPricesDirectLow: ["normal": nil, "reverseHolofoil": nil],
        setId: "xy10",
        setName: "Fates Collide",
        setSeries: "XY",
        setPrintedTotal: 124,
        setTotal: 129,
        setLegalitiesStandard: nil,
        setLegalitiesExpanded: "Legal",
        setLegalitiesUnlimited: "Legal",
        setPtcgoCode: "FCO",
        setReleaseDate: "2016/05/02",
        setUpdatedAt: "2018/09/03 11:49:00",
        setImagesSymbol: "https://images.pokemontcg.io/xy10/symbol.png",
        setImagesLogo: "https://images.pokemontcg.io/xy10/logo.png")
    ]), pokemonCard: PokemonCard(id: "xy10-78", name: "Lugia", supertype: "Pokémon", subtypes: ["Basic"], hp: "120", types: ["Colorless"], evolvesFrom: "Lugia Jr.", rules: nil, ancientTraitName: nil, ancientTraitText: nil, abilitiesName: ["Pressure"], abilitiesText: ["As long as this Pokémon is your Active Pokémon, any damage done by attacks from your opponent's Active Pokémon is reduced by 20 (before applying Weakness and Resistance)."], abilitiesType: ["Ability"], attacksCost: ["Colorless", "Colorless", "Colorless"], attacksName: ["Intensifying Burn"], attacksText: ["If your opponent's Active Pokémon is a Pokémon-EX, this attack does 60 more damage."], attacksDamage: ["60+"], attacksConvertedEnergyCost: [3], weaknessType: "Lightning", weaknessValue: "×2", resistanceType: "Fighting", resistanceValue: "-20", retreatCost: ["Colorless", "Colorless"], convertedRetreatCost: 2, number: "78", artist: "TOKIYA", rarity: "Rare", flavorText: "It is said to be the guardian of the seas. It is rumored to have been seen on the night of a storm.", nationalPokedexNumbers: [249], legalitiesStandard: "Legal", legalitiesExpanded: "Legal", legalitiesUnlimited: "Legal", regulationMark: nil, lowImageURL: "https://images.pokemontcg.io/xy10/78.png", highImageURL: "https://images.pokemontcg.io/xy10/78_hires.png", tcgURL: "https://prices.pokemontcg.io/tcgplayer/xy10-78", tcgUpdatedAt: "2024/08/18", tcgPricesType: ["normal": "Normal", "reverseHolofoil": "Reverse Holofoil"], tcgPricesLow: ["normal": nil, "reverseHolofoil": nil], tcgPricesMid: ["normal": 0.56, "reverseHolofoil": 1.92], tcgPricesHigh: ["normal": 5.0, "reverseHolofoil": 10.0], tcgPricesMarket: ["normal": 0.55, "reverseHolofoil": 2.39], tcgPricesDirectLow: ["normal": nil, "reverseHolofoil": nil], setId: "xy10", setName: "Fates Collide", setSeries: "XY", setPrintedTotal: 124, setTotal: 129, setLegalitiesStandard: nil, setLegalitiesExpanded: "Legal", setLegalitiesUnlimited: "Legal", setPtcgoCode: "FCO", setReleaseDate: "2016/05/02", setUpdatedAt: "2018/09/03 11:49:00", setImagesSymbol: "https://images.pokemontcg.io/xy10/symbol.png", setImagesLogo: "https://images.pokemontcg.io/xy10/logo.png"), showLoginView: .constant(true), showRegisterView: .constant(false), message: .constant("OK"), errorCode: .constant("Status Code: 200"), fault: .constant(false), onDismiss: {})
}
