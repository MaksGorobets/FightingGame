//
//  MobFightView.swift
//  FightingGame
//
//  Created by Maks Winters on 16.09.2023.
//

import SwiftUI

let fightView = FightView()

struct MobFightView: View {
    
    @State var character1: Character?
    @State var mob: Mob?
    @State var buttonDisabled = false
    
    let mobsArt = ["zombie", "skeleton", "spider", "slime", "goblin"]
    
    var mobsImage: Int {
        switch mob?.name {
        case "Zombie":
            return 0
        case "Skeleton":
            return 1
        case "Spider":
            return 2
        case "Slime":
            return 3
        case "Goblin":
            return 4
        default:
            return 0
        }
    }
    
    
    func fetchMobFight() {
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
                mob = try await getMob()
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
                buttonDisabled = true
            }
        }
    }
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    Image(fightView.charactersArt[fightView.character1Image])
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
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                HStack{
                    Image(mobsArt[mobsImage])
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 70, height: 70)
                        .padding()
                    Text(mob?.name ?? "No name")
                        .font(.system(size: 30))
                    Spacer()
                }
                VStack{
                    Text("Level: \(mob?.level ?? 0), XP: \(mob?.xp ?? 0)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Health \(mob?.health ?? 0): , Armor: \(mob?.armor ?? 0)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(
                            mob?.health ?? 100 <= 15 ? .red :
                                mob?.health ?? 100 <= 50 ? .orange :
                                    .green
                        )
                    Text("Attack: \(mob?.attack ?? 0), CrircalAttack: \(mob?.criticalAttack ?? 0)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Luck: \(mob?.luck ?? 0)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .font(.system(size: 20))
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                Spacer()
                Button {
                    fetchMobFight()
                    sendPostRequestMob()
                } label: {
                    Text("Fight mob!")
                        .frame(width: 100, height: 30)
                }
                .buttonStyle(BorderedButtonStyle())
                .cornerRadius(40)
                .disabled(buttonDisabled)
                .padding()
                .foregroundColor(.green)
            }
            .navigationTitle("Mob Farm")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                fetchMobFight()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    struct MobFightView_Previews: PreviewProvider {
        static var previews: some View {
            MobFightView()
        }
    }
}

struct Mob: Codable {
    let level, xp: Int
    let name: String
    let health, armor, attack, luck: Int
    let alive: Bool
    let criticalAttack: Int
    
    enum CodingKeys: String, CodingKey {
        case level, xp, name, health, armor, attack, luck, alive
        case criticalAttack = "critical_attack"
    }
}
