//
//  SearchTabView.swift
//  pokedata
//
//  Created by Kamal on 2024-08-16.
//

import SwiftUI

struct SearchTabView: View {
    // Checks if search view is shown or not
    @State private var hasAnimated = false
    @Binding var pokedata: String
    @Binding var fetchedData: [Pokemon]
    @Binding var isSearchActive: Bool
    @FocusState var isSearchFieldFocused: Bool
    @Binding var selected: Pokemon?
    @Binding var showDetail: Bool
    @Binding var pokemonImages: [String: UIImage]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
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
                            .onChange(of: pokedata) {
                                submitPokedata()
                            }
                            .padding(.leading, isSearchActive ? geometry.size.width * 0.1 : 0)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: isSearchActive)
                .animation(.easeInOut(duration: 0.00000001), value: !showDetail)
                
                if !isSearchActive {
                    Text("Enter Pokemon Name or Pokedex #")
                        .foregroundColor(.blue)
                        .font(.system(size: 20, weight: .semibold))
                        .padding(7)
                        .padding(.bottom, -10)
                    Text("Supports Gen 1 - 8!")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .semibold))
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
                }
                if !isSearchActive { Spacer() }
            }
            .padding(showDetail ? 0 : 16)
        }
    }
    
    func submitPokedata() {
        guard let url = URL(string: "\(Config.baseURL)/") else {
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
        guard let imageUrl = URL(string: "\(Config.baseURL)/images/\(pokemon.name)_new.png") else {
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
    SearchTabView(
        pokedata: .constant("Lugia"),
        fetchedData: .constant([Pokemon(
            id: 0,
            pokedex_num: 1,
            name: "Bulbasaur",
            jap_name: "フシギダネ (Fushigidane)",
            generation: 1,
            status: "Normal",
            species: "Seed Pokemon",
            type_num: 2,
            type_1: "Grass",
            type_2: "Poison",
            height_m: 0.7,
            weight_kg: 6.9,
            abilities_num: 2,
            ability_1: "Overgrow",
            ability_2: "",
            ability_hidden: "Chlorophyll",
            stat_total: 318,
            hp: 45,
            attack: 49,
            defense: 49,
            sp_attack: 65,
            sp_defense: 65,
            speed: 45,
            catch_rate: 45,
            base_friendship: 70,
            base_exp: 64,
            growth_rate: "Medium Slow",
            egg_type_num: 2,
            egg_type_1: "Grass",
            egg_type_2: "Monster",
            percent_male: 87.5,
            egg_cycles: 20,
            against_normal: 1,
            against_fire: 2,
            against_water: 0.5,
            against_electric: 0.5,
            against_grass: 0.25,
            against_ice: 2,
            against_fight: 0.5,
            against_poison: 1,
            against_ground: 1,
            against_flying: 2,
            against_psychic: 2,
            against_bug: 1,
            against_rock: 1,
            against_ghost: 1,
            against_dragon: 1,
            against_dark: 1,
            against_steel: 1,
            against_fairy: 0.5
        )]),
        isSearchActive: .constant(false),
        selected: .constant(Pokemon(
            id: 0,
            pokedex_num: 1,
            name: "Bulbasaur",
            jap_name: "フシギダネ (Fushigidane)",
            generation: 1,
            status: "Normal",
            species: "Seed Pokemon",
            type_num: 2,
            type_1: "Grass",
            type_2: "Poison",
            height_m: 0.7,
            weight_kg: 6.9,
            abilities_num: 2,
            ability_1: "Overgrow",
            ability_2: "",
            ability_hidden: "Chlorophyll",
            stat_total: 318,
            hp: 45,
            attack: 49,
            defense: 49,
            sp_attack: 65,
            sp_defense: 65,
            speed: 45,
            catch_rate: 45,
            base_friendship: 70,
            base_exp: 64,
            growth_rate: "Medium Slow",
            egg_type_num: 2,
            egg_type_1: "Grass",
            egg_type_2: "Monster",
            percent_male: 87.5,
            egg_cycles: 20,
            against_normal: 1,
            against_fire: 2,
            against_water: 0.5,
            against_electric: 0.5,
            against_grass: 0.25,
            against_ice: 2,
            against_fight: 0.5,
            against_poison: 1,
            against_ground: 1,
            against_flying: 2,
            against_psychic: 2,
            against_bug: 1,
            against_rock: 1,
            against_ghost: 1,
            against_dragon: 1,
            against_dark: 1,
            against_steel: 1,
            against_fairy: 0.5
        )),
        showDetail: .constant(true),
        pokemonImages: .constant(["Bulbasaur": UIImage(named: "Bulbasaur_new")!])
    )
}
