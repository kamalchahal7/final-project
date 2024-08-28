//
//  SwiftUIView.swift
//  pokedata
//
//  Created by Kamal on 2024-08-07.
//


// EVERY IF STATEMENT HERE NEEDS TO BE CHECKED WITH RANDOM POKEMON (nil values or empty strings --> will only found using random pokemon
import SwiftUI

let types = ["Normal", "Fire", "Water", "Electric", "Grass", "Ice", "Fighting", "Poison", "Ground", "Flying", "Psychic", "Bug", "Rock", "Ghost", "Dragon", "Dark", "Steel", "Fairy"]

let colours: [String: UIColor] = [
    "Normal": UIColor(hex: "#A8A77A"),
    "Fire": UIColor(hex: "#EE8130"),
    "Water": UIColor(hex: "#6390F0"),
    "Electric": UIColor(hex: "#F7D02C"),
    "Grass": UIColor(hex: "#7AC74C"),
    "Ice": UIColor(hex: "#96D9D6"),
    "Fighting": UIColor(hex: "#C22E28"),
    "Poison": UIColor(hex: "#A33EA1"),
    "Ground": UIColor(hex: "#E2BF65"),
    "Flying": UIColor(hex: "#A98FF3"),
    "Psychic": UIColor(hex: "#F95587"),
    "Bug": UIColor(hex: "#A6B91A"),
    "Rock": UIColor(hex: "#B6A136"),
    "Ghost": UIColor(hex: "#735797"),
    "Dragon": UIColor(hex: "#6F35FC"),
    "Dark": UIColor(hex: "#705746"),
    "Steel": UIColor(hex: "#B7B7CE"),
    "Fairy": UIColor(hex: "#D685AD")
]

struct PokemonInfo: View {
    // Indicates whether a section is shown or not
    @State private var shown: [Bool] = [true, true, true, true, true]
    
