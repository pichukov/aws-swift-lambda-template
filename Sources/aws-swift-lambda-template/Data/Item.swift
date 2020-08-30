//
//  Item.swift
//  
//
//  Created by Alexey Pichukov on 28.08.2020.
//

import AWSDynamoDB
import DynamoDBService
import Foundation

struct Item: Codable {
    
    let id: String
    let name: String
    let value: Double
    let customMap: [String: Double]
    
    struct DBField {
        static let id = "id"
        static let name = "name"
        static let value = "value"
        static let customMap = "customMap"
    }
}

extension Item: DynamoDBConvertable {
    
    static var primaryKeyField: String {
        return DBField.id
    }
    
    var primaryKeyValue: String {
        return id
    }
    
    var dbItem: [String: DynamoDB.AttributeValue] {
        return [
            DBField.id: .s(id),
            DBField.name: .s(name),
            DBField.value: .n(String(value)),
            DBField.customMap: .m(dbDictionary)
        ]
    }
    
    init(withDBItem dbItem: [String: DynamoDB.AttributeValue]) throws {
        if case .s(let id) = dbItem[DBField.id],
            case .s(let name) = dbItem[DBField.name],
            case .n(let value) = dbItem[DBField.value],
            case .m(let map) = dbItem[DBField.customMap]
        {
            guard let numValue = Double(value) else {
                throw ErrorType.dataTransformation
            }
            var numCustomMap: [String: Double] = [:]
            for key in map.keys {
                if case .n(let value) = map[key] {
                    guard let numValue = Double(value) else {
                        throw ErrorType.dataTransformation
                    }
                    numCustomMap[key] = numValue
                } else {
                    throw ErrorType.dataTransformation
                }
            }
            self.id = id
            self.name = name
            self.value = numValue
            self.customMap = numCustomMap
        } else {
            throw ErrorType.dataTransformation
        }
    }
    
    private var dbDictionary: [String: DynamoDB.AttributeValue] {
        var result: [String: DynamoDB.AttributeValue] = [:]
        for key in customMap.keys {
            guard let value = customMap[key] else {
                continue
            }
            result[key] = .n(String(value))
        }
        return result
    }
}
