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
                        .foregroundColor(Color.white)
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
                        }
                        .padding(10)
                        .background(Color.gray)
                        .foregroundColor(Color.white)
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
                            Text("#\(pokemonCard.number)/\(pokemonCard.setPrintedTotal)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.bottom, -1.5)
                        }
                    }
                    
                    GroupBox {
                        HStack {
                            Spacer()
                            Text("Market Price: ")
                                .fontWeight(.bold)
                            + Text("$\(market)")
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.0, green: 0.5, blue: 0.0))
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
                                        shown[0].toggle()
                                    }
                                } label: {
                                    Image (systemName: shown[0] ? "chevron.up" : "chevron.down")
                                }
                                .font(.title2)
                            }
                            if shown[0] {
                                Divider()
                            }
                            if shown[0] {
                                // for multiple subtypes
                                if let subtypes = pokemonCard.subtypes, let rarity = pokemonCard.rarity {
                                    let num = subtypes.count
                                    if num == 1 {
                                        Text("\(rarity) \(subtypes[0]) \(pokemonCard.supertype) Card")
                                            .font(.title2)
                                            .bold()
                                            .multilineTextAlignment(.center)
                                    } else if num == 2 {
                                        Text("\(subtypes[0]) \(subtypes[1]) \(pokemonCard.supertype) Card")
                                            .font(.title2)
                                            .bold()
                                            .multilineTextAlignment(.center)
                                    } else if num == 3 {
                                        Text("\(subtypes[0]) \(subtypes[1]) \(subtypes[2]) \(pokemonCard.supertype) Card")
                                            .font(.title2)
                                            .bold()
                                            .multilineTextAlignment(.center)
                                    }
                                    
                                    if let preEvo = pokemonCard.evolvesFrom {
                                        Text("Evolves From: \(preEvo)")
                                            .padding(.bottom, 4)
                                    }
                                }
                                
                                // for multiple types
                                if let types = pokemonCard.types {
                                    if types.count == 1 {
                                        HStack {
                                            Text("Type:")
                                                .fontWeight(.semibold)
                                            Text(types[0])
                                                .padding(10)
                                                .background(Color(colours["\(types[0])"] ?? UIColor.clear))
                                                .cornerRadius(10)
                                                .foregroundColor(types[0] == "Colorless" ? .black : .white)
                                                .fontWeight(types[0] == "Colorless" ? .semibold : .bold)
                                        }
                                        .font(.title3)
                                    }
                                    else if types.count == 2 {
                                        HStack {
                                            Text("Types:")
                                                .fontWeight(.semibold)
                                            Text(types[0])
                                                .padding(10)
                                                .background(Color(colours["\(types[0])"] ?? UIColor.clear))
                                                .cornerRadius(10)
                                                .foregroundColor(types[0] == "Colorless" ? .black : .white)
                                                .fontWeight(types[0] == "Colorless" ? .semibold : .bold)
                                            Text(types[1])
                                                .padding(10)
                                                .background(Color(colours["\(types[1])"] ?? UIColor.clear))
                                                .cornerRadius(10)
                                                .foregroundColor(types[1] == "Colorless" ? .black : .white)
                                                .fontWeight(types[1] == "Colorless" ? .semibold : .bold)
                                        }
                                        .font(.title3)
                                    }
                                }
                                
                                if let pokedex = pokemonCard.nationalPokedexNumbers {
                                    let num = pokedex.count
                                    if num == 1 {
                                        Text("Pokedex #: \(pokedex[0])")
                                            .font(.title3)
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
                                Divider()
                                
                                
                                Text("TCG Info")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                let standard = pokemonCard.legalitiesStandard != nil ? "Standard" : ""
                                let expanded = pokemonCard.legalitiesExpanded != nil ? "Expanded" : ""
                                let unlimited = pokemonCard.legalitiesUnlimited != nil ? "Unlimited" : ""
                                
                                let legal = "Legal in:"
                                if standard != "" {
                                    Text("\(legal) \(unlimited), \(expanded), \(standard)")
                                } else if standard == "" && expanded != "" {
                                    Text("\(legal) \(unlimited), \(expanded)")
                                } else {
                                    Text("\(legal) \(unlimited)")
                                }
                                
                                if let mark = pokemonCard.regulationMark {
                                    Text("Regulation Mark: \(mark)")
                                }
                            }
                        }
                        
                        GroupBox {
                            HStack {
                                Text("Card Text")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                Spacer()
                                Button {
                                    withAnimation {
                                        shown[1].toggle()
                                    }
                                } label: {
                                    Image (systemName: shown[1] ? "chevron.up" : "chevron.down")
                                    
                                }
                                .font(.title2)
                            }
                            if shown[1] {
                                Divider()
                            }
                            if shown[1] {
                                // hp
                                if let hp = pokemonCard.hp {
                                    Text("HP: \(hp)")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                }
                                
                                if pokemonCard.ancientTraitName != nil && pokemonCard.ancientTraitText != nil {
                                    Divider()
                                    Text("Ancient Trait: \(pokemonCard.ancientTraitName!)")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .padding(.bottom, 2)
                                    Text(pokemonCard.ancientTraitText!)
                                        .italic()
                                }
                                if pokemonCard.abilitiesName != nil && pokemonCard.abilitiesText != nil && pokemonCard.abilitiesType != nil {
                                    Divider()
                                    ForEach(pokemonCard.abilitiesName!.indices, id: \.self) { index in
                                        Text("\(pokemonCard.abilitiesType![index]): \(pokemonCard.abilitiesName![index])")
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .padding(.bottom, 2)
                                        Text(pokemonCard.abilitiesText![index])
                                            .italic()
                                        
                                    }
                                }
                                
                                if let attacksName = pokemonCard.attacksName, let attacksDamage = pokemonCard.attacksDamage, let attacksText = pokemonCard.attacksText, let attacksConvertedEnergyCost = pokemonCard.attacksConvertedEnergyCost {
                                    Divider()
                                    ForEach(attacksName.indices, id: \.self) { index in
                                        Text("Attack #\(index + 1)")
                                            .font(.title2)
                                            .padding(.bottom, 2)
                                            .fontWeight(.semibold)
                                        HStack {
                                            Spacer()
                                            Text("[\(attacksConvertedEnergyCost[index])]")
                                            Text(attacksName[index])
                                            if let damage = attacksDamage[index]{
                                                Text(damage)
                                            }
                                            Spacer()
                                        }
                                        .font(.title3)
                                        .padding(.bottom, 2)
                                        if attacksText[index] != "" {
                                            Text(attacksText[index])
                                            .italic()
                                            .padding(.bottom, 2)
                                        }
                                        
                                    }
                                }
                                
                                if (pokemonCard.weaknessType != nil && pokemonCard.weaknessValue != nil) || (pokemonCard.resistanceType != nil && pokemonCard.resistanceValue != nil) {
                                    Divider()
                                }
                                
                                // weakness
                                if pokemonCard.weaknessType != nil && pokemonCard.weaknessValue != nil {
                                    Text("Weakness(es):")
                                        .font(.title2)
                                        .foregroundColor(Color.red)
                                        .bold()
                                    Text("\(pokemonCard.weaknessType!) [\(pokemonCard.weaknessValue!)]")
                                        .padding(.bottom, 2)
                                }
                                
                                // resistances
                                if pokemonCard.resistanceType != nil && pokemonCard.resistanceValue != nil {
                                    Text("Resistance(s):")
                                        .font(.title2)
                                        .foregroundColor(Color.green)
                                        .bold()
                                    Text("\(pokemonCard.resistanceType!) [\(pokemonCard.resistanceValue!)]")
                                }
                                
                                
                                // retreat cost
                                if let retreat = pokemonCard.convertedRetreatCost {
                                    Divider()
                                    Text("Retreat Cost:")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .padding(.bottom, 2)
                                    Text("\(retreat) Colorless Energies")
                                }
                                
                                
                                
                                // rules for exs, gxs, vstars etc
                                if let rules = pokemonCard.rules {
                                    Divider()
                                    Text("Rules")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .padding(.bottom, 2)
                                    ForEach(pokemonCard.rules!.indices, id: \.self) { index in
                                        Text(rules[index])
                                            .italic()
                                    }
                                }
                                
                                if let description = pokemonCard.flavorText {
                                    Divider()
                                    HStack {
                                        Spacer()
                                        Text("Description")
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .padding(.bottom, 2)
                                        Spacer()
                                    }
                                    Text(description)
                                        .italic()
                                }
                                
                                // artist name
                                if let artist = pokemonCard.artist {
                                    Divider()
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
                                        shown[2].toggle()
                                    }
                                } label: {
                                    Image (systemName: shown[2] ? "chevron.up" : "chevron.down")
                                }
                                .font(.title2)
                            }
                            if shown[2] {
                                Divider()
                            }
                            
                            if shown[2] {
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
                                    .foregroundColor(Color.gray)
                            }
                        }
                    }
                    .padding(.bottom, 100)
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
                    }
                }
                .padding(showRegisterView ? 0 : 16)
                .background(Color(red: 0.82, green: 0.71, blue: 0.55).edgesIgnoringSafeArea(.all))
            }
        }
        