    var selectedImage: UIImage?
    var pokemon: Pokemon
    let onDismiss: () -> Void
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
                    }
                    .padding(.top, 40)
                    // make this dynamic for touch id iphone
                    
                    Spacer()
                    
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .shadow(color: .white, radius: 100)
                            .frame(height: geometry.size.height * 0.35)
                            .padding(.bottom)
                        
                        
                    } else {
                        Text("No image available")
                    }
                    GroupBox {
                        HStack {
                            
                            Text("\(pokemon.name)")
                                .fontWeight(.bold)
                                .font(.largeTitle)
                            
                            Spacer()
                            Text(String(format: "#%04d", pokemon.pokedex_num))
                                .padding(5)
                                .foregroundColor(.white)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .background(Color.green)
                                .cornerRadius(10)
                            
                            
                        }
                        HStack {
                            Text("\(pokemon.jap_name)")
                                .font(.title)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    
                    GroupBox {
                        Text("Gen \(pokemon.generation) - \(pokemon.status) \(pokemon.species)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        
                       
                        if pokemon.type_2 == "" {
                            Text("Type: \(pokemon.type_1)")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        else {
                            HStack{
                                Text("Types: ")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                Text("\(pokemon.type_1)")
                                    .padding(10)
                                    .background(Color(colours["\(pokemon.type_1)"] ?? UIColor.clear))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Text("\(pokemon.type_2)")
                                    .padding(10)
                                    .background(Color(colours["\(pokemon.type_2)"] ?? UIColor.clear))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                            }
                            .font(.title2)
                            .fontWeight(.semibold)
                        }
                        
                        if pokemon.ability_2 == "" {
                            Text("Ability: \(pokemon.ability_1)")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        else {
                            Text("Abilities: \(pokemon.ability_1) & \(pokemon.ability_2)")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        
                        if pokemon.ability_hidden != "" {
                            Text("Hidden Ability: \(pokemon.ability_hidden)")
                                .font(.headline)
                                .fontWeight(.regular)
                        }
                        
                        Spacer().frame(height: 10)
                        
                        HStack {
                            Text(String(format: "Height: %2.1fm", pokemon.height_m))
                            if pokemon.weight_kg != nil {
                                Text(String(format: "Weight: %2.1fkg", pokemon.weight_kg!))
                            }
                            
                        }
                        .font(.headline)
                        .fontWeight(.semibold)
                        
                        Divider()
                        
                        
                        GroupBox {
                            HStack {
                                Text("Base Stats")
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
                            if shown[0] {
                                
                                let statmax = ["hp": 255, "attack": 190, "defense": 250, "sp_attack": 194, "sp_defense": 250, "speed": 200, "total": 1339]
                                
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())])  {
                                    let coloumnWidth = (geometry.size.width - 96)/3
                                    
                                    HStack {
                                        Spacer()
                                        Text("HP")
                                    }
                                    Text("\(pokemon.hp)")
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                                .frame(width: coloumnWidth, height: 15)
                                                .foregroundColor(Color.gray.opacity(0.2)) // Background rectangle showing full width
                                                .cornerRadius(5)
                                        Rectangle()
                                            .frame(width: calculateWidth(for: pokemon.hp, max: statmax["hp"]!, columnWidth: coloumnWidth), height: 15)
                                            .foregroundColor(colorForStat(pokemon.hp, max: statmax["hp"]!))
                                            .cornerRadius(5)
                                    }
                                    
                                    HStack {
                                        Spacer()
                                        Text("Attack")
                                    }
                                    Text("\(pokemon.attack)")
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                                .frame(width: coloumnWidth, height: 15)
                                                .foregroundColor(Color.gray.opacity(0.2)) // Background rectangle showing full width
                                                .cornerRadius(5)
                                        Rectangle()
                                            .frame(width: calculateWidth(for: pokemon.attack, max: statmax["attack"]!, columnWidth: coloumnWidth), height: 15)
                                            .foregroundColor(colorForStat(pokemon.attack, max: statmax["attack"]!))
                                            .cornerRadius(5)
                                    }
                                    
                                    HStack {
                                        Spacer()
                                        Text("Defense")
                                    }
                                    Text("\(pokemon.defense)")
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                                .frame(width: coloumnWidth, height: 15)
                                                .foregroundColor(Color.gray.opacity(0.2)) // Background rectangle showing full width
                                                .cornerRadius(5)
                                        Rectangle()
                                            .frame(width: calculateWidth(for: pokemon.defense, max: statmax["defense"]!, columnWidth: coloumnWidth), height: 15)
                                            .foregroundColor(colorForStat(pokemon.defense, max: statmax["defense"]!))
                                            .cornerRadius(5)
                                    }
                                    
                                    HStack {
                                        Spacer()
                                        Text("Sp. Attack")
                                    }
                                    Text("\(pokemon.sp_attack)")
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                                .frame(width: coloumnWidth, height: 15)
                                                .foregroundColor(Color.gray.opacity(0.2)) // Background rectangle showing full width
                                                .cornerRadius(5)
                                        Rectangle()
                                            .frame(width: calculateWidth(for: pokemon.sp_attack, max: statmax["sp_attack"]!, columnWidth: coloumnWidth), height: 15)
                                            .foregroundColor(colorForStat(pokemon.sp_attack, max: statmax["sp_attack"]!))
                                            .cornerRadius(5)
                                    }
                                    
                                    Text("Sp. Defense")
                                    Text("\(pokemon.sp_defense)")
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                                .frame(width: coloumnWidth, height: 15)
                                                .foregroundColor(Color.gray.opacity(0.2)) // Background rectangle showing full width
                                                .cornerRadius(5)
                                        Rectangle()
                                            .frame(width: calculateWidth(for: pokemon.sp_defense, max: statmax["sp_defense"]!, columnWidth: coloumnWidth), height: 15)
                                            .foregroundColor(colorForStat(pokemon.sp_defense, max: statmax["sp_defense"]!))
                                            .cornerRadius(5)
                                    }
                                    
                                    HStack {
                                        Spacer()
                                        Text("Speed")
                                    }
                                    Text("\(pokemon.speed)")
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                                .frame(width: coloumnWidth, height: 15)
                                                .foregroundColor(Color.gray.opacity(0.2)) // Background rectangle showing full width
                                                .cornerRadius(5)
                                        Rectangle()
                                            .frame(width: calculateWidth(for: pokemon.speed, max: statmax["speed"]!, columnWidth: coloumnWidth), height: 15)
                                            .foregroundColor(colorForStat(pokemon.speed, max: statmax["speed"]!))
                                            .cornerRadius(5)
                                    }
                                    
                                    HStack {
                                        Spacer()
                                        Text("Total").bold()
                                    }
                                    Text("\(pokemon.stat_total)").bold()
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                                .frame(width: coloumnWidth, height: 15)
                                                .foregroundColor(Color.gray.opacity(0.2)) // Background rectangle showing full width
                                                .cornerRadius(5)
                                        Rectangle()
                                            .frame(width: calculateWidth(for: pokemon.stat_total, max: statmax["total"]!, columnWidth: coloumnWidth), height: 15)
                                            .foregroundColor(colorForStat(pokemon.stat_total, max: statmax["total"]!))
                                            .cornerRadius(5)
                                    }
                                }
                            }
                        }

                        
                        let values = [pokemon.against_normal, pokemon.against_fire, pokemon.against_water, pokemon.against_electric, pokemon.against_grass, pokemon.against_ice, pokemon.against_fight, pokemon.against_poison, pokemon.against_ground, pokemon.against_flying, pokemon.against_psychic, pokemon.against_bug, pokemon.against_rock, pokemon.against_ghost, pokemon.against_dragon, pokemon.against_dark, pokemon.against_steel, pokemon.against_fairy]
                        
                        GroupBox {
                            HStack {
                                Text("Resistances")
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
                            .padding(.bottom, shown[1] ? 10 : 0)
                            if shown[1] {
                                let columns = [GridItem(.adaptive(minimum: 80))]
                                LazyVGrid(columns: columns, spacing: 10) {
                                    ForEach(Array(values.enumerated()), id: \.offset) { index, element in
                                        if element < 1 {
                                            VStack {
                                                Text("\(types[index])")
                                                    .padding(10)
                                                    .background(Color(colours["\(types[index])"] ?? UIColor.clear))
                                                    .cornerRadius(10)
                                                    .foregroundColor(.white)
                                                    .fontWeight(.semibold)
                                                Text(String(format: "%1.2fx", element))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        GroupBox {
                            HStack {
                                Text("Weaknesses")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                Spacer()
                                Button {
                                    withAnimation {
                                        shown[2].toggle()
                                    }
                                } label: {
                                    Image (systemName: shown[2] ? "chevron.up" : "chevron.down")
//                                        .symbolVariant(.circle.fill)
                                }
                                .font(.title2)
//                                .foregroundStyle(.gray.opacity(0.5))
                            }
                            .padding(.bottom, shown[2] ? 10 : 0)
                            if shown[2] {
                                let columns = [GridItem(.adaptive(minimum: 80))]
                                LazyVGrid(columns: columns, spacing: 10) {
                                    ForEach(Array(values.enumerated()), id: \.offset) { index, element in
                                        if element > 1 {
                                            VStack {
                                                Text("\(types[index])")
                                                    .padding(10)
                                                    .background(Color(colours["\(types[index])"] ?? UIColor.clear))
                                                    .cornerRadius(10)
                                                    .foregroundColor(.white)
                                                    .fontWeight(.semibold)
                                                Text(String(format: "%1.2fx", element))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        if (pokemon.catch_rate != nil || pokemon.base_friendship != nil || pokemon.base_exp != nil || pokemon.growth_rate != nil) {
                            GroupBox {
                                HStack {
                                    Text("Training")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Button {
                                        withAnimation {
                                            shown[3].toggle()
                                        }
                                    } label: {
                                        Image (systemName: shown[3] ? "chevron.up" : "chevron.down")
    //                                        .symbolVariant(.circle.fill)
                                    }
                                    .font(.title2)
    //                                .foregroundStyle(.gray.opacity(0.5))
                                }
                                .padding(.bottom, shown[3] ? 10 : 0)
                                
                                if shown[3] {
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
                                }
                            }
                        }
                        
                        if (pokemon.egg_type_1 != "" || pokemon.egg_type_2 != "" || pokemon.percent_male != nil || pokemon.egg_cycles != nil) {
                            GroupBox {
                                HStack {
                                    Text("Breeding")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Button {
                                        withAnimation {
                                            shown[4].toggle()
                                        }
                                    } label: {
                                        Image (systemName: shown[4] ? "chevron.up" : "chevron.down")
    //                                        .symbolVariant(.circle.fill)
                                    }
                                    .font(.title2)
    //                                .foregroundStyle(.gray.opacity(0.5))
                                }
                                .padding(.bottom, shown[4] ? 10 : 0)
                                
                                if shown[4] {
//                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
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
//                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 100)
                    
//                    Group {
//                                            HStack {
//                    
//                                                Text("\(pokemon.name)")
//                                                    .fontWeight(.bold)
//                                                    .font(.largeTitle)
//                    
//                                                Spacer()
//                                                Text(String(format: "#%04d", pokemon.pokedex_num))
//                                                    .padding(5)
//                                                    .foregroundColor(.white)
//                                                    .font(.headline)
//                                                    .fontWeight(.semibold)
//                                                    .background(Color.green)
//                                                    .cornerRadius(10)
//                    
//                    
//                                            }
//                    
//                    
//                                            Text("\(pokemon.jap_name)")
//                                                .font(.title)
//                                                .fontWeight(.semibold)
//                    
//                                            Divider()
//                                                .frame(height: 0.5)
//                                                .background(Color.black)
//                    
//                                            HStack {
//                                                Text("Gen \(pokemon.generation)")
//                                                Text("\(pokemon.species)")
//                                            }
//                                            .font(.title2)
//                                            .fontWeight(.medium)
//                    
//                                            Text("\(pokemon.status) Status")
//                                                .font(.title3)
//                                            if pokemon.type_2 == "" {
//                                                Text("Type: \(pokemon.type_1)")
//                                                    .font(.headline)
//                                            }
//                                            else {
//                                                Text("Types: \(pokemon.type_1) & \(pokemon.type_2)")
//                                                    .font(.headline)
//                                            }
//                    
//                                            HStack {
//                                                Text(String(format: "Height: %2.1fm", pokemon.height_m))
//                                                if pokemon.weight_kg != nil {
//                                                    Text(String(format: "Weight: %2.1fm", pokemon.weight_kg!))
//                                                }
//                    
//                                            }
//                                            .font(.subheadline)
//                    
//                                            if pokemon.ability_2 == "" {
//                                                Text("Abilities: \(pokemon.ability_1) & \(pokemon.ability_2)")
//                                                    .font(.body)
//                                            }
//                                            else {
//                                                Text("Ability: \(pokemon.ability_1)")
//                                                    .font(.body)
//                                            }
//                    
//                                            if pokemon.ability_hidden == "" {
//                                                Text("Hidden Ability: \(pokemon.ability_hidden)")
//                                            }
//                    
//                                            Text("Stat Total: \(pokemon.stat_total)").bold()
//                                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())])  {
//                                                Text("HP: \(pokemon.hp)")
//                    
//                                                Text("Attack: \(pokemon.attack)")
//                    
//                                                Text("Defense: \(pokemon.defense)")
//                    
//                                                Text("Speed: \(pokemon.speed)")
//                    
//                    
//                                                // might remove if statements
//                                                if pokemon.attack != pokemon.sp_attack {
//                                                    Text("Special Attack: \(pokemon.sp_attack)")
//                    
//                                                }
//                                                if pokemon.defense != pokemon.sp_defense {
//                                                    Text("Special Defense: \(pokemon.sp_defense)")
//                    
//                                                }
//                                            }
//                                            .padding(.bottom)
//                    
//                                            let values = [pokemon.against_normal, pokemon.against_fire, pokemon.against_water, pokemon.against_electric, pokemon.against_grass, pokemon.against_ice, pokemon.against_fight, pokemon.against_poison, pokemon.against_ground, pokemon.against_flying, pokemon.against_psychic, pokemon.against_bug, pokemon.against_rock, pokemon.against_ghost, pokemon.against_dragon, pokemon.against_dark, pokemon.against_steel, pokemon.against_fairy]
//                    
//                                            Text("Strengths").bold()
//                                            HStack {
//                                                ForEach(Array(values.enumerated()), id: \.offset) { index, element in
//                                                    if element < 1 {
//                                                        Text("\(types[index]): " + String(format: "%1.2f", element))
//                                                    }
//                                                }
//                                            }
//                                            .padding(.bottom)
//                    
//                                            Text("Weaknesses").bold()
//                                            HStack {
//                                                ForEach(Array(values.enumerated()), id: \.offset) { index, element in
//                                                    if element > 1 {
//                                                        Text("\(types[index]): " + String(format: "%1.2f", element))
//                                                    }
//                                                }
//                                            }
//                                            .padding(.bottom)
//                    
//                                            if (pokemon.catch_rate != nil || pokemon.base_friendship != nil || pokemon.base_exp != nil || pokemon.growth_rate != nil || pokemon.egg_type_1 != "" || pokemon.egg_type_2 != "" || pokemon.percent_male != nil || pokemon.egg_cycles != nil)
//                                            {
//                                                Text("Extra Info").bold()
//                                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
//                                                    if pokemon.catch_rate != nil {
//                                                        Text("Catch Rate: \(pokemon.catch_rate!)")
//                                                    }
//                                                    if pokemon.base_friendship != nil {
//                                                        Text("Base Friendship: \(pokemon.base_friendship!)")
//                                                    }
//                                                    if pokemon.base_exp != nil {
//                                                        Text("Base Experience: \(pokemon.base_exp!)")
//                                                    }
//                    
//                                                    // can switch format to --> <Medium Slow> Growth Rate
//                                                    if pokemon.growth_rate != nil {
//                                                        Text("Growth Rate: \(pokemon.growth_rate!)")
//                                                    }
//                                                    if pokemon.egg_type_1 != "" && pokemon.egg_type_2 != "" {
//                                                        Text("Egg Types: \(pokemon.egg_type_1) & \(pokemon.egg_type_2)")
//                                                    }
//                                                    else if pokemon.egg_type_1 != "" {
//                                                        Text("Egg Type: \(pokemon.egg_type_1)")
//                                                    }
//                                                    // this may not function as intended need to check with pokemon that is trans
//                                                    if pokemon.percent_male != nil {
//                                                        Text(String(format: "Male Population: %2.1f%%", pokemon.percent_male!))
//                                                    }
//                                                    if pokemon.egg_cycles != nil {
//                                                        Text("Egg Cycles: \(pokemon.egg_cycles!)")
//                                                    }
//                    
//                                                }
//                                            }
//                                        }
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                        .padding(-16)
//                                        .padding(.top)
//                    
//                    
//                    
//                    
                    
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
                .padding()
                
            }
            .background(VStack(spacing: .zero) { Color.indigo })
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
    }
}

func calculateWidth(for value: Int, max: Int, columnWidth: CGFloat) -> CGFloat {
    return columnWidth * (CGFloat(value) / CGFloat(max))
}

func colorForStat(_ value: Int, max: Int) -> Color {
    let percentage = CGFloat(value) / CGFloat(max)
        return Color(hue: percentage * 0.33, saturation: 1.0, brightness: 1.0)
}

extension UIColor {
    convenience init(hex: String) {
        let color = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: color)
        var hexNum: UInt64 = 0
        if scanner.scanHexInt64(&hexNum) {
            let red = (hexNum & 0xFF0000) >> 16
            let green = (hexNum & 0x00FF00) >> 8
            let blue = hexNum & 0x0000FF
            
            self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
        }
        else {
            self.init(red: 255, green: 255, blue: 255, alpha: 1.0)
        }
    }
}

#Preview {
    PokemonInfo(selectedImage: UIImage(named: "Bulbasaur_new")!, pokemon: Pokemon(id: 0, pokedex_num: 1, name: "Bulbasaur", jap_name: "フシギダネ (Fushigidane)", generation: 1, status: "Normal", species: "Seed Pokemon", type_num: 2, type_1: "Grass", type_2: "Poison", height_m: 0.7, weight_kg: 6.9, abilities_num: 2, ability_1: "Overgrow", ability_2: "", ability_hidden: "Chlorophyll", stat_total: 318, hp: 45, attack: 49, defense: 49, sp_attack: 65, sp_defense: 65, speed: 45, catch_rate: 45, base_friendship: 70, base_exp: 64, growth_rate: "Medium Slow", egg_type_num: 2, egg_type_1: "Grass", egg_type_2: "Monster", percent_male: 87.5, egg_cycles: 20, against_normal: 1, against_fire: 2, against_water: 0.5, against_electric: 0.5, against_grass: 0.25, against_ice: 2, against_fight: 0.5, against_poison: 1, against_ground: 1, against_flying: 2, against_psychic: 2, against_bug: 1, against_rock: 1, against_ghost: 1, against_dragon: 1, against_dark: 1, against_steel: 1, against_fairy: 0.5), onDismiss: {})
}
