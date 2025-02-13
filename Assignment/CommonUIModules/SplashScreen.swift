//
//  SplashScreen.swift
//  Assignment
//
//  Created by Praval Gautam on 13/02/25.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack {
                    Color.blue
                    VStack {
                        Image(systemName: "bolt.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.yellow)
                        Text("Pokémon World")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                
                ZStack {
                    Color.green
                    VStack {
                        Image(systemName: "leaf.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                        Text("Food Delight")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
            }
            
            VStack {
                Spacer()
                NavigationLink(destination: ContentView()) {
                            Text("Continue")
                                .font(.title3)
                                .fontWeight(.light)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.black)
                                .cornerRadius(30)
                                .padding(.horizontal)
                        }
                .padding(.bottom, 50)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SplashScreen()
}
