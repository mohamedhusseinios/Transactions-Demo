//
//  APIError.swift
//  Transactions-Demo
//
//  Created by Mohamed Abdulrahman on 05/11/2026.
//

import Foundation

enum APIError: Error, LocalizedError {
    case badURL, badResponse, decodingFailed

    var errorDescription: String? {
        switch self {
        case .badURL: return "Invalid request URL."
        case .badResponse: return "The server returned an unexpected response."
        case .decodingFailed: return "Could not read transactions from the response."
        }
    }
}
