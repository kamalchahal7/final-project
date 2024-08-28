//
//  ContentView.swift
//  pokedata
//
//  Created by Kamal on 2024-08-02.
//

import SwiftUI



struct Pokemon: Decodable, Identifiable {
    let id: Int
    let pokedex_num: Int
    let name: String
    let jap_name: String
    let generation: Int
    let status: String
    let species: String
    let type_num: Int
    let type_1: String
    let type_2: String
    let height_m: Float
    let weight_kg: Float?
    let abilities_num: Int
    let ability_1: String
    let ability_2: String
    let ability_hidden: String
    let stat_total: Int
    let hp: Int
    let attack: Int
    let defense: Int
    let sp_attack: Int
    let sp_defense: Int
    let speed: Int
    let catch_rate: Int?
    let base_friendship: Int?
    let base_exp: Int?
    let growth_rate: String?
    let egg_type_num: Int
    let egg_type_1: String
    let egg_type_2: String
    let percent_male: Float?
    let egg_cycles: Int?
    let against_normal: Float
    let against_fire: Float
    let against_water: Float
    let against_electric: Float
    let against_grass: Float
    let against_ice: Float
    let against_fight: Float
    let against_poison: Float
    let against_ground: Float
    let against_flying: Float
    let against_psychic: Float
    let against_bug: Float
    let against_rock: Float
    let against_ghost: Float
    let against_dragon: Float
    let against_dark: Float
    let against_steel: Float
    let against_fairy: Float
}

struct PokemonCard: Decodable, Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let supertype: String
    let subtypes: [String]?
    let hp: String?
    let types: [String]?
    let evolvesFrom: String?
    let rules: [String]?
    
    let ancientTraitName: String?
    let ancientTraitText: String?
    
    let abilitiesName: [String]?
    let abilitiesText: [String]?
    let abilitiesType: [String]?
    
    let attacksCost: [String]?
    let attacksName: [String]?
    let attacksText: [String]?
    let attacksDamage: [String?]?
    let attacksConvertedEnergyCost: [Int]?
    
    let weaknessType: String?
    let weaknessValue: String?
    
    let resistanceType: String?
    let resistanceValue: String?
    
    let retreatCost: [String]?
    let convertedRetreatCost: Int?
    
    let number: String
    let artist: String?
    let rarity: String?
    let flavorText: String?
    let nationalPokedexNumbers: [Int]?
    
    let legalitiesStandard: String?
    let legalitiesExpanded: String?
    let legalitiesUnlimited: String?
    
    let regulationMark: String?
    let lowImageURL: String
    let highImageURL: String
    let tcgURL: String?
    let tcgUpdatedAt: String
    
    let tcgPricesType: [String: String?]
    let tcgPricesLow: [String: Double?]
    let tcgPricesMid: [String: Double?]
    let tcgPricesHigh: [String: Double?]
    let tcgPricesMarket: [String: Double?]
    let tcgPricesDirectLow: [String: Double?]
    
    let setId: String
    let setName: String
    let setSeries: String
    let setPrintedTotal: Int
    let setTotal: Int
    
    let setLegalitiesStandard: String?
    let setLegalitiesExpanded: String?
    let setLegalitiesUnlimited: String?
    
    let setPtcgoCode: String?
    let setReleaseDate: String?
    let setUpdatedAt: String?
    
    let setImagesSymbol: String?
    let setImagesLogo: String?
}

struct UserInfo: Decodable, Identifiable, Hashable {
    let id: Int
    let username: String
    let email: String
    let first_name: String
    let last_name: String
    let date_of_birth: String
    let registration_time_EST: String
    let collection: Int
}


