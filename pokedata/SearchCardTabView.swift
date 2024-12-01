//
//  SearchCardTabView.swift
//  pokedata
//
//  Created by Kamal on 2024-11-30.
//

import SwiftUI

struct SearchCardTabView: View {
    // Checks if search bar is active or not
    @State private var search: Bool = false
    // Checks if search view is shown or not
    @State private var hasAnimated = false
    // Returned Data from TCG API
    @State private var cardData: [PokemonCard] = []
    // Inputed Data on Cards Tab Bar
    @State private var pokecard: String = ""
    // Checks if input field is in focus or not
    @FocusState private var isSearchFieldFocused: Bool
    // Checks if card view should be shown or not
    @Binding var showCardDetail: Bool
    // Used for selected card
    @Binding var selectedCard: PokemonCard?
    @Binding var collectionEdit: Bool
    @Binding var collection: [PokemonCard]
    @Binding var market: String
    @Binding var showLoginView: Bool
    @Binding var showRegisterView: Bool
    @Binding var message: String
    @Binding var errorCode: String
    @Binding var fault: Bool
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if search {
                    let isNotchDevice = geometry.safeAreaInsets.top > 20
                    let heightMultiplier = isNotchDevice ? 0.17 : 0.29
                    let offsetMultiplier = isNotchDevice ? 0.1 : 0.15
                    
                    Rectangle()
                        .foregroundColor(Color.white.opacity(0.5))
                        .frame(height: geometry.safeAreaInsets.top + (geometry.size.height * heightMultiplier))
                        .offset(y: -geometry.size.height * offsetMultiplier)
                        .transition(.move(edge: .top))
                        .animation(.easeInOut(duration: 1.0), value: search)
                }
                
            }
            .opacity(showCardDetail ? 0 : 1)
            
            VStack {
                if !search && !showCardDetail { Spacer() }
                if !search {
                    Image("pokeicon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding([.leading, .trailing])
                }
                
                ZStack(alignment: .leading) {
                    if !showCardDetail {
                        if search {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    search.toggle()
                                    hasAnimated = false
                                    isSearchFieldFocused = false
                                }
                            }) {
                                Image(systemName: "chevron.backward")
                                
                                    .font(.system(size: 35, weight: .bold))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Group {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 20, weight: .bold))
                                .padding(.leading, 20)
                                .zIndex(1.0)
                                .padding(.leading, search ? geometry.size.width * 0.1 : 0)
                            
                            TextField("Search PokeCard:", text: $pokecard)
                                .font(.system(size: 25, weight: .medium))
                                .focused($isSearchFieldFocused)
                                .autocapitalization(.none)
                                .autocorrectionDisabled(true)
                                .padding(.leading, 40)
                                .padding()
                                .multilineTextAlignment(.leading)
                                .background(Color.white)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black, lineWidth: 3)
                                )
                                .transition(.move(edge: .top))
                                .onSubmit {
                                    search = true
                                    submitPokecard()
                                }
                                .padding(.leading, search ? geometry.size.width * 0.1 : 0)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: search)
                .animation(.easeInOut(duration: 0.00000001), value: !showCardDetail)
                
                //  Future Implementation (CameraView):
                
                //                    if !search {
                //                        HStack {
                //                            Button(action: {
                //                                withAnimation(.easeInOut) {
                //                                    showPhotos = true
                //                                }
                //                            }) {
                //                                HStack {
                //                                    Image(systemName: "square.and.arrow.up")
                //                                    Text("Upload")
                //                                }
                //                                .frame(height: 27)
                //                            }
                //                            .padding()
                //                            .frame(maxWidth: .infinity)
                //                            .background(Color.green)
                //                            .cornerRadius(10)
                //                            .overlay(
                //                                RoundedRectangle(cornerRadius: 10)
                //                                    .stroke(Color.black, lineWidth: 2)
                //                            )
                //                            Button(action: {
                //                                guard !isCameraButtonDisabled else { return }
                //                                isCameraButtonDisabled = true // Disable button temporarily
                //
                //                                // Check if running on a real device or simulator, not in the preview
                //                                if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == nil {
                //                                    print("Clicked should work.")
                //                                    showCamera = true
                //                                } else {
                //                                    print("Camera not available in preview.")
                //                                }
                //
                //                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                //                                    isCameraButtonDisabled = false
                //                                }
                //                            }) {
                //                                HStack {
                //                                    Image(systemName: "camera")
                //                                    Text("Capture")
                //                                }
                //                                .frame(height: 27)
                //                            }
                //                            .padding()
                //                            .frame(maxWidth: .infinity)
                //                            .background(Color.pink)
                //                            .cornerRadius(10)
                //                            .overlay(
                //                                RoundedRectangle(cornerRadius: 10)
                //                                    .stroke(Color.black, lineWidth: 2)
                //                            )
                //                        }
                //                        .padding(.top, 10)
                //                        .foregroundColor(.white)
                //                        .font(.system(size: 20, weight: .bold))
                //                    }
                
                if search {
                    if !showCardDetail {
                        Spacer()
                            .frame(height: geometry.size.height * 0.02)
                    }
                    ZStack {
                        VStack {
                            List(cardData.indices, id: \.self) { index in
                                let pokemoncard = cardData[index]
                                
                                // Compute the market price inside the view builder
                                let marketPrice = calculateMarketPrice(for: pokemoncard)
                                
                                Button(action: {
                                    withAnimation(.easeInOut) {
                                        selectedCard = pokemoncard
                                        market = calculateMarketPrice(for: pokemoncard)
                                        showCardDetail = true
                                    }
                                }) {
                                    HStack {
                                        AsyncImage(url: URL(string: pokemoncard.lowImageURL)) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 200)
                                        } placeholder: {
                                            // Placeholder view (Optional)
                                            Color.gray.frame(height: 200)
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text(pokemoncard.name)
                                                .font(.system(size: 20))
                                                .fontWeight(.bold)
                                            Text("\(pokemoncard.setSeries) - \(pokemoncard.setName)")
                                                .font(.system(size: 15))
                                                .padding(.bottom, 1)
                                            Text("Market Price: ")
                                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                            + Text(marketPrice)
                                                .fontWeight(.semibold)
                                                .foregroundColor(Color(red: 0.0, green: 0.5, blue: 0.0))
                                        }
                                        .padding(.leading)
                                    }
                                }
                            }
                            .scrollContentBackground(.hidden)
                            .foregroundColor(Color.black)
                            .padding(.horizontal, -16)
                        }
                        
                        if showCardDetail, let selectedCard = selectedCard {
                            PokemonCardInfo(collectionEdit: $collectionEdit, market: $market, collection: $collection, pokemonCard: selectedCard, showLoginView: $showLoginView, showRegisterView: $showRegisterView, message: $message, errorCode: $errorCode, fault: $fault, onDismiss: {
                                withAnimation(.easeInOut) {
                                    showCardDetail = false
                                }
                            })
                            .transition(.move(edge: .trailing))
                            .edgesIgnoringSafeArea(.all)
                            .zIndex(1)
                        }
                    }
                }
                if !search { Spacer() }
            }
            .padding(showCardDetail ? 0 : 16)
        }
    }
    
    func submitPokecard() {
        guard let url = URL(string: "\(Config.baseURL)/cards") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyData = "pokecard=\(pokecard)"
        request.httpBody = bodyData.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let pokemonCard = try JSONDecoder().decode([PokemonCard].self, from: data)
                    DispatchQueue.main.async {
                        cardData = pokemonCard
                    }
                } catch {
                    print("Error converting data to JSON: \(error)")
                    DispatchQueue.main.async {
                        cardData = []
                    }
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }.resume()
    }
}

#Preview {
    SearchCardTabView(showCardDetail: .constant(true), selectedCard: .constant(nil), collectionEdit: .constant(false), collection: .constant([PokemonCard(
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
    ]), market: .constant("0.55 USD"), showLoginView: .constant(true), showRegisterView: .constant(false), message: .constant("OK"), errorCode: .constant("Status Code: 200"), fault: .constant(false))
}
