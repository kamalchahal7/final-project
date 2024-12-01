//
//  CollectionTabView.swift
//  pokedata
//
//  Created by Kamal on 2024-08-30.
//

import SwiftUI

struct CollectionTabView: View {
    @AppStorage("user_id") var user_id: Int = 0
    @EnvironmentObject var collections: cards
    @EnvironmentObject var activeSeries: series
    @Binding var collectionEdit: Bool
    @Binding var collection: [PokemonCard]
    @Binding var selectedCard: PokemonCard?
    @Binding var market: String
    @Binding var showLoginView: Bool
    @Binding var showRegisterView: Bool
    @Binding var message: String
    @Binding var errorCode: String
    @Binding var fault: Bool
    @State private var edited: Bool = false
    @State private var isLoading: Bool = true
    @State private var isWaiting: Bool = true
    @State private var shown: [String: Bool] = [:]
    @State var showCardDetail: Bool = false
    @State private var buttonWidth: CGFloat = 0
    @State private var phrase: Int? = nil
    
    var body: some View {
        GeometryReader { geometry in
            if user_id != 0 {
                if !showCardDetail {
                    VStack {
                        if let validPhrase = phrase {
                            if validPhrase == 0 {
                                GroupBox {
                                    HStack {
                                        Text("Collection")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                        Spacer()
                                    }
                                    
                                    if !isWaiting && !isLoading {
                                        Divider()
                                            .padding(.top, isWaiting ? 0 : -8)
                                        let total = total()
                                        HStack {
                                            Spacer()
                                            Text("Estimated Networth:")
                                                .font(.title3)
                                                .bold()
                                            Spacer()
                                        }
                                        HStack {
                                            Spacer()
                                            Text(String(format: "$%.2f USD", total))
                                                .font(.title2)
                                                .bold()
                                                .foregroundColor(Color(red: 0.0, green: 0.5, blue: 0.0))
                                            Spacer()
                                        }
                                        .padding(.bottom, -6)
                                    }
                                }
                                .padding([.leading, .trailing])
                                .cornerRadius(10) // Optional: to match the GroupBox's shape
                                .shadow(color: Color.black, radius: 5)
                                
                                ZStack {
                                    if !isLoading {
                                        ScrollView {
                                            ForEach(activeSeries.series.indices, id: \.self) { index in
                                                let serie = activeSeries.series[index]
                                                GroupBox {
                                                    HStack {
                                                        Text(serie.series)
                                                            .font(.title)
                                                            .fontWeight(.bold)
                                                        Spacer()
                                                    }
                                                    ForEach(serie.sets, id: \.id) { set in
                                                        GroupBox {
                                                            HStack {
                                                                VStack {
                                                                    HStack {
                                                                        Spacer().frame(width: geometry.size.width * 0.07 + 4)
                                                                        Spacer()
                                                                        AsyncImage(url: URL(string: set.logo)) { image in
                                                                            image.resizable().scaledToFit().frame(height: geometry.size.height * 0.1)
                                                                        } placeholder: {
                                                                            Text("Image of Set")
                                                                        }
                                                                        Spacer()
                                                                    }
                                                                    HStack {
                                                                        Spacer().frame(width: geometry.size.width * 0.07 + 4)
                                                                        AsyncImage(url: URL(string: set.symbol)) { image in
                                                                            image.resizable().scaledToFit().frame(width: geometry.size.width * 0.06)
                                                                        } placeholder: {
                                                                            Text("Image of Set")
                                                                        }
                                                                        let cardCount = collections.cards.filter { $0.setId == set.id }.count
                                                                        if !isWaiting {
                                                                            Text("\(cardCount)/\(set.total) Collected")
                                                                        }
                                                                    }
                                                                }
                                                                Button {
                                                                    withAnimation {
                                                                        shown[set.id] = !(shown[set.id] ?? false)
                                                                    }
                                                                } label: {
                                                                    Image(systemName: shown[set.id] ?? false ? "chevron.up" : "chevron.down")
                                                                        .resizable()
                                                                        .scaledToFit()
                                                                        .frame(width: geometry.size.width * 0.07)
                                                                        .symbolVariant(.circle.fill)
                                                                        .padding(.trailing, -4)
                                                                        .padding(.leading, 8)
                                                                }
                                                                .foregroundColor(.green)
                                                            }
                                                            
                                                            if shown[set.id] ?? false {
                                                                Divider()
                                                                if !isWaiting {
                                                                    // Filter and sort the cards
                                                                    let filteredAndSortedCards = collections.cards
                                                                        .filter { $0.setId == set.id }
                                                                        .sorted {
                                                                            if let firstNumber = extract(from: $0.number), let secondNumber = extract(from: $1.number) {
                                                                                return firstNumber < secondNumber
                                                                            }
                                                                            return false
                                                                        }
                                                                    // Chunk the sorted cards into rows of 7
                                                                    let rows = filteredAndSortedCards.chunked(into: 7)
                                                                    
                                                                    // Display the rows in a grid-like format using HStacks
                                                                    ForEach(rows, id: \.self) { row in
                                                                        HStack {
                                                                            ForEach(row, id: \.id) { pokemonCard in
                                                                                Button(action: {
                                                                                    withAnimation(.easeInOut) {
                                                                                        selectedCard = pokemonCard
                                                                                        market = calculateMarketPrice(for: pokemonCard)
                                                                                        showCardDetail = true
                                                                                    }
                                                                                }) {
                                                                                    //                                                                            ZStack(alignment: .bottomTrailing) {
                                                                                    ZStack {
                                                                                        AsyncImage(url: URL(string: pokemonCard.lowImageURL)) { image in
                                                                                            image
                                                                                                .resizable()
                                                                                                .scaledToFit()
                                                                                                .opacity(0.6)
                                                                                                .frame(height: geometry.size.width * 0.18)
                                                                                            
                                                                                        } placeholder: {
                                                                                            Text("Image of Pokemon Card")
                                                                                        }
                                                                                        .padding(.bottom, -10)
                                                                                        
                                                                                        if let num = extract(from: pokemonCard.number) {
                                                                                            Text("#\(num)")
                                                                                                .padding(.top, 40)
                                                                                                .font(.system(size: geometry.size.width * 0.0225))
                                                                                                .fontWeight(.semibold)
                                                                                                .foregroundColor(Color.black)
                                                                                                .shadow(color: Color.white, radius: 1)
                                                                                                .shadow(color: Color.white, radius: 2)
                                                                                                .shadow(color: Color.white, radius: 3)
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                } else {
                                                                    ProgressView()
                                                                        .progressViewStyle(CircularProgressViewStyle())
                                                                        .tint(.indigo)
                                                                        .scaleEffect(1)
                                                                }
                                                            }
                                                        }
                                                        .padding(.bottom, 4)
                                                        .cornerRadius(15) // Optional: to match the GroupBox's shape
                                                        .shadow(color: Color.black, radius: 2.5)
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        VStack {
                                            Spacer()
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle())
                                                .tint(.indigo)
                                                .scaleEffect(2.5)
                                            Spacer()
                                        }
                                    }
                                }
                                .padding()
                            } else {
                                HStack {
                                    Spacer()
                                    VStack {
                                        Spacer()
                                        Image("confused_pikachu")
                                            .resizable()
                                            .scaledToFit()
                                            .shadow(color: .white, radius: 75)
                                            .frame(height: geometry.size.height * 0.4)
                                            .padding(.top, -16)
                                        GroupBox {
                                            if phrase == 1 {
                                                Text("Looks a bit empty, eh?")
                                            } else if phrase == 2 {
                                                Text("Building a collection is a good way to pass the time.")
                                            } else if phrase == 3 {
                                                Text("Uh, anybody there?")
                                            } else if phrase == 4 {
                                                Text("Gotta Catch EM all!")
                                                Text("Well you should at least ... that's kinda the whole point.")
                                            } else if phrase == 5 {
                                                Text("Add some cards to start a collection!")
                                            }
                                        }
                                        Spacer()
                                    }
                                    .multilineTextAlignment(.center)
                                    .font(.title2)
                                    .bold()
                                    Spacer()
                                }
                            }
                        } else {
                            HStack {
                                Spacer()
                                VStack {
                                    Spacer()
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .tint(.indigo)
                                        .scaleEffect(2.5)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                    }
                    .onAppear {
                        fetchCount { num in
                            if activeSeries.series.isEmpty && collections.cards.isEmpty || collectionEdit {
                                fetchSets()
                                fetchCollection()
                                collectionEdit = false
                            } else if num == 0 {
                                phrase = getRandomInteger()
                            } 
                        }
                    }
                }
                VStack {
                    if showCardDetail, let selectedCard = selectedCard {
                        PokemonCardInfo(
                            collectionEdit: $collectionEdit,
                            market: $market,
                            collection: $collection,
                            pokemonCard: selectedCard,
                            showLoginView: $showLoginView,
                            showRegisterView: $showRegisterView,
                            message: $message,
                            errorCode: $errorCode,
                            fault: $fault,
                            onDismiss: {
                                withAnimation(.easeInOut) {
                                    showCardDetail = false
                                }
                            }
                        )
                        .transition(.move(edge: .trailing))
                        .edgesIgnoringSafeArea(.all)
                        .zIndex(1)
                    }
                }
            } else {
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Image("snorlax")
                            .resizable()
                            .scaledToFit()
                            .shadow(color: .white, radius: 100)
                            .frame(height: geometry.size.height * 0.4)
                            .padding([.top, .bottom], -16)
                        GroupBox {
                            Text("Whoa There!")
                                .font(.title2)
                                .padding(.bottom, 1)
                            Text("To view/add to your very own card collection, please log in.")
                                .font(.title3)
                        }
                        Spacer()
                    }
                    .multilineTextAlignment(.center)
                    .bold()
                    Spacer()
                }
            }
        }
        .onAppear {
            if collectionEdit {
                phrase = 0
            }
            for serie in activeSeries.series {
                for set in serie.sets {
                    if shown[set.id] == nil {
                        shown[set.id] = true
                    }
                }
            }
        }
    }
    func fetchCollection() {
        isWaiting = true
        guard let url = URL(string: "\(Config.baseURL)/collection?user_id=\(user_id)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("HTTP Request Failed: \(error)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 204 {
                    DispatchQueue.main.async {
                        print("Error Code is 204 FOR COLLECTION")
                        print(collections)
                        edited = false
                        isWaiting = false
                    }
                } else {
                    if let data = data {
                        do {
                            let pokemonCard = try JSONDecoder().decode([PokemonCard].self, from: data)
                            DispatchQueue.main.async {
                                edited = true
                                collections.cards = pokemonCard
                                isWaiting = false
                            }
                        } catch {
                            print("Error converting data to JSON: \(error)")
                        }
                    }
                }
            }
        }.resume()
    }
    func fetchSets() {
        isLoading = true
        guard let url = URL(string: "\(Config.baseURL)/sets?user_id=\(user_id)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("HTTP Request Failed: \(error)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 204 {
                    DispatchQueue.main.async {
                        print("Error Code is 204 FOR SETS (SAME SETS)")
                    }
                } else {
                    if let data = data {
                        do {
                            let series = try JSONDecoder().decode([Series].self, from: data)
                            DispatchQueue.main.async {
                                
                                phrase = 0
                                activeSeries.series = series
                                isLoading = false
                            }
                        } catch {
                            do {
                                let preCheck = try JSONDecoder().decode(Int.self, from: data)
                                DispatchQueue.main.async {
                                    phrase = preCheck
                                    isLoading = false
                                }
                            } catch {
                                print("Error converting data to JSON: \(error)")
                            }
                        }
                    }
                }
            }
        }.resume()
    }
    func total() -> Double {
        let priceTypes = [
            "normal",
            "holofoil",
            "firstEditionHolofoil",
            "firstEditionNormal",
            "reverseHolofoil"
        ]
        var total = 0.0
        
        for card in collections.cards {
            for type in priceTypes {
                if let price = card.tcgPricesMarket[type] {
                    if let num = price {
                        total += num
                    }
                    break
                }
            }
        }
        return total
    }
    func fetchCount(completion: @escaping (Int) -> Void) {
        if user_id == 0 {
            print("No user ID provided")
            return
        }
        
        let urlString = "\(Config.baseURL)/count?user_id=\(user_id)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    let num = try JSONDecoder().decode(Int.self, from: data)
                    DispatchQueue.main.async {
                        completion(num)
                    }
                } catch {
                    print("Error converting data to JSON: \(error)")
                }
            }
        }.resume()
    }
}

func extract(from number: String) -> Int? {
    var new = ""
    for char in number {
        if char.wholeNumberValue != nil {
            new.append(char)
        }
    }
    if let num = Int(new) {
        return num
    }
    return nil
}

func getRandomInteger() -> Int {
    return Int.random(in: 1...5)
}

#Preview {
    CollectionTabView(collectionEdit: .constant(false), collection: .constant([PokemonCard(
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
    ]), selectedCard: .constant(nil), market: .constant("0.55 USD"), showLoginView: .constant(true), showRegisterView: .constant(false), message: .constant("OK"), errorCode: .constant("Status Code: 200"), fault: .constant(false))
        .environmentObject(cards())
        .environmentObject(series())
}