struct ContentView: View {
    // Global user id
    @AppStorage("user_id") var user_id: Int?
    // Inputed Data on Search Tab Bar
    @State private var pokedata: String = ""
    // Inputed Data on Cards Tab Bar
    @State private var pokecard: String = ""
    // Returned Data from pokedata.db
    @State private var fetchedData: [Pokemon] = []
    // Returned Data from TCG API
    @State private var cardData: [PokemonCard] = []
    // Returned Data from accounts.db
    @State private var userData = UserInfo(id: 0, username: "", email: "", first_name: "", last_name: "", date_of_birth: "", registration_time_EST: "", collection: 0)
    // Initial Tab
    @State private var selectedTab = 4
    // Checks if search bar is active or not
    @State private var isSearchActive: Bool = false
    // Checks if someone has submitted a search
    // Checks if search bar is active or not
    @State private var search: Bool = false
    // Checks if input field is in focus or not
    @FocusState private var isSearchFieldFocused: Bool
    // Background for Search Bar
//    @State private var offsetY: CGFloat = -UIScreen.main.bounds.height
    // Checks if it is the first time searching
//    @State private var isFirstTime = true
    // Used for selected pokemon
    @State private var selected: Pokemon? = nil
    // Used for selected card
    @State private var selectedCard: PokemonCard? = nil
    // Checks if view should be shown or not
    @State private var showDetail = false
    // Checks if card view should be shown or not
    @State private var showCardDetail = false
    // Checks if collection view should be shown or not
    @State private var showCollectionDetail = false
    // Returned Data from python image database
    @State private var pokemonImages: [String: UIImage] = [:]
    // Checks if search view is shown or not
    @State private var hasAnimated = false
    // Holds the market value of each card
//    @State private var marketPrices: [String] = []
    // Holds market value of selected card
    @State private var market: String = ""
    // holds all the collected pokemon cards
    @State private var collection: [PokemonCard] = []
    // holds the inputted username
    @State private var username: String = "kamal7"
    // holds inputtted password
    @State private var password: String = ""
    // Checks whether registerview should be shown or not
    @State private var showRegisterView = false
    // Checks whether loginview should be shown or not
    @State private var showLoginView = true
    // Checks whether personalview should be shown or not
    @State private var showPersonalView = false
    // Checks whether passwordchangeview should be shown or not
    @State private var showPasswordChangeView = false
    // Checks whether historyview should be shown or not
    @State private var showHistoryView = false
    // Checks whether creditsview should be shown or not
    @State private var showCreditsView = false
    // backend error message
    @State private var message: String = ""
    // backend error code
    @State private var errorCode: String = ""
    // checks if backend pciked up a fault
    @State private var fault: Bool = false
    
//    init() {
//            setupNavigationBarAppearance()
//        }
    
    var body: some View {
        
        // Header
        
//        Image(systemName: "globe")
//            .imageScale(.large)
//            .foregroundStyle(.tint)
//        Text("Hello World")
//        Image(systemName: "house")
        
        // Footer
       
        // SEARCH TAB BAR
        TabView (selection: $selectedTab){
            GeometryReader { geometry in
                ZStack {
                    // Background that slides in
//                    let safeAreaTop = geometry.safeAreaInsets.top
//                    var heightMultiplier = 0.0
//                    var offsetMultiplier = 0.0
//
//                    if isSearchActive {
//
//                        if safeAreaTop > 25 {
//                            heightMultiplier = 0.17
//                            offsetMultiplier = 0.1
//                        } else if safeAreaTop > 20 {
//                            heightMultiplier = 0.17
//                            offsetMultiplier = 0.1
//                        } else {
//                            heightMultiplier = 0.29
//                            offsetMultiplier = 0.15
//                        }
                    if isSearchActive {
                        let isNotchDevice = geometry.safeAreaInsets.top > 20
                        let heightMultiplier = isNotchDevice ? 0.17 : 0.29
                        let offsetMultiplier = isNotchDevice ? 0.1 : 0.15

                        Rectangle()
                            .foregroundColor(Color.white.opacity(0.5))
                            .frame(height: geometry.safeAreaInsets.top + (geometry.size.height * heightMultiplier))
                            .offset(y: -geometry.size.height * offsetMultiplier)
                            .transition(.move(edge: .top))
                            .animation(.easeInOut(duration: 1.0), value: isSearchActive)
                    }
                    
                }
                .opacity(showDetail ? 0 : 1)
                
                VStack {
                    if !isSearchActive && !showDetail { Spacer() }
                    if !isSearchActive {
                        Image("pokeball")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    // ZStack for the search bar
                    ZStack(alignment: .leading) {
                        if !showDetail {
                            if isSearchActive {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 1.0)) {
                                        isSearchActive.toggle()
                                        hasAnimated = false
                                        isSearchFieldFocused = false
                                    }
                                }) {
                                    Image(systemName: "chevron.backward")
                                    
                                        .font(.system(size: 35, weight: .bold))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                // .transition(.move(edge: .bottom))
                            }
                            Group {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 20, weight: .bold))
                                    .padding(.leading, 20)
                                    .zIndex(1.0)
                                    .padding(.leading, isSearchActive ? geometry.size.width * 0.1 : 0)
                                
                                TextField("Search Pokemon:", text: $pokedata, onEditingChanged: { editing in
                                    if editing && !hasAnimated {
                                        withAnimation {
                                            isSearchActive = true
                                        }
                                        hasAnimated = true
                                    }
                                })
                                .font(.system(size: 25, weight: .medium))
                                .focused($isSearchFieldFocused)
                                .autocapitalization(.none)
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
                                .onAppear {
                                    withAnimation(.easeInOut) {
                                        // Trigger the animation
//                                        fetchPokedata()
                                    }
                                    
                                }
                                .onChange(of: pokedata) {
//                                    if pokedata.isEmpty {
//                                        fetchPokedata()
//                                    }
//                                    else {
                                        submitPokedata()
//                                    }
                                }
                                .padding(.leading, isSearchActive ? geometry.size.width * 0.1 : 0)
                            }
                        }
                    }
                    .animation(.easeInOut(duration: 0.5), value: isSearchActive)
                    .animation(.easeInOut(duration: 0.00000001), value: !showDetail)
                    
