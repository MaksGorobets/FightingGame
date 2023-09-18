//
//  NavigationTabView.swift
//  FightingGame
//
//  Created by Maks Winters on 16.09.2023.
//

import SwiftUI

struct FightView: View {
    
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
    
    
    func fetchCharacters() {
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
            
            if character1?.health ?? 100 <= 0 {
                winner = character2?.name ?? "Unknown"
                winnerImage = charactersArt[character2Image]
                buttonDisabled = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showSheet = true
                }
            }
            if character2?.health ?? 100 <= 0 {
                winner = character1?.name ?? "Unknown"
                winnerImage = charactersArt[character1Image]
                buttonDisabled = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showSheet = true
                }
            }
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
                        .foregroundStyle(
                            character1?.health ?? 100 <= 15 ? .red :
                                character1?.health ?? 100 <= 50 ? .orange :
                                    .green
                        )
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
                        .foregroundStyle(
                            character2?.health ?? 100 <= 15 ? .red :
                                character2?.health ?? 100 <= 50 ? .orange :
                                    .green
                        )
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
                    fetchCharacters()
                    sendPostRequest()
                } label: {
                    Text("Fight!")
                        .frame(width: 100, height: 30)
                }
                .buttonStyle(BorderedButtonStyle())
                .cornerRadius(40)
                .disabled(buttonDisabled)
                .padding()
                .foregroundColor(.purple)
            }
            .navigationTitle("Fight")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                fetchCharacters()
            }
        }
        .sheet(isPresented: $showSheet) {
            Image(winnerImage)
                .resizable()
                .cornerRadius(30)
                .frame(width: 250, height: 250)
                .padding()
            Text("\(winner) wins!")
                .presentationDetents([.medium])
                .presentationCornerRadius(45)
                .presentationBackground(.thinMaterial)
            Button("OK") {
                showSheet = false
            }
            .buttonStyle(BorderedButtonStyle())
            .foregroundColor(.orange)
            .cornerRadius(30)
        }
    }
}

struct FightView_Previews: PreviewProvider {
    static var previews: some View {
        FightView()
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
