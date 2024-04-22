//
//  URL Session + Data.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 07.03.2024.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case decodingError
}

