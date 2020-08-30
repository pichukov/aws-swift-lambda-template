//
//  File.swift
//  
//
//  Created by Alexey Pichukov on 28.08.2020.
//

import Foundation

enum ErrorType: Error {
    case general
    case api
    case network
    case parsing
    case db
    case dataTransformation
}
