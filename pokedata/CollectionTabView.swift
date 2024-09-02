//
//  CollectionTabView.swift
//  pokedata
//
//  Created by Kamal on 2024-08-30.
//

import SwiftUI

struct CollectionTabView: View {
    @AppStorage("user_id") var user_id: Int = 0
    
    @Binding var selectedCard: PokemonCard?
    @Binding var market: String
    @Binding var showLoginView: Bool
    @Binding var showRegisterView: Bool
    @Binding var message: String
    @Binding var errorCode: String
    @Binding var fault: Bool
    let onDismiss: () -> Void
    
    @State private var isLoading: Bool = false
    @State private var isWaiting: Bool = false
    @State private var shown: [String: Bool] = [:]
    @State private var activeSeries: [Series] = []
    @State var showCardDetail: Bool = false
    @State private var collection: [PokemonCard] = []
    @State private var buttonWidth: CGFloat = 0
    
    
    var body: some View {
        GeometryReader { geometry in
            if !showCardDetail {
                
                    VStack {
                        GroupBox {
                            HStack {
                                Text("Collection")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            
                            if !isWaiting {
                                Divider()
                                .padding(.top, isWaiting ? 0 : -4)
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
                                        .font(.title)
                                        .bold()
                                        .foregroundStyle(Color.green)
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
                                    ForEach(activeSeries.indices, id: \.self) { index in
                                        let serie = activeSeries[index]
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
                                                                let cardCount = collection.filter { $0.setId == set.id }.count
                                                                if !isWaiting {
//                                                                    withAnimation (.easeInOut(duration: 2)) {
                                                                        Text("\(cardCount)/\(set.total) Collected")
//                                                                    }
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
                                                        .foregroundStyle(.green)
                                                    }
                                                    
                                                    if shown[set.id] ?? false {
                                                        Divider()
                                                            .padding(.bottom, 4)
                                                        if !isWaiting {
                                                            // Filter and sort the cards
                                                            let filteredAndSortedCards = collection
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
                                                                                
                                                                                if let num = extract(from: pokemonCard.number) {
                                                                                    Text("#\(num)")
                                                                                        .padding(.top, 8)
                                                                                        .font(.system(size: geometry.size.width * 0.02))
                                                                                        .fontWeight(.semibold)
                                                                                        .foregroundStyle(Color.white)
                                                                                        .shadow(color: Color.black, radius: 2)
                                                                                        .shadow(color: Color.black, radius: 2)
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
//                                                GroupBox {
//                                                    HStack {
//                                                        VStack {
//                                                            HStack {
//                                                                Spacer().frame(width: geometry.size.width*0.07 + 4)
//                                                                Spacer()
//                                                                AsyncImage(url: URL(string: set.logo)) { image in
//                                                                    image.resizable().scaledToFit().frame(height: geometry.size.height * 0.1)
//                                                                } placeholder: {
//                                                                    Text("Image of Set")
//                                                                }
//                                                                Spacer()
//                                                            }
//                                                            HStack {
//                                                                Spacer().frame(width: geometry.size.width*0.07 + 4)
//                                                                AsyncImage(url: URL(string: set.symbol)) { image in
//                                                                    image.resizable().scaledToFit().frame(width: geometry.size.width * 0.06)
//                                                                } placeholder: {
//                                                                    Text("Image of Set")
//                                                                }
//                                                                Text("0/\(set.total) Collected")
//                                                            }
//                                                        }
//                                                        Button {
//                                                            withAnimation {
//                                                                shown[set.id] = !(shown[set.id] ?? false)
//                                                            }
//                                                        } label: {
//                                                            Image(systemName: shown[set.id] ?? false ? "chevron.up" : "chevron.down")
//                                                                .resizable()
//                                                                .scaledToFit()
//                                                                .frame(width: geometry.size.width*0.07)
//                                                                .symbolVariant(.circle.fill)
//                                                                .padding(.trailing, -4)
//                                                                .padding(.leading, 8)
//                                                        }
//                                                        .foregroundStyle(.green)
//                                                    }
//                                                    if shown[set.id] ?? false {
//                                                        Divider()
//                                                            .padding(.bottom, 4)
//
//                                                        ForEach(collection, id: \.self) { collected in
//                                                            let filteredCards collected.filter { $0.setId == set.id }
//                                                            sortedCards = filteredCards.sorted {
//                                                                if let firstNumber = extract(from: $0.number), let secondNumber = extract(from: $1.number) {
//                                                                    return firstNumber < secondNumber
//                                                                }
//                                                                return false
//                                                            }
//                                                        }
//                                                        let rows = sortedCards.chunked(into: 7)
//                                                        ForEach(rows id: \.self) { row in
//                                                            HStack {
//                                                                ForEach(row, id: \.id) { pokemonCard in
//                                                                    if pokemonCard.setId == set.id {
//                                                                        Button(action: {
//                                                                            withAnimation(.easeInOut) {
//                                                                                selectedCard = pokemonCard
//                                                                                market = calculateMarketPrice(for: pokemonCard)
//                                                                                showCardDetail = true
//                                                                            }
//                                                                        }) {
//                                                                            ZStack (alignment: .bottomTrailing){
//                                                                                AsyncImage(url: URL(string: pokemonCard.lowImageURL)) { image in
//                                                                                    image.resizable().scaledToFit().opacity(0.7).frame(height: geometry.size.width * 0.18)
//                                                                                } placeholder: {
//                                                                                    Text("Image of Pokemon Card")
//                                                                                }
//                                                                            }
//                                                                        }
//                                                                    }
//                                                                }
//                                                            }
//                                                        }
//                                                    }
//                                                }
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
                }
            }
            VStack {
                if showCardDetail, let selectedCard = selectedCard {
                    PokemonCardInfo(
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
        }
        .onAppear {
            fetchSets()
            fetchCollection()
            for serie in activeSeries {
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
        guard let url = URL(string: "http://127.0.0.1:5000/collection?user_id=\(user_id)") else {
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
            
            if let data = data {
                do {
                    let pokemonCard = try JSONDecoder().decode([PokemonCard].self, from: data)
                    DispatchQueue.main.async {
                        collection = pokemonCard
                        isWaiting = false
//                        print(collection)
                    }
                } catch {
                    print("Error converting data to JSON: \(error)")
                }
            }
        }.resume()
    }
    func fetchSets() {
        isLoading = true
        guard let url = URL(string: "http://127.0.0.1:5000/sets?user_id=\(user_id)") else {
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
            if let response = response as? HTTPURLResponse {
                print("HTTP Response: \(response)")
            }
            if let data = data {
                print("Raw Data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")
                do {
                    let series = try JSONDecoder().decode([Series].self, from: data)
                    DispatchQueue.main.async {
                        activeSeries = series
                        isLoading = false
//                        print("Active Series Data: \(activeSeries)")
                    }
                } catch {
                    print("Error converting data to JSON: \(error)")
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
        for card in collection {
            for type in priceTypes {
                if let price = card.tcgPricesMarket[type] {
                    if let num = price {
                        total += num
                    }
                }
            }
        }
        return total
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

#Preview {
    CollectionTabView(selectedCard: .constant(nil), market: .constant("0.55 USD"), showLoginView: .constant(true), showRegisterView: .constant(false), message: .constant("OK"), errorCode: .constant("Status Code: 200"), fault: .constant(false), onDismiss: {})
}
