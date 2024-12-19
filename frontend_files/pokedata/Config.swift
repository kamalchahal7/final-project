//
//  Config.swift
//  pokedata
//
//  Created by Kamal on 2024-09-30.
//
import Foundation

struct Config {
    static let environment: Environment = .production // Change this to .production for live builds
    
    static var baseURL: String {
        switch environment {
        case .development:
            return "https://192.xxx.xx.xx:5000"
        case .production:
            return "http://127.0.0.1:5000"
        }
    }
    
    enum Environment {
        case development
        case production
    }
}
