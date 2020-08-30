//
//  File.swift
//  
//
//  Created by Alexey Pichukov on 27.08.2020.
//

import Foundation

extension JSONEncoder {
    
    func encodeAsString<T: Encodable>(_ value: T) throws -> String {
        try String(decoding: self.encode(value), as: Unicode.UTF8.self)
    }
}
   
extension JSONDecoder {
    
    func decode<T: Decodable>(_ type: T.Type, from string: String) throws -> T {
        try self.decode(type, from: Data(string.utf8))
    }
}
