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

struct Set: Codable, Equatable {
    let id: String
    let name: String
    let total: Int
    let printedTotal: Int
    let releaseDate: String
    let logo: String
    let symbol: String
}

struct Series: Codable, Equatable {
    let series: String
    let sets: [Set]
}

struct UserInfo: Decodable, Identifiable, Hashable {
    let id: Int
    let username: String
    let email: String
    let first_name: String
    let last_name: String
    let date_of_birth: String
    let registration_time_EST: String
    var collection: Int
}

class cards: ObservableObject {
    @Published var cards: [PokemonCard] = []
}
class series: ObservableObject {
    @Published var series: [Series] = []
}

struct ContentView: View {
    // Global user id
    @AppStorage("user_id") var user_id: Int = 0
    // Environment object for collection
    @StateObject var collections = cards()
    // Environment object for collection
    @StateObject var activeSeries = series()
    // Tracks a change in collection
    @State var collectionEdit: Bool = false
    // Inputed Data on Search Tab Bar
    @State private var pokedata: String = ""
    // Returned Data from pokedata.db
    @State private var fetchedData: [Pokemon] = []
    // Returned Data from accounts.db
    @State private var userData = UserInfo(id: 0, username: "", email: "", first_name: "", last_name: "", date_of_birth: "", registration_time_EST: "", collection: 0)
    // Initial Tab
    @State private var selectedTab = 0
    // Checks if search bar is active or not
    @State private var isSearchActive: Bool = false
    // Checks if input field is in focus or not
    @FocusState private var isSearchFieldFocused: Bool
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
    // Checks whether creditsview should be shown or not
    @State private var showCreditsView = false
    // backend error message
    @State private var message: String = ""
    // backend error code
    @State private var errorCode: String = ""
    // checks if backend pciked up a fault
    @State private var fault: Bool = false
    // checks if the user is not logged in
    @State private var notLoggedIn: Bool = true
    
//  Future Implementation (CameraView):
        
    //  @State private var isCameraButtonDisabled = false
    //  @State private var showCamera: Bool = false
    //  @State private var showPhotos: Bool = false
    //  @State private var image: UIImage?
    
//  Future Implementation (HistoryView):
    
    // Checks whether historyview should be shown or not
    
    @State private var showHistoryView = false

