import SwiftUI
import Foundation

let character1Image = Int.random(in: 0...5)
let character2Image = Int.random(in: 0...5)
let charactersArt = ["character0", "character1", "character2", "character3", "character4", "character5"]

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

func sendInitRequest() {
    let urlString = "http://127.0.0.1:5000/init"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }
    
    // Create the POST request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    // Define the POST data (if needed)
    let postData = "init=init".data(using: .utf8)
    
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

func sendPostRequestMob() {
    let urlString = "http://127.0.0.1:5000/fight_mob"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }
    
    // Create the POST request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    // Define the POST data (if needed)
    let postData = "mob=Ударить".data(using: .utf8)
    
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

func getMob() async throws -> Mob {
    let endpoint = "http://127.0.0.1:5000/mob"
    
    guard let url = URL(string: endpoint) else { throw GHError.invalidURL }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw GHError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(Mob.self, from: data)
    } catch {
        throw GHError.invalidData
    }
}
