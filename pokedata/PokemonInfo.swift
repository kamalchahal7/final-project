//
//  SwiftUIView.swift
//  pokedata
//
//  Created by Kamal on 2024-08-07.
//


// EVERY IF STATEMENT HERE NEEDS TO BE CHECKED WITH RANDOM POKEMON (nil values or empty strings --> will only found using random pokemon
import SwiftUI

let types = ["Normal", "Fire", "Water", "Electric", "Grass", "Ice", "Fight", "poison", "Ground", "Flying", "Psychic", "Bug", "Rock", "Ghost", "Dragon", "Dark", "Steel", "Fairy"]

struct PokemonInfo: View {
    var selectedImage: UIImage?
    var pokemon: Pokemon
    let onDismiss: () -> Void
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Button("Back") {
                        onDismiss()
                    }
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()

                        .frame(width: UIScreen.main.bounds.width * 0.7)
                } else {
                    Text("No image available")
                }

                HStack {
                    Text("\(pokemon.name)")
                    Text(String(format: "#%04d", pokemon.pokedex_num))
                }
                .font(.largeTitle)
                Text("\(pokemon.jap_name)")
                    .font(.title)
                HStack {
                    Text("Gen \(pokemon.generation)")
                    Text("\(pokemon.species)")
                }
                .font(.title2)
                
                Text("\(pokemon.status) Status")
                    .font(.title3)
                if pokemon.type_2 == "" {
                    Text("Type: \(pokemon.type_1)")
                        .font(.headline)
                }
                else {
                    Text("Types: \(pokemon.type_1) & \(pokemon.type_2)")
                        .font(.headline)
                }
                
                HStack {
                    Text(String(format: "Height: %2.1fm", pokemon.height_m))
                    if pokemon.weight_kg != nil {
                        Text(String(format: "Weight: %2.1fm", pokemon.weight_kg!))
                    }
                    
                }
                .font(.subheadline)
                
                if pokemon.ability_2 == "" {
                    Text("Abilities: \(pokemon.ability_1) & \(pokemon.ability_2)")
                        .font(.body)
                }
                else {
                    Text("Ability: \(pokemon.ability_1)")
                        .font(.body)
                }
                
                if pokemon.ability_hidden == "" {
                    Text("Hidden Ability: \(pokemon.ability_hidden)")
                }
                
                Text("Stat Total: \(pokemon.stat_total)").bold()
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())])  {
                    Text("HP: \(pokemon.hp)")
                    
                    Text("Attack: \(pokemon.attack)")
                    
                    Text("Defense: \(pokemon.defense)")
                    
                    Text("Speed: \(pokemon.speed)")
                    
                    
                    // might remove if statements
                    if pokemon.attack != pokemon.sp_attack {
                        Text("Special Attack: \(pokemon.sp_attack)")
                        
                    }
                    if pokemon.defense != pokemon.sp_defense {
                        Text("Special Defense: \(pokemon.sp_defense)")
                        
                    }
                }
                .padding(.bottom)
                
                let values = [pokemon.against_normal, pokemon.against_fire, pokemon.against_water, pokemon.against_electric, pokemon.against_grass, pokemon.against_ice, pokemon.against_fight, pokemon.against_poison, pokemon.against_ground, pokemon.against_flying, pokemon.against_psychic, pokemon.against_bug, pokemon.against_rock, pokemon.against_ghost, pokemon.against_dragon, pokemon.against_dark, pokemon.against_steel, pokemon.against_fairy]
                
                Text("Strengths").bold()
                HStack {
                    ForEach(Array(values.enumerated()), id: \.offset) { index, element in
                        if element < 1 {
                            Text("\(types[index]): " + String(format: "%1.2f", element))
                        }
                    }
                }
                .padding(.bottom)
                
                Text("Weaknesses").bold()
                HStack {
                    ForEach(Array(values.enumerated()), id: \.offset) { index, element in
                        if element > 1 {
                            Text("\(types[index]): " + String(format: "%1.2f", element))
                        }
                    }
                }
                .padding(.bottom)
                
                if (pokemon.catch_rate != nil || pokemon.base_friendship != nil || pokemon.base_exp != nil || pokemon.growth_rate != nil || pokemon.egg_type_1 != "" || pokemon.egg_type_2 != "" || pokemon.percent_male != nil || pokemon.egg_cycles != nil)
                {
                    Text("Extra Info").bold()
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        if pokemon.catch_rate != nil {
                            Text("Catch Rate: \(pokemon.catch_rate!)")
                        }
                        if pokemon.base_friendship != nil {
                            Text("Base Friendship: \(pokemon.base_friendship!)")
                        }
                        if pokemon.base_exp != nil {
                            Text("Base Experience: \(pokemon.base_exp!)")
                        }
                        
                        // can switch format to --> <Medium Slow> Growth Rate
                        if pokemon.growth_rate != nil {
                            Text("Growth Rate: \(pokemon.growth_rate!)")
                        }
                        if pokemon.egg_type_1 != "" && pokemon.egg_type_2 != "" {
                            Text("Egg Types: \(pokemon.egg_type_1) & \(pokemon.egg_type_2)")
                        }
                        else if pokemon.egg_type_1 != "" {
                            Text("Egg Type: \(pokemon.egg_type_1)")
                        }
                        // this may not function as intended need to check with pokemon that is trans
                        if pokemon.percent_male != nil {
                            Text(String(format: "Male Population: %2.1f%%", pokemon.percent_male!))
                        }
                        if pokemon.egg_cycles != nil {
                            Text("Egg Cycles: \(pokemon.egg_cycles!)")
                        }
                        
                    }
                }
               
