//
//  ContentView.swift
//  FightingGame
//
//  Created by Maks Winters on 15.09.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var character1: Character?
    
    var body: some View {
        NavigationView{
            VStack {
                HStack{
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .padding()
                    Text(character1?.name ?? "No name")
                        .font(.system(size: 30))
                    Spacer()
                }
                VStack{
                    Text("Level: \(character1?.level ?? 0), XP: \(character1?.xp ?? 0)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Health \(character1?.health ?? 0): , Armor: \(character1?.armor ?? 0)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Attack: \(character1?.attack ?? 0), CrircalAttack: \(character1?.criticalAttack ?? 0)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Luck: \(character1?.luck ?? 0)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Balance: \(character1?.balance ?? 0)$")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .font(.system(size: 20))
                .padding()
                HStack{
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .padding()
                    Text("Name")
                        .font(.system(size: 30))
                    Spacer()
                }
                VStack{
                    Text("Level: 12, XP: 80")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Health 110: , Armor: 15")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Attack: 6, CrircalAttack: 12")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Luck: 5")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Balance: 200$")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .font(.system(size: 20))
                .padding()
                Spacer()
                Button {
                    
                } label: {
                    Text("Fight!")
                        .frame(width: 100, height: 30)
                }
                .buttonStyle(BorderedButtonStyle())
                .cornerRadius(40)
            }
            .navigationTitle("Kick")
        }
        .task {
            do {
                character1 = try await getCharacter()
            } catch GHError.invalidURL {
                print("Invalid URL")
            } catch GHError.invalidResponse {
                print("Invalid response")
            } catch GHError.invalidData {
                print("Invalid data")
            } catch {
                print("Unexpected error")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct Character: Codable {
    let name: String
    let level, xp, health, armor: Int
    let attack, luck, balance: Int
    let alive: Bool
    let criticalAttack: Int
    
    enum CodingKeys: String, CodingKey {
        case name, level, xp, health, armor, attack, luck, balance, alive
        case criticalAttack = "critical_attack"
    }
}

enum GHError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

func getCharacter() async throws -> Character {
    let endpoint = "http://127.0.0.1:5000/json_endpoint"
    
    guard let url = URL(string: endpoint) else { throw GHError.invalidURL }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw GHError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(Character.self, from: data)
    } catch {
        throw GHError.invalidData
    }
}
