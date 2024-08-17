////
////  SearchTabView.swift
////  pokedata
////
////  Created by Kamal on 2024-08-16.
////
//
//import SwiftUI
//
//struct SearchTabView: View {
//    
//    @Binding var pokedata: String
//    @Binding var fetchedData: [Pokemon]
//    @Binding var isSearchActive: Bool
//    @FocusState var isSearchFieldFocused: Bool
//    @Binding var isFirstTime: Bool
//    @Binding var selected: Pokemon?
//    @Binding var showDetail: Bool
//    @Binding var pokemonImages: [String: UIImage]
//    var pokedata: () -> Void
//    
//    var body: some View {
//            GeometryReader { geometry in
//                ZStack {
//                    // Background that slides in
////                    let safeAreaTop = geometry.safeAreaInsets.top
////                    var heightMultiplier = 0.0
////                    var offsetMultiplier = 0.0
////
////                    if isSearchActive {
////
////                        if safeAreaTop > 25 {
////                            heightMultiplier = 0.17
////                            offsetMultiplier = 0.1
////                        } else if safeAreaTop > 20 {
////                            heightMultiplier = 0.17
////                            offsetMultiplier = 0.1
////                        } else {
////                            heightMultiplier = 0.29
////                            offsetMultiplier = 0.15
////                        }
//                    if isSearchActive {
//                        let isNotchDevice = geometry.safeAreaInsets.top > 20
//                        let heightMultiplier = isNotchDevice ? 0.17 : 0.29
//                        let offsetMultiplier = isNotchDevice ? 0.1 : 0.15
//
//                        Rectangle()
//                            .foregroundColor(Color.white.opacity(0.5))
//                            .frame(height: geometry.safeAreaInsets.top + (geometry.size.height * heightMultiplier))
//                            .offset(y: -geometry.size.height * offsetMultiplier)
//                            .transition(.move(edge: .top))
//                            .animation(.easeInOut(duration: 1.0), value: isSearchActive)
//                    }
//                    
//                }
//                .opacity(showDetail ? 0 : 1)
//                
//                VStack {
//                    if !isSearchActive && !showDetail { Spacer() }
//                    if !isSearchActive {
//                        Image("pokeball")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                    }
//                    // ZStack for the search bar
//                    ZStack(alignment: .leading) {
//                        if !showDetail {
//                            if isSearchActive {
//                                Button(action: {
//                                    withAnimation(.easeInOut(duration: 1.0)) {
//                                        isSearchActive.toggle()
//                                        isSearchFieldFocused = false
//                                    }
//                                }) {
//                                    Image(systemName: "chevron.backward")
//                                    
//                                        .font(.system(size: 35, weight: .bold))
//                                }
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                // .transition(.move(edge: .bottom))
//                            }
//                            Group {
//                                Image(systemName: "magnifyingglass")
//                                    .font(.system(size: 20, weight: .bold))
//                                    .padding(.leading, 20)
//                                    .zIndex(1.0)
//                                    .padding(.leading, isSearchActive ? geometry.size.width * 0.1 : 0)
//                                
//                                
//                                TextField("Search Pokemon:", text: $pokedata, onEditingChanged: { editing in
//                                    withAnimation {
//                                        isSearchActive = editing
//                                    }
//                                })
//                                .font(.system(size: 25, weight: .medium))
//                                .focused($isSearchFieldFocused)
//                                .autocapitalization(.none)
//                                .padding(.leading, 40)
//                                .padding()
//                                .multilineTextAlignment(.leading)
//                                .background(Color.white)
//                                .cornerRadius(20)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 20)
//                                        .stroke(Color.black, lineWidth: 3)
//                                )
//                                .transition(.move(edge: .top))
//                                .onAppear {
//                                    withAnimation(.easeInOut) {
//                                        // Trigger the animation
////                                        fetchPokedata()
//                                    }
//                                    
//                                }
//                                .onChange(of: pokedata) {
////                                    if pokedata.isEmpty {
////                                        fetchPokedata()
////                                    }
////                                    else {
//                                        submitPokedata()
////                                    }
//                                }
//                                .padding(.leading, isSearchActive ? geometry.size.width * 0.1 : 0)
//                            }
//                        }
//                    }
//                    .animation(.easeInOut(duration: 0.5), value: isSearchActive)
//                    .animation(.easeInOut(duration: 0.00000001), value: !showDetail)
//                    
//                    if !isSearchActive {
//                        Text("Enter Pokemon Name or Pokedex #")
//                            .foregroundColor(.white)
//                            .font(.system(size: 20, weight: .bold))
//                            .padding(7)
//                    }
//                    
//                    if isSearchActive {
//                        if !showDetail {
//                            Spacer()
//                                .frame(height: geometry.size.height * 0.02)
//                        }
//                        ZStack {
//                            VStack {
//                                List(fetchedData, id: \.id) { pokemon in
//                                    Button(action: {
//                                        withAnimation(.easeInOut) {
//                                            selected = pokemon
//                                            showDetail = true
//                                        }
//                                    }) {
//                                        HStack {
//                                            if let image = pokemonImages[pokemon.name] {
//                                                Image(uiImage: image)
//                                                    .resizable()
//                                                    .scaledToFit()
//                                                    .frame(minWidth: 25, idealWidth: 50, maxWidth: 50, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
//                                            }
//                                            Text(String(format: "#%04d", pokemon.pokedex_num))
//                                                .font(.system(size: 20))
//                                                .padding(.leading, 10)
//                                            Text(pokemon.name)
//                                                .font(.system(size: 20))
//                                                .fontWeight(.heavy)
//                                        }
//                                        .foregroundColor(Color.purple)
//                                        .onAppear {
//                                            fetchImage(for: pokemon)
//                                        }
//                                        
//                                    }
//                                }
//                                .scrollContentBackground(.hidden)
//                                .padding(.horizontal, -16)
//                            }
//                            
//                            // Overlay detail view when an item is selected
//                            if showDetail, let selectedPokemon = selected, let selectedImage = pokemonImages[selectedPokemon.name] {
//                                PokemonInfo(selectedImage: selectedImage, pokemon: selectedPokemon, onDismiss: {
//                                    withAnimation(.easeInOut) {
//                                        showDetail = false
//                                    }
//                                })
//                                .transition(.move(edge: .trailing))
//                                .edgesIgnoringSafeArea(.all)
//                                .zIndex(1)
//                            }
//                        }
//
//                        
//                                                    
//                        
//                        
//                            
//                            // Hide default background
//                            
//                            
//                        
//                        
//                        
////                        ForEach(fetchedData, id: \.id) { pokemon in
////                            Text("Name: \(pokemon.name), Pokedex Number: \(pokemon.pokedex_num)")
////                        }
////                        .padding(2)
//                        
//                            
//                            //                        if fetchedData.isEmpty {
//                            //                            if is2ndTime {
//                            //                                Text("No Results Found")
//                            //                            }
//                            //                        }
//                        
//                    }
//                    
//                    
//                    if !isSearchActive { Spacer() }
//                }
//                .padding(showDetail ? 0 : 16)
//            }
//    }
//}
//
//#Preview {
//    SearchTabView()
//}
