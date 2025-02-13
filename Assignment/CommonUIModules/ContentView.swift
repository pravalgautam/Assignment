//
//  ContentView.swift
//  Assignment
//
//  Created by Praval Gautam on 13/02/25.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var coreDataProvider = CoreDataProvider()
    @State private var isNavigating = false
    @State private var showFavorites = false
    
    var body: some View {
        NavigationStack {
            VStack {
                FoodView()
                    .environment(\.managedObjectContext, coreDataProvider.container.viewContext)
                
                NavigationLink(
                    destination: FavoritesView().navigationBarBackButtonHidden()
                        .environment(\.managedObjectContext, coreDataProvider.container.viewContext),
                    isActive: $showFavorites
                ) {
                    EmptyView()
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showFavorites.toggle()
                    }) {
                        Text("Show Favorites")
                            .font(.headline)
                            .padding(8)
                            .background(Color.pink)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
        
                ToolbarItem(placement: .navigationBarTrailing) {
                    Toggle(isOn: $isNavigating) {
                        Text("Pokemon")
                            .font(.headline)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .black))
                }
            }
            .background(
                NavigationLink("", isActive: $isNavigating) {
                    PokeMonView(isNavigating: $isNavigating)
                        .environment(\.managedObjectContext, coreDataProvider.container.viewContext)
                        .navigationBarBackButtonHidden()
                }
                    .hidden()
            )
        }
    }
}

#Preview {
    ContentView()
}

#Preview {
    FavoritesView()
}


