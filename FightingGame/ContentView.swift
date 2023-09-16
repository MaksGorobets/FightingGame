//
//  ContentView.swift
//  FightingGame
//
//  Created by Maks Winters on 15.09.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State var character1: Character?
    @State var character2: Character?
    @State var isButtonPressed: Bool = false
    @State var showSheet: Bool = false
    @State var buttonDisabled: Bool = false
    @State var winner: String = ""
    @State var winnerImage: String = ""
    let character1Image = Int.random(in: 0...5)
    let character2Image = Int.random(in: 0...5)
    let charactersArt = ["character0", "character1", "character2", "character3", "character4", "character5"]
    
    
    private func fetchCharacters() {
            Task {
                do {
                    character1 = try await getCharacter1()
                } catch GHError.invalidURL {
                    print("Invalid URL")
                } catch GHError.invalidResponse {
                    print("Invalid response")
                } catch GHError.invalidData {
                    print("Invalid data")
                } catch {
                    print("Unexpected error")
                }
                
                do {
                    character2 = try await getCharacter2()
                } catch GHError.invalidURL {
                    print("Invalid URL")
                } catch GHError.invalidResponse {
                    print("Invalid response")
                } catch GHError.invalidData {
                    print("Invalid data")
                } catch {
                    print("Unexpected error")
                }
                
                // Reset the button press flag after fetching characters
                isButtonPressed = false
            }
        }
    
    func checkIfAlive() {
        if character1?.alive == false {
            showSheet = true
            buttonDisabled = true
            winner = "\(character2?.name ?? "Unknown")"
            winnerImage = charactersArt[character2Image]
        } else if character2?.alive == false {
            showSheet = true
            buttonDisabled = true
            winner = "\(character1?.name ?? "Unknown")"
            winnerImage = charactersArt[character1Image]
        }
    }
    
    var body: some View {
        NavigationView{
            VStack {
                HStack{
                    Image(charactersArt[character1Image])
                        .resizable()
                        .clipShape(Circle())
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
                    Image(charactersArt[character2Image])
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 70, height: 70)
                        .padding()
                    Text(character2?.name ?? "No name")
                        .font(.system(size: 30))
                    Spacer()
                }
                VStack{
                    Text("Level: \(character2?.level ?? 0), XP: \(character2?.xp ?? 0)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Health \(character2?.health ?? 0): , Armor: \(character2?.armor ?? 0)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Attack: \(character2?.attack ?? 0), CrircalAttack: \(character2?.criticalAttack ?? 0)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Luck: \(character2?.luck ?? 0)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Balance: \(character2?.balance ?? 0)$")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .font(.system(size: 20))
                .padding()
                Spacer()
                Button {
                    isButtonPressed = true
                    fetchCharacters()
                    sendPostRequest()
                    checkIfAlive()
                } label: {
                    Text("Fight!")
                        .frame(width: 100, height: 30)
                }
                .buttonStyle(BorderedButtonStyle())
                .cornerRadius(40)
                .disabled(buttonDisabled)
            }
            .navigationTitle("Kick")
            .task {
                fetchCharacters()
            }
        }
        .sheet(isPresented: $showSheet) {
            Image(winnerImage)
                .cornerRadius(30)
            Text("\(winner) wins!")
                .presentationDetents([.medium])
                .presentationCornerRadius(45)
                .presentationBackground(.thinMaterial)
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

func sendPostRequest() {
    let urlString = "http://127.0.0.1:5000/fight_character"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }

    // Create the POST request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    // Define the POST data (if needed)
    let postData = "c1damage=damage".data(using: .utf8)

    // Set the HTTP body
    request.httpBody = postData

    // Create a URLSession task to send the request
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
        } 
    }
    task.resume()
}

func getCharacter1() async throws -> Character {
    let endpoint = "http://127.0.0.1:5000/character1"
    
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

func getCharacter2() async throws -> Character {
    let endpoint = "http://127.0.0.1:5000/character2"
    
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

