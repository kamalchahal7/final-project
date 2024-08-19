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

struct PokemonCard: Decodable, Identifiable {
    let id: String
    let name: String
    let supertype: String
    let subtypes: [String]
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
    let attacksDamage: [String]?
    let attacksConvertedEnergyCost: [Int]?
    
    let weaknessesType: [String]?
    let weaknessesValue: [String]?
    
    let resistancesType: [String]?
    let resistancesValue: [String]?
    
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
    let tcgUpdatedAt: String?
    
    let tcgPricesType: [String]?
    var tcgPricesLow: [String: Double?]
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


struct ContentView: View {
    // Inputed Data on Search Tab Bar
    @State private var pokedata: String = ""
    // Inputed Data on Cards Tab Bar
    @State private var pokecard: String = ""
    // Returned Data from pokedata.db
    @State private var fetchedData: [Pokemon] = []
    // Returned Data from TCG API
    @State private var cardData: [PokemonCard] = []
    // Initial Tab
    @State private var selectedTab = 1
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
    // Returned Data from python image database
    @State private var pokemonImages: [String: UIImage] = [:]
    // Checks if search view is shown or not
    @State private var hasAnimated = false

    
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
                .opacity(showDetail ? 0 : 1)
                
                VStack {
                    if !search && !showDetail { Spacer() }
                    if !search {
                        Image("pokeicon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding([.leading, .trailing])
                    }
                    
                    ZStack(alignment: .leading) {
                        if !showDetail {
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
                    .animation(.easeInOut(duration: 0.00000001), value: !showDetail)
                    
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
                        if !showDetail {
                            Spacer()
                                .frame(height: geometry.size.height * 0.02)
                        }
                        ZStack {
                            VStack {
                                List(cardData, id: \.id) { pokemoncard in
                                    Button(action: {
                                        withAnimation(.easeInOut) {
                                            selectedCard = pokemoncard
                                            showDetail = true
                                        }
                                    }) {
                                        
                                        AsyncImage(url: URL(string: pokemoncard.lowImageURL)) { image in
                                            image.resizable().scaledToFit().frame(height: 200)
                                        } placeholder: {
                                            //                                                ProgressView()
                                        }
                                        
                                        
                                        
                                    }
                                }
                                .scrollContentBackground(.hidden)
                                .padding(.horizontal, -16)
                            }
                            if showDetail, let selectedCard = selectedCard {
                                PokemonCardInfo(pokemonCard: selectedCard, onDismiss: {
                                    withAnimation(.easeInOut) {
                                        showDetail = false
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
                .padding(showDetail ? 0 : 16)
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

                            TextField("Search Pokemon:", text: $pokedata)
                                .font(.system(size: 25, weight: .medium))
                                .padding()
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .background(Color.white)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black, lineWidth: 3)
                                )
                                // Shrinks From the Right Instead of the Left
                                //.frame(width: isSearchActive ? geometry.size.width * 0.8 : geometry.size.width * 1.0)
                            
                                // Or Changing .leading --> .trailing Below Also Shrinks From the Right Instead of the Left \/
                                .padding(.leading, isSearchActive ? geometry.size.width * 0.1 : 0)
                                .offset(y: isSearchActive ? -geometry.size.height * 0.4 : 0)
                                .animation(.easeInOut(duration: 0.75), value: isSearchActive)

                            Button(action: {
                                withAnimation {
                                    isSearchActive.toggle()
                                }
                            }) {
                                Image(systemName: "chevron.backward")
                                    .padding()
                                    .background(Color.clear)
                                    .cornerRadius(10)
                                    .font(.system(size: 35, weight: .bold))
                            }
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
            NavigationStack {
                Text("<Collection>")
                    .navigationTitle("Collection")
                    .toolbar {
                        ToolbarItem (placement: .topBarLeading) {
                            Text("PokeData")
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                //todo
                            }, label: {
                                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                            })
                        }
                    }
            }
            .background(Color(red: 0.82, green: 0.71, blue: 0.55).edgesIgnoringSafeArea(.all))

                .tabItem {
                    Label("Collection", systemImage: "square.on.square")
                }
                .tag(3)
            
            // PROFILE TAB BAR
            GeometryReader { geometry in
                ZStack {
                    // Background that slides in
                    if isSearchActive {
                        Rectangle()
                        // change opacity to whatever u want
                            .foregroundColor(Color.white.opacity(0.5))
                            .frame(height: geometry.size.height * 0.46)
                            .offset(y: -geometry.size.height * 0.3)
                            .transition(.move(edge: .top))
                            .animation(.easeInOut(duration: 1.0), value: isSearchActive)
                    }
                }
                VStack {
                    Spacer()
                    if !isSearchActive {
                        Image("pokeball")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    // ZStack for the button
                    ZStack {
                        if isSearchActive {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    isSearchActive.toggle()
                                    isSearchFieldFocused = false
                                }
                            }) {
                                Image(systemName: "chevron.backward")
                                    .font(.system(size: 35, weight: .bold))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .offset(y: isSearchActive ? -geometry.size.height * 0.385 : 0)
                    .animation(.easeInOut(duration: 0.5), value: isSearchActive)

                    // ZStack for the search bar
                    ZStack(alignment: .leading) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.leading, 20)
                            .zIndex(1.0)

                        TextField("Search Pokemon:", text: $pokedata, onEditingChanged: { editing in
                            withAnimation {
                                isSearchActive = editing
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
                            }
                        }
                        .onChange(of: pokedata) {
                            submitPokedata()
                        }
                    }
                    .padding(.leading, isSearchActive ? geometry.size.width * 0.1 : 0)
                    .offset(y: isSearchActive ? -geometry.size.height * 0.46 : 0)
                    .animation(.easeInOut(duration: 0.5), value: isSearchActive)
                    if !isSearchActive {
                        Text("Enter Pokemon Name or Pokedex #")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                            .padding(5)
                    }
                    
                    
                    Spacer()
                }
                .padding()
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
                        print(fetchedData)
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
                    // Print the raw JSON data as a string
                    let jsonString = String(data: data, encoding: .utf8)
                    print("Received JSON: \(String(describing: jsonString))")
                    
                    let pokemonCard = try JSONDecoder().decode([PokemonCard].self, from: data)
                    DispatchQueue.main.async {
                        cardData = pokemonCard
                    }
                    print(cardData)
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

    
    
    
//    func fetchPokedata() {
//        guard let url = URL(string: "http://127.0.0.1:5000/") else {
//            print("Invalid URL")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let data = data {
//                do {
//                    let pokemonArray = try JSONDecoder().decode([Pokemon].self, from: data)
//                    DispatchQueue.main.async {
//                        fetchedData = pokemonArray
//                    }
//                    
//                } catch {
//                    print("Error converting data to JSON: \(error)")
//                    DispatchQueue.main.async {
//                        print("THERES SOMETHING WRONG")
//                        fetchedData = []
//                    }
//                }
//            }
//        }.resume()
//    }
    
    
    
    
    
    
    
    
    
    
    
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
//

//    func submitPokecard() {
//        guard let url = URL(string: "http://127.0.0.1:5000/cards") else {
//                print("Invalid URL")
//                return
//            }
//
//            var request = URLRequest(url: url)
//        
//            request.httpMethod = "POST"
//            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//            let bodyData = "pokecard=\(pokecard)"
//            request.httpBody = bodyData.data(using: .utf8
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//                    if let error = error {
//                        print("HTTP Request Failed: \(error.localizedDescription)")
//                        DispatchQueue.main.async {
//                            cardData = []
//                        }
//                        return
//                    }
//
//                    guard let data = data else {
//                        print("No data received")
//                        DispatchQueue.main.async {
//                            cardData = []
//                        }
//                        return
//                    }
//
//                    do {
//                        let pokemonCardArray = try JSONDecoder().decode([PokemonCard].self, from: data)
//                        DispatchQueue.main.async {
//                            cardData = pokemonCardArray
//                        }
//                        print("Valid JSON Data")
//                        print(cardData)
//                    } catch {
//                        print("Error decoding JSON: \(error)")
//                        DispatchQueue.main.async {
//                            cardData = []
//                        }
//                    }
//                }.resume()
//        }
//
