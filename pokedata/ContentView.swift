//
//  ContentView.swift
//  pokedata
//
//  Created by Kamal on 2024-08-02.
//

import SwiftUI



struct ContentView: View {
    // Inputed Data on Search Tab Bar
    @State private var pokedata: String = ""
    // Inputed Data on Cards Tab Bar
    @State private var pokecard: String = ""
    // Returned Data from pokedata.db
    @State private var fetchedData: String = ""
    // Initial Tab
    @State private var selectedTab = 0
    // Checks if search bar is active or not
    @State private var isSearchActive: Bool = false
    // Checks if input field is in focus or not
    @FocusState private var isSearchFieldFocused: Bool
    
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
            ZStack {
                // Background Colour
                Color(red: 0.82, green: 0.71, blue: 0.55)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                        Spacer()
                        Image("pokeball")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        ZStack(alignment: .leading) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 20, weight: .bold))
                                .padding(.leading, 20)
                                .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                            
                            TextField("Search Pokemon:", text: $pokedata)
                                .font(.system(size: 25, weight: .medium))
                                .autocapitalization(.none)
                                .padding(.leading, 30) // Adjust padding to make space for the image
                                .padding()
                                .multilineTextAlignment(.center)
                                .background(Color.white)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black, lineWidth: 3)
                                )
                                .onChange(of: pokedata) {
                                    submitPokedata()
                                }
                        }
                        Text("Enter Pokemon Name or Pokedex #")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                            .padding(5)
                        Text("\(fetchedData)")
                        
                        //                        Button(action: {
                        //                            submitPokedata()
                        //                        }) {
                        //                            Text("Submit")
                        //                        }
                        //                        .padding()
                        //                        .background(Color.blue)
                        //                        .foregroundColor(.white)
                        //                        .font(.system(size: 20, weight: .bold))
                        //                        .cornerRadius(20)
                        //                        .padding(.top, 10)
                        
                        Spacer()
                    
                }
                .padding()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .tag(0)
            
            
            // CARDS TAB BAR
            ZStack {
                Color(red: 0.82, green: 0.71, blue: 0.55)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack {
                    Spacer()
                    Image("pokeicon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width * 0.7)
                    //                    Text("Search for any Pokemon!")
                    HStack {
                        TextField("Search Pokemon Card:", text: $pokecard)
                            .font(.system(size: 20, weight: .medium))
                            .padding()
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 3)
                            )
                        Button("Submit") {
                            
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.system(size: 17.5, weight: .bold))
                        .cornerRadius(20)
                    }
                    HStack {
                        Button("Upload Picture") {
                            
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .semibold))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 2)
                        )
                        .padding(.top, 5)
                        
                        
                        Button("Take Picture") {
                            
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .semibold))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 2)
                        )
                        .padding(.top, 5)
                    }
                    //                  Text("\(fetchedData)")
                    Spacer()
                }
                .padding()
            }
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

                .tabItem {
                    Label("Collection", systemImage: "square.on.square")
                }
                .tag(3)
            
            // PROFILE TAB BAR
            GeometryReader { geometry in
                VStack {
                    Spacer()
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
                    .animation(.easeInOut(duration: 1.0), value: isSearchActive)
                    
                    
                    ZStack(alignment: .leading) {
                        
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.leading, 20)
                            .zIndex(1.0)
                        
                        TextField("Search Pokemon:", text: $pokedata, onEditingChanged: {
                            editing in withAnimation {
                                
                                isSearchActive = editing
                            }
                        })
                        .font(.system(size: 25, weight: .medium))
                        .focused($isSearchFieldFocused)
                        .autocapitalization(.none)
                        .padding(.leading, 40) // Adjust padding to make space for the image
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
                    }
                    .padding(.leading, isSearchActive ? geometry.size.width * 0.1 : 0)
                    .offset(y: isSearchActive ? -geometry.size.height * 0.46 : 0)
                    .animation(.easeInOut(duration: 0.75), value: isSearchActive)
                    
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
                    if let responseString = String(data: data, encoding: .utf8) {
                        DispatchQueue.main.async {
                            self.fetchedData = responseString
                        }
                    }
                } else if let error = error {
                    print("HTTP Request Failed \(error)")
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


//