                    if !isSearchActive {
                        Text("Enter Pokemon Name or Pokedex #")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                            .padding(7)
                    }
                    
                    if isSearchActive {
                        if !showDetail {
                            Spacer()
                                .frame(height: geometry.size.height * 0.02)
                        }
                        ZStack {
                            VStack {
                                List(fetchedData, id: \.id) { pokemon in
                                    Button(action: {
                                        withAnimation(.easeInOut) {
                                            selected = pokemon
                                            showDetail = true
                                        }
                                    }) {
                                        HStack {
                                            if let image = pokemonImages[pokemon.name] {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(minWidth: 25, idealWidth: 50, maxWidth: 50, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
                                            }
                                            Text(String(format: "#%04d", pokemon.pokedex_num))
                                                .font(.system(size: 20))
                                                .padding(.leading, 10)
                                            Text(pokemon.name)
                                                .font(.system(size: 20))
                                                .fontWeight(.heavy)
                                        }
                                        .foregroundColor(Color.purple)
                                        .onAppear {
                                            fetchImage(for: pokemon)
                                        }
                                        
                                    }
                                }
                                .scrollContentBackground(.hidden)
                                .padding(.horizontal, -16)
                            }
                            
                            // Overlay detail view when an item is selected
                            if showDetail, let selectedPokemon = selected, let selectedImage = pokemonImages[selectedPokemon.name] {
                                PokemonInfo(selectedImage: selectedImage, pokemon: selectedPokemon, onDismiss: {
                                    withAnimation(.easeInOut) {
                                        showDetail = false
                                    }
                                })
                                .transition(.move(edge: .trailing))
                                .edgesIgnoringSafeArea(.all)
                                .zIndex(1)
                            }
                        }

                        
                                                    
                        
                        
                            
                            // Hide default background
                            
                            
                        
                        
                        
//                        ForEach(fetchedData, id: \.id) { pokemon in
//                            Text("Name: \(pokemon.name), Pokedex Number: \(pokemon.pokedex_num)")
//                        }
//                        .padding(2)
                        
                            
                            //                        if fetchedData.isEmpty {
                            //                            if is2ndTime {
                            //                                Text("No Results Found")
                            //                            }
                            //                        }
                        
                    }
                    
                    
                    if !isSearchActive { Spacer() }
                }
                .padding(showDetail ? 0 : 16)
            }
            .background(Color(red: 0.82, green: 0.71, blue: 0.55).edgesIgnoringSafeArea(.all))
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .onAppear() {
                UITabBar.appearance().backgroundColor = .white
            }
            .tag(0)
            
            
            // CARDS TAB BAR
            GeometryReader { geometry in
                ZStack {
                    // Background that slides in
//                    let safeAreaTop = geometry.safeAreaInsets.top
//                    var heightMultiplier = 0.0
//                    var offsetMultiplier = 0.0
//
//                    if isSearchActive {
//
//                        if safeAreaTop > 25 {
//                            heightMultiplier = 0.17
//                            offsetMultiplier = 0.1
//                        } else if safeAreaTop > 20 {
//                            heightMultiplier = 0.17
//                            offsetMultiplier = 0.1
//                        } else {
//                            heightMultiplier = 0.29
//                            offsetMultiplier = 0.15
//                        }
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
                                // .transition(.move(edge: .bottom))
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
                                    .onAppear {
                                        withAnimation(.easeInOut) {
                                            // Trigger the animation
                                        }
                                        
                                    }
                                    .onSubmit {
    //                                    if pokecard.!isEmpty {
    //                                        submitPokecard()
    //                                    }
                                        search = true
                                        submitPokecard()
                                    }
                                    .padding(.leading, search ? geometry.size.width * 0.1 : 0)
                            }
                        }
                    }
                    .animation(.easeInOut(duration: 0.5), value: search)
                    .animation(.easeInOut(duration: 0.00000001), value: !showCardDetail)
                    
                    if !search {
                        HStack {
                            Button(action: {
                                withAnimation(.easeInOut) {
                                }
                            }) {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                    Text("Upload")
                                }
                                .frame(height: 27)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            Button(action: {
                                withAnimation(.easeInOut) {
                                }
                            }) {
                                HStack {
                                    Image(systemName: "camera")
                                    Text("Capture")
                                }
                                .frame(height: 27)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.pink)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                        }
                        .padding(.top, 10)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                    }
                    
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
                                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                                Text("\(pokemoncard.setSeries) - \(pokemoncard.setName)")
                                                    .font(.system(size: 15))
                                                    .padding(.bottom, 1)
                                                Text("Market Price: ")
                                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                                + Text(marketPrice)
                                                    .fontWeight(.semibold)
                                                    .foregroundStyle(Color(red: 0.0, green: 0.5, blue: 0.0))
                                            }
                                            .padding(.leading)
                                        }
                                    }
                                }
                                .scrollContentBackground(.hidden)
                                .foregroundStyle(Color.black)
                                .padding(.horizontal, -16)
                            }

                            if showCardDetail, let selectedCard = selectedCard {
                                PokemonCardInfo(market: $market, collection: $collection, pokemonCard: selectedCard, onDismiss: {
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
            .background(Color(red: 0.82, green: 0.71, blue: 0.55).edgesIgnoringSafeArea(.all))
            .tabItem {
                Label("Cards", systemImage: "doc.text.magnifyingglass")
            }
            .tag(1)
            
            // HISTORY TAB BAR (may get rid of this)
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    
                    
                    Spacer()
                }
            
            }
            .padding()
            .background(Color(red: 0.82, green: 0.71, blue: 0.55).edgesIgnoringSafeArea(.all))
                
                
                .tabItem {
                    Label("History", systemImage: "gobackward")
                }
                .tag(2)
        
            // COLLECTION TAB BAR
            GeometryReader { geometry in
                ZStack {
                    // Background that slides in
//                    let safeAreaTop = geometry.safeAreaInsets.top
//                    var heightMultiplier = 0.0
//                    var offsetMultiplier = 0.0
//
//                    if isSearchActive {
//
//                        if safeAreaTop > 25 {
//                            heightMultiplier = 0.17
//                            offsetMultiplier = 0.1
//                        } else if safeAreaTop > 20 {
//                            heightMultiplier = 0.17
//                            offsetMultiplier = 0.1
//                        } else {
//                            heightMultiplier = 0.29
//                            offsetMultiplier = 0.15
//                        }
                    
                    let isNotchDevice = geometry.safeAreaInsets.top > 20
                    let heightMultiplier = isNotchDevice ? 0.135 : 0.25
                    let offsetMultiplier = isNotchDevice ? 0.1 : 0.15

                    Rectangle()
                        .foregroundColor(Color.blue.opacity(0.7))
                        .frame(height: geometry.safeAreaInsets.top + (geometry.size.height * heightMultiplier))
                        .offset(y: -geometry.size.height * offsetMultiplier)
                        .transition(.move(edge: .top))
                        .animation(.easeInOut(duration: 1.0), value: search)
                    
                    
                }
                
                VStack {
                    if !showCollectionDetail {
                        HStack {
                            Spacer()
                            Text("Collection")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundStyle(Color.white)
                                .shadow(color: .black, radius: 3)
                                .onAppear {
                                    print(collection)
                                }
                            Spacer()
                            
                        }
                        .padding(.bottom, 28)
                        
                        
                        if !collection.isEmpty {
                            let rows = collection.chunked(into: 7)
                            ForEach(rows, id: \.self) { row in
                                HStack {
                                    ForEach(row, id: \.id) { pokemonCard in
                                        Button(action: {
                                            withAnimation(.easeInOut) {
                                                selectedCard = pokemonCard
                                                market = calculateMarketPrice(for: pokemonCard)
                                                showCollectionDetail = true
                                            }
                                        }) {
                                            AsyncImage(url: URL(string: pokemonCard.lowImageURL)) { image in
                                                image.resizable().scaledToFit().shadow(color: .white, radius: 2.5).frame(height: geometry.size.width * 0.18)
                                            } placeholder: {
                                                Text("Image of Pokemon Card")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if showCollectionDetail, let selectedCard = selectedCard {
                        PokemonCardInfo(market: $market, collection: $collection, pokemonCard: selectedCard, onDismiss: {
                            withAnimation(.easeInOut) {
                                showCollectionDetail = false
                            }
                        })
                        .transition(.move(edge: .trailing))
                        .edgesIgnoringSafeArea(.all)
                        .zIndex(1)
                    }
                    
                    
                    
                    
                    //                    Image("collection1")
                    //                        .resizable()
                    //                        .aspectRatio(contentMode: .fit)
                    //                        .padding(.bottom)
                    //
                    //                    Button(action: {
                    //                        withAnimation(.easeInOut) {
                    //                        }
                    //                    }) {
                    //                        HStack {
                    ////                            Image(systemName: "camera")
                    //                            Text("Pokemon Go Collection")
                    //                        }
                    //                        .frame(height: 27)
                    //                    }
                    //                    .padding()
                    //                    .frame(maxWidth: .infinity)
                    //                    .background(Color.pink)
                    //                    .cornerRadius(10)
                    //                    .overlay(
                    //                        RoundedRectangle(cornerRadius: 10)
                    //                            .stroke(Color.black, lineWidth: 2)
                    //                    )
                    //
                    //                    Button(action: {
                    //                        withAnimation(.easeInOut) {
                    //                        }
                    //                    }) {
                    //                        HStack {
                    ////                            Image(systemName: "camera")
                    //                            Text("Pokemon Card Collection")
                    //                        }
                    //                        .frame(height: 27)
                    //                    }
                    //                    .padding()
                    //                    .frame(maxWidth: .infinity)
                    //                    .background(Color.green)
                    //                    .cornerRadius(10)
                    //                    .overlay(
                    //                        RoundedRectangle(cornerRadius: 10)
                    //                            .stroke(Color.black, lineWidth: 2)
                    //                    )
                    
                    
                    if !showCollectionDetail { Spacer() }
                }
                .padding(showCollectionDetail ? 0 : 16)
            }
            .background(Color(red: 0.82, green: 0.71, blue: 0.55).edgesIgnoringSafeArea(.all))
            .tabItem {
                Label("Collection", systemImage: "square.on.square")
            }
            .tag(3)
//            NavigationStack {
//                Text("<Collection>")
//                    .navigationTitle("Collection")
//                    .toolbar {
//                        ToolbarItem (placement: .topBarLeading) {
//                            Text("PokeData")
//                        }
//                        ToolbarItem(placement: .topBarTrailing) {
//                            Button(action: {
//                                //todo
//                            }, label: {
//                                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
//                            })
//                        }
//                    }
//            }
//            .background(Color(red: 0.82, green: 0.71, blue: 0.55).edgesIgnoringSafeArea(.all))

                
            
            // PROFILE TAB BAR
            GeometryReader { geometry in
//                let isNotchDevice = geometry.safeAreaInsets.top
                VStack {
                    if user_id == nil {
                        if showLoginView {
                            LoginView(showLoginView: $showLoginView, showRegisterView: $showRegisterView, message: $message, errorCode: $errorCode, fault: $fault)
                        }
                        if showRegisterView {
                            RegisterView(showLoginView: $showLoginView, showRegisterView: $showRegisterView, message: $message, errorCode: $errorCode, fault: $fault)
//                                .padding(.top, isNotchDevice > 25 ? 35 : 0)
                        }
                    }
                    else {
                        ZStack {
                            if showPersonalView {
                                PersonalView(showLoginView: $showLoginView, showRegisterView: $showRegisterView, userData: $userData, message: $message, errorCode: $errorCode, fault: $fault, onDismiss: {
                                    withAnimation(.easeInOut) {
                                        showPersonalView.toggle()
                                    }
                                })
                                .transition(.move(edge: .trailing))
                                .edgesIgnoringSafeArea(.all)
                            } else if showPasswordChangeView {
                                PasswordChangeView(onDismiss: {
                                    withAnimation(.easeInOut) {
                                        showPasswordChangeView.toggle()
                                    }
                                })
                                .transition(.move(edge: .trailing))
                                .edgesIgnoringSafeArea(.all)
                                
                            } else if showHistoryView {
                                HistoryView(onDismiss: {
                                    withAnimation(.easeInOut) {
                                        showHistoryView.toggle()
                                    }
                                })
                                .transition(.move(edge: .trailing))
                                .edgesIgnoringSafeArea(.all)
                                
                            } else if showCreditsView {
                                CreditsView(onDismiss: {
                                    withAnimation(.easeInOut) {
                                        showCreditsView.toggle()
                                    }
                                })
                                .transition(.move(edge: .trailing))
                                .edgesIgnoringSafeArea(.all)
                                
                            } else {
                                ProfileTabView(showLoginView: $showLoginView, showPersonalView: $showPersonalView, showPasswordChangeView: $showPasswordChangeView, showHistoryView: $showHistoryView, showCreditsView: $showCreditsView, userData: $userData, collectionCount: $collection.count)
                                    .onAppear {
                                        fetchUserData()
                                    }
                            }
                        }
                    }
                }
                .padding(showRegisterView || showPersonalView ? 0 : 16)
            }
            .background(Color(red: 0.82, green: 0.71, blue: 0.55).edgesIgnoringSafeArea(.all))
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
            .tag(4)
        }
        
        // Changes Colour of Tab Bar
        .onAppear() {
            UITabBar.appearance().backgroundColor = .white
        }
        // Changes Colour of the Tab Bar Font
        
    }
    
//    private func setupNavigationBarAppearance() {
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithTransparentBackground()
//            appearance.backgroundColor = .clear // Set background color to clear
//            appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Customize title color if needed
//            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // Customize large title color if needed
//            
//            UINavigationBar.appearance().standardAppearance = appearance
//            UINavigationBar.appearance().scrollEdgeAppearance = appearance
//            UINavigationBar.appearance().compactAppearance = appearance
//            UINavigationBar.appearance().tintColor = .clear // Customize tint color if needed
//    }

    
    
    func submitPokedata() {
            guard let url = URL(string: "http://127.0.0.1:5000/") else {
                print("Invalid URL")
                return
            }

            var request = URLRequest(url: url)
        
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let bodyData = "pokedata=\(pokedata)"
            request.httpBody = bodyData.data(using: .utf8)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let pokemonArray = try JSONDecoder().decode([Pokemon].self, from: data)
                        DispatchQueue.main.async {
                            fetchedData = pokemonArray
                        }
                    } catch {
                        print("Error converting data to JSON: \(error)")
                        DispatchQueue.main.async {
                            fetchedData = []
                        }
                    }
                } else if let error = error {
                    print("HTTP Request Failed \(error)")
                }
            }.resume()
        }
    
    func fetchImage(for pokemon: Pokemon) {
        guard let imageUrl = URL(string: "http://127.0.0.1:5000/images/\(pokemon.name)_new.png") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    self.pokemonImages[pokemon.name] = UIImage(data: data)
                }
            }
        }.resume()
    }
    
    func submitPokecard() {
        guard let url = URL(string: "http://127.0.0.1:5000/cards") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // You need to make sure pokecard is properly formatted to be URL encoded
        let bodyData = "pokecard=\(pokecard)"
        request.httpBody = bodyData.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
//                    // Print the raw JSON data as a string
//                    let jsonString = String(data: data, encoding: .utf8)
//                    print("Received JSON: \(String(describing: jsonString))")
                    
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
    
    func fetchUserData() {
        guard let userId = user_id else {
            print("No user ID provided")
            return
        }
        
        let urlString = "http://127.0.0.1:5000/profile?user_id=\(userId)"
        
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
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if httpResponse.statusCode >= 400 {
                DispatchQueue.main.async {
                    // FIX THIS PELAESEESAESAESAEESEESEEEESESESE
                    print("SUM TING WONG")
                    print("VEE TOO LOW")
                    print("HOE LEE FUQ")
                    print("BANG DING OW")
    //                message = String(data: data, encoding: .utf8) ?? "No response"
    //                errorCode = "\(httpResponse.statusCode)"
    //                fault = true
    //                completion(fault)
                }
            } else if let data = data {
                print("Data: \(String(data: data, encoding: .utf8) ?? "No data")")
                if let response = response {
                    print("Response: \(response)")
                } else {
                    print("No response")
                }
                do {
                    let info = try JSONDecoder().decode([UserInfo].self, from: data)
                    DispatchQueue.main.async {
                        if let user = info.first {
                            userData = user
                        }
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
//    func calculateMultipliers(safeAreaTop: CGFloat) -> (Double, Double) {
//        if safeAreaTop > 25 {
//            // notch iphone
//            return (0.164, 0.1)
//        } else if safeAreaTop > 20 {
//            // ipad
//            return (0.178, 0.1)
//        } else {
//            // touch id iphone
//            return (0.29, 0.15)
//        }
//    }
    
    private func calculateMarketPrice(for pokemoncard: PokemonCard) -> String {
        let error = "N/A"
        let priceTypes = [
            "normal",
            "holofoil",
            "firstEditionHolofoil",
            "firstEditionNormal",
            "reverseHolofoil"
        ]
        
        for type in priceTypes {
            if let price = pokemoncard.tcgPricesMarket[type], let unwrappedPrice = price {
                return String(format: "%.2f USD", unwrappedPrice)
            }
        }
        
        return error
    
//        let error = "No Market Price Available"
//        if let normalPrice = pokemoncard.tcgPricesMarket["normal"] {
//            if let price = normalPrice {
//                return String(format: "$%.2f USD", normalPrice!)
//            }
//            else if let holofoilPrice = pokemoncard.tcgPricesMarket["holofoil"] {
//                if let price = holofoilPrice {
//                    return String(format: "$%.2f USD", holofoilPrice!)
//                }
//                else if let firstEditionHolofoilPrice = pokemoncard.tcgPricesMarket["firstEditionHolofoil"] {
//                    if let price = firstEditionHolofoilPrice {
//                        return String(format: "$%.2f USD", firstEditionHolofoilPrice!)
//                    }
//                    else if let firstEditionNormalPrice = pokemoncard.tcgPricesMarket["firstEditionNormal"] {
//                        if let price = firstEditionNormalPrice {
//                            return String(format: "$%.2f USD", firstEditionNormalPrice!)
//                        }
//                       else if let reverseHolofoilPrice = pokemoncard.tcgPricesMarket["reverseHolofoil"] {
//                            if let price = reverseHolofoilPrice {
//                                return String(format: "$%.2f USD", reverseHolofoilPrice!)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        return error
        
    }
    
    
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

#Preview {
    ContentView()
}

// Handling Validation and Submission Logic

//                    @State private var pokedata: String = ""
//                    @State private var isValid: Bool = true
//
//                    VStack {
//                        TextField("Search Pokemon:", text: $pokedata)
//                            .onChange(of: pokedata) { newValue in
//                                // Add validation logic here
//                                isValid = !newValue.isEmpty
//                            }
//                        Button("Submit") {
//                            if isValid {
//                                // Perform submission action
//                            } else {
//                                // Handle invalid input
//                            }
//                        }
//                    }


//// MARK: - Main Card Struct
//struct PokemonCard: Codable, Identifiable {
//    let abilities: [Ability]?
//    let artist: String
//    let ancientTrait: AncientTrait? // Updated: hash with properties name and text
//    let attacks: [Attack]?
//    let convertedRetreatCost: Int
//    let evolvesFrom: String?
//    let flavorText: String
//    let hp: String
//    let id: String
//    let images: CardImages
//    let legalities: Legalities
//    let regulationMark: String? // Updated: string
//    let name: String
//    let nationalPokedexNumbers: [Int]
//    let number: String
//    let rarity: String
//    let resistances: [Resistance]? // Updated: list of hashes
//    let retreatCost: [String]
//    let rules: [String]? // Updated: list of strings
//    let set: CardSet
//    let subtypes: [String]
//    let supertype: String
//    let tcgplayer: TCGPlayer?
//    let types: [String]
//    let weaknesses: [Weakness]
//}
//
//// MARK: - AncientTrait Struct (Updated)
//struct AncientTrait: Codable {
//    let name: String
//    let text: String
//}
//
//// MARK: - Ability Struct
//struct Ability: Codable {
//    let name: String
//    let text: String
//    let type: String
//}
//
//// MARK: - Attack Struct
//struct Attack: Codable {
//    let name: String
//    let cost: [String]
//    let convertedEnergyCost: Int
//    let damage: String
//    let text: String
//}
//
//// MARK: - Weakness Struct
//struct Weakness: Codable {
//    let type: String
//    let value: String
//}
//
//// MARK: - Resistance Struct (Updated)
//struct Resistance: Codable {
//    let type: String
//    let value: String
//}
//
//// MARK: - CardSet Struct
//struct CardSet: Codable {
//    let id: String
//    let name: String
//    let series: String
//    let printedTotal: Int
//    let total: Int
//    let legalities: Legalities
//    let ptcgoCode: String
//    let releaseDate: String
//    let updatedAt: String
//    let images: SetImages
//}
//
//// MARK: - Legalities Struct
//struct Legalities: Codable {
//    let unlimited: String
//    let standard: String
//    let expanded: String
//}
//
//// MARK: - CardImages Struct
//struct CardImages: Codable {
//    let small: String
//    let large: String
//}
//
//// MARK: - SetImages Struct
//struct SetImages: Codable {
//    let symbol: String
//    let logo: String
//}
//
//// MARK: - TCGPlayer Struct
//struct TCGPlayer: Codable {
//    let url: String
//    let updatedAt: String
//    let prices: Prices
//}
//
//// MARK: - Prices Struct (TCGPlayer)
//struct Prices: Codable {
//    let normal: PriceDetails?
//    let reverseHolofoil: PriceDetails?
//}
//
//// MARK: - PriceDetails Struct
//struct PriceDetails: Codable {
//    let low: Double?
//    let mid: Double?
//    let high: Double?
//    let market: Double?
//    let directLow: Double?
//}


// alternate form for search screen
//GeometryReader { geometry in
//    ZStack {
//        // Background that slides in
//        if isSearchActive {
//            Rectangle()
//            // change opacity to whatever u want
//                .foregroundColor(Color.white.opacity(0.5))
//                .frame(height: geometry.size.height * 0.46)
//                .offset(y: -geometry.size.height * 0.3)
//                .transition(.move(edge: .top))
//                .animation(.easeInOut(duration: 1.0), value: isSearchActive)
//        }
//    }
//    VStack {
//        Spacer()
//        if !isSearchActive {
//            Image("pokeball")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//        }
//        // ZStack for the button
//        ZStack {
//            if isSearchActive {
//                Button(action: {
//                    withAnimation(.easeInOut(duration: 1.0)) {
//                        isSearchActive.toggle()
//                        isSearchFieldFocused = false
//                    }
//                }) {
//                    Image(systemName: "chevron.backward")
//                        .font(.system(size: 35, weight: .bold))
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)
//            }
//        }
//        .offset(y: isSearchActive ? -geometry.size.height * 0.385 : 0)
//        .animation(.easeInOut(duration: 0.5), value: isSearchActive)
//
//        // ZStack for the search bar
//        ZStack(alignment: .leading) {
//            Image(systemName: "magnifyingglass")
//                .font(.system(size: 20, weight: .bold))
//                .padding(.leading, 20)
//                .zIndex(1.0)
//
//            TextField("Search Pokemon:", text: $pokedata, onEditingChanged: { editing in
//                withAnimation {
//                    isSearchActive = editing
//                }
//            })
//            .font(.system(size: 25, weight: .medium))
//            .focused($isSearchFieldFocused)
//            .autocapitalization(.none)
//            .padding(.leading, 40)
//            .padding()
//            .multilineTextAlignment(.leading)
//            .background(Color.white)
//            .cornerRadius(20)
//            .overlay(
//                RoundedRectangle(cornerRadius: 20)
//                    .stroke(Color.black, lineWidth: 3)
//            )
//            .transition(.move(edge: .top))
//            .onAppear {
//                withAnimation(.easeInOut) {
//                    // Trigger the animation
//                }
//            }
//            .onChange(of: pokedata) {
//                submitPokedata()
//            }
//        }
//        .padding(.leading, isSearchActive ? geometry.size.width * 0.1 : 0)
//        .offset(y: isSearchActive ? -geometry.size.height * 0.46 : 0)
//        .animation(.easeInOut(duration: 0.5), value: isSearchActive)
//        if !isSearchActive {
//            Text("Enter Pokemon Name or Pokedex #")
//                .foregroundColor(.white)
//                .font(.system(size: 20, weight: .bold))
//                .padding(5)
//        }
//
//
//        Spacer()
//    }
//    .padding()
//}
//.background(Color(red: 0.82, green: 0.71, blue: 0.55).edgesIgnoringSafeArea(.all))
//.tabItem {
//    Label("Profile", systemImage: "person.fill")
//}
//.tag(4)
//}
