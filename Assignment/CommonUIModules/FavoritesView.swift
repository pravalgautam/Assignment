//
//  FavoritesView.swift
//  Assignment
//
//  Created by Praval Gautam on 14/02/25.
//

import SwiftUI
import CoreData

struct FavoritesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: FavoriteItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteItem.name, ascending: true)]
        
    ) private var favoriteItems: FetchedResults<FavoriteItem>
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            
            Color.orange.opacity(0.5).ignoresSafeArea()
            
            VStack {
                
                
                ScrollView {
                    ForEach(favoriteItems, id: \.self) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                
                                HStack(spacing:20){
                                    AsyncImage(url: URL(string: item.url ?? "")) { image in
                                        image.resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(10)
                                    } placeholder: {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    }
                                    Text(item.name ?? "Unknown Name")
                                        .font(.headline)
                                        .bold()
                                        .foregroundColor(.black)
                                        .padding(.bottom, 5)
                                    Spacer()
                                    Button(action: {
                                        deleteItem(item)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Circle().fill(Color.red))
                                            .shadow(radius: 5)
                                            .padding(.trailing, 15)
                                    }.padding(.leading)
                                        .frame(width: 44, height: 44)
                                }
                            }
                            .padding(10)
                            .cornerRadius(15)
                            .shadow(radius: 10)
                            .frame(maxWidth:.infinity)
                            .background(Color.white)
                            .cornerRadius(25)
                            
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                }
            }
            .padding(.top, 20)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 30, height: 30)
                        .overlay{
                            Image(systemName: "arrow.left")
                                .foregroundColor(.orange)
                        }.padding(.top)
                    
                }
            })
        }
        
    }
    
    private func deleteItem(_ item: FavoriteItem) {
        withAnimation {
            viewContext.delete(item)
            do {
                try viewContext.save()
            } catch {
                print("Error deleting item: \(error)")
            }
        }
    }
}

#Preview {
    FavoritesView()
}