//  Future Implementation (HistoryView):
        
//        .onAppear {
//            trackCard()
//        }
        
//        .onDisappear {
//            onDismiss()
//        }
    }
    
//  Future Implementation (HistoryView):
    
//    func trackCard() {
//        guard let url = URL(string: "\(Config.baseURL)/history") else {
//            print("Invalid URL")
//            return
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        let bodyData = "user_id=\(user_id)&item_id=\(pokemonCard.id)"
//        
//        request.httpBody = bodyData.data(using: String.Encoding.utf8)
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//                return
//            }
//            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
//                print("Server error: \(httpResponse.statusCode)")
//                return
//            }
//        }.resume()
//    }
    func submitCollect() {
        guard let url = URL(string: "\(Config.baseURL)/collection") else {
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
    ]), pokemonCard: PokemonCard(id: "xy10-78", name: "Lugia", supertype: "Pokémon", subtypes: ["Basic"], hp: "120", types: ["Colorless"], evolvesFrom: "Lugia Jr.", rules: nil, ancientTraitName: nil, ancientTraitText: nil, abilitiesName: ["Pressure"], abilitiesText: ["As long as this Pokémon is your Active Pokémon, any damage done by attacks from your opponent's Active Pokémon is reduced by 20 (before applying Weakness and Resistance)."], abilitiesType: ["Ability"], attacksCost: ["Colorless", "Colorless", "Colorless"], attacksName: ["Intensifying Burn"], attacksText: ["If your opponent's Active Pokémon is a Pokémon-EX, this attack does 60 more damage."], attacksDamage: ["60+"], attacksConvertedEnergyCost: [3], weaknessType: "Lightning", weaknessValue: "×2", resistanceType: "Fighting", resistanceValue: "-20", retreatCost: ["Colorless", "Colorless"], convertedRetreatCost: 2, number: "78", artist: "TOKIYA", rarity: "Rare", flavorText: "It is said to be the guardian of the seas. It is rumored to have been seen on the night of a storm.", nationalPokedexNumbers: [249], legalitiesStandard: nil, legalitiesExpanded: nil, legalitiesUnlimited: "Legal", regulationMark: nil, lowImageURL: "https://images.pokemontcg.io/xy10/78.png", highImageURL: "https://images.pokemontcg.io/xy10/78_hires.png", tcgURL: "https://prices.pokemontcg.io/tcgplayer/xy10-78", tcgUpdatedAt: "2024/08/18", tcgPricesType: ["normal": "Normal", "reverseHolofoil": "Reverse Holofoil"], tcgPricesLow: ["normal": nil, "reverseHolofoil": nil], tcgPricesMid: ["normal": 0.56, "reverseHolofoil": 1.92], tcgPricesHigh: ["normal": 5.0, "reverseHolofoil": 10.0], tcgPricesMarket: ["normal": 0.55, "reverseHolofoil": 2.39], tcgPricesDirectLow: ["normal": nil, "reverseHolofoil": nil], setId: "xy10", setName: "Fates Collide", setSeries: "XY", setPrintedTotal: 124, setTotal: 129, setLegalitiesStandard: "nil", setLegalitiesExpanded: "nil", setLegalitiesUnlimited: "Legal", setPtcgoCode: "FCO", setReleaseDate: "2016/05/02", setUpdatedAt: "2018/09/03 11:49:00", setImagesSymbol: "https://images.pokemontcg.io/xy10/symbol.png", setImagesLogo: "https://images.pokemontcg.io/xy10/logo.png"), showLoginView: .constant(true), showRegisterView: .constant(false), message: .constant("OK"), errorCode: .constant("Status Code: 200"), fault: .constant(false), onDismiss: {})
}