//                func floatToFraction(_ value: Float) -> String {
//                    let precision = 10000
//                    let numerator = Int(value * Float(precision))
//                    let denominator = precision
//                    let gcd = greatestCommonDivisor(numerator, denominator)
//                    return "\(numerator / gcd)/\(denominator / gcd)"
//                }
//
//                func greatestCommonDivisor(_ a: Int, _ b: Int) -> Int {
//                    return b == 0 ? a : greatestCommonDivisor(b, a % b)
//                }
                
//                Text("\(types[index]): \(floatToFraction(element))")
                
                
                
                
                
                
//                let formatter = NumberFormatter()
//                formatter.minimumFractionDigits = 0
//                formatter.maximumFractionDigits = 10 Adjust as needed
//
//                if let formattedNumber = formatter.string(from: NSNumber(value: element)) {
//                    Text("\(types[index]): \(formattedNumber)")
//                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 8)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
    }
}

#Preview {
    PokemonInfo(selectedImage: UIImage(named: "pokeball")!, pokemon: Pokemon(id: 0, pokedex_num: 1, name: "Bulbasaur", jap_name: "フシギダネ (Fushigidane)", generation: 1, status: "Normal", species: "Seed Pokemon", type_num: 2, type_1: "Grass", type_2: "Poison", height_m: 0.7, weight_kg: 6.9, abilities_num: 2, ability_1: "Overgrow", ability_2: "", ability_hidden: "Chlorophyll", stat_total: 318, hp: 45, attack: 49, defense: 49, sp_attack: 65, sp_defense: 65, speed: 45, catch_rate: 45, base_friendship: 70, base_exp: 64, growth_rate: "Medium Slow", egg_type_num: 2, egg_type_1: "Grass", egg_type_2: "Monster", percent_male: 87.5, egg_cycles: 20, against_normal: 1, against_fire: 2, against_water: 0.5, against_electric: 0.5, against_grass: 0.25, against_ice: 2, against_fight: 0.5, against_poison: 1, against_ground: 1, against_flying: 2, against_psychic: 2, against_bug: 1, against_rock: 1, against_ghost: 1, against_dragon: 1, against_dark: 1, against_steel: 1, against_fairy: 0.5), onDismiss: {})
}