    var body: some View {
        TabView (selection: $selectedTab) {
            // CARDS TAB BAR
            GeometryReader { geometry in
                VStack {
                    SearchCardTabView(
                        showCardDetail: $showCardDetail,
                        selectedCard: $selectedCard,
                        collectionEdit: $collectionEdit,
                        collection: $collection,
                        market: $market,
                        showLoginView: $showLoginView,
                        showRegisterView: $showRegisterView,
                        message: $message,
                        errorCode: $errorCode,
                        fault: $fault
                    )
                    .onDisappear {
                        showCardDetail = false
                    }
                }
            }
            .background(Color(red: 0.82, green: 0.71, blue: 0.55).edgesIgnoringSafeArea(.all))
            .tabItem {
                Label("Cards", systemImage: "doc.text.magnifyingglass")
            }
            .tag(0)
        
            // SEARCH TAB BAR
            GeometryReader { geometry in
                VStack {
                    SearchTabView(pokedata: $pokedata, fetchedData: $fetchedData, isSearchActive: $isSearchActive, selected: $selected, showDetail: $showDetail, pokemonImages: $pokemonImages)
                }
            }
            .background(Color(red: 0.82, green: 0.71, blue: 0.55).edgesIgnoringSafeArea(.all))
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .onAppear() {
                UITabBar.appearance().backgroundColor = .white
            }
            .tag(1)
            
            // COLLECTION TAB BAR
            GeometryReader { geometry in
                VStack {
                    CollectionTabView(
                        collectionEdit: $collectionEdit,
                        collection: $collection,
                        selectedCard: $selectedCard,
                        market: $market,
                        showLoginView: $showLoginView,
                        showRegisterView: $showRegisterView,
                        message: $message,
                        errorCode: $errorCode,
                        fault: $fault
                    )
                }
            }
            .background(Color(red: 0.82, green: 0.71, blue: 0.55).edgesIgnoringSafeArea(.all))
            .tabItem {
                Label("Collection", systemImage: "square.on.square")
            }
            .tag(2)
            
            
            // PROFILE TAB BAR
            GeometryReader { geometry in
                VStack {
                        if user_id == 0 {
                            if showLoginView {
                                LoginView(showLoginView: $showLoginView, showRegisterView: $showRegisterView, message: $message, errorCode: $errorCode, fault: $fault, onLoginSuccess: { notLoggedIn = false })
                            }
                            if showRegisterView {
                                RegisterView(showLoginView: $showLoginView, showRegisterView: $showRegisterView, message: $message, errorCode: $errorCode, fault: $fault)
                            }
                        }
                    else {
                        if showPersonalView {
                            PersonalView(userData: $userData, message: $message, errorCode: $errorCode, fault: $fault, onDismiss: {
                                withAnimation(.easeInOut) {
                                    showPersonalView.toggle()
                                }
                            })
                            .transition(.move(edge: .trailing))
                            .edgesIgnoringSafeArea(.all)
                        } else if showPasswordChangeView {
                            PasswordChangeView(userData: $userData, message: $message, errorCode: $errorCode, fault: $fault, onDismiss: {
                                withAnimation(.easeInOut) {
                                    showPasswordChangeView.toggle()
                                }
                            })
                            .transition(.move(edge: .trailing))
                            .edgesIgnoringSafeArea(.all)
                            
//  Future Implementation (HistoryView):
                            
//                        } else if showHistoryView {
//                            HistoryView(onDismiss: {
//                                withAnimation(.easeInOut) {
//                                    showHistoryView.toggle()
//                                }
//                            })
//                            .transition(.move(edge: .trailing))
//                            .edgesIgnoringSafeArea(.all)
//                            
                        } else if showCreditsView {
                            CreditsView(onDismiss: {
                                withAnimation(.easeInOut) {
                                    showCreditsView.toggle()
                                }
                            })
                            .transition(.move(edge: .trailing))
                            .edgesIgnoringSafeArea(.all)
                            
                        } else {
                            ProfileTabView(showLoginView: $showLoginView, showPersonalView: $showPersonalView, showPasswordChangeView: $showPasswordChangeView, showHistoryView: $showHistoryView, showCreditsView: $showCreditsView, userData: $userData, collectionCount: $collection.count, notLoggedIn: $notLoggedIn)
                            .onAppear {
                                fetchUserData()
                            }
                        }
                    }
                }
                .padding(showRegisterView || showPersonalView || showPasswordChangeView || showCreditsView || showHistoryView ? 0 : 16)
            }
            .background(Color(red: 0.82, green: 0.71, blue: 0.55).edgesIgnoringSafeArea(.all))
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
            .tag(3)
        }
        .environmentObject(collections)
        .environmentObject(activeSeries)
        .onAppear {
            resetSetsOnStart()
        }
        
        // Changes Colour of Tab Bar
        .onAppear() {
            UITabBar.appearance().backgroundColor = .white
        }
        
//  Future Implementation (CameraView):
        
        // Changes Colour of the Tab Bar Font
//        .fullScreenCover(isPresented: $showCamera, onDismiss: {
//            showCamera = false
//        }) {
//            CameraOverlayView(image: $image, showCamera: $showCamera)
//        }
    }
    
    func fetchUserData() {
        if user_id == 0 {
            print("No user ID provided")
            return
        }
        
        let urlString = "\(Config.baseURL)/profile?user_id=\(user_id)"
        
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
                    print("Server is not running!")
                }
            } else if let data = data {
                do {
                    let info = try JSONDecoder().decode([UserInfo].self, from: data)
                    DispatchQueue.main.async {
                        if let user = info.first {
                            userData = user
                            print(userData)
                        }
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func resetSetsOnStart() {
        if user_id == 0 {
            print("No user ID provided")
            return
        }
        
        let urlString = "\(Config.baseURL)/reset?user_id=\(user_id)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error resetting sets:", error)
                return
            }
            print("Sets reset successfully")
        }.resume()
    }
}

func calculateMarketPrice(for pokemoncard: PokemonCard) -> String {
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
}

func fetchUserID() -> Int {
    // Simulate fetching user_id from UserDefaults
    if let userID = UserDefaults.standard.value(forKey: "user_id") as? Int {
        return userID
    } else {
        return 0 // Default value if no user_id is stored
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
