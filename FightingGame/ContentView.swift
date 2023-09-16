//
//  ContentView.swift
//  FightingGame
//
//  Created by Maks Winters on 15.09.2023.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FightView()
                .tabItem {
                    Image(systemName: "figure.socialdance")
                    Text("Fight")
                }
            MobFightView()
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Mob Fight")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
