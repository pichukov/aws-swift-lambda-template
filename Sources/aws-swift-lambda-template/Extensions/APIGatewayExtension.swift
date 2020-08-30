//
//  APIGatewayExtension.swift
//  
//
//  Created by Alexey Pichukov on 28.08.2020.
//

import AWSLambdaEvents
import Foundation

extension APIGateway.V2.Request {
    
    func decode<T: Decodable>() throws -> T {
        guard let jsonString = body?.data(using: .utf8) else {
            throw ErrorType.parsing
        }
        let result = try JSONDecoder().decode(T.self, from: jsonString)
        return result
    }
}

extension APIGateway.V2.Response {
    
    public static let defaultHeaders = [
        "Content-Type": "application/json",
    ]
    
    public init(with error: Error, statusCode: AWSLambdaEvents.HTTPResponseStatus) {
        var body = ""
        let errorResponse = ErrorResponse(error: String(describing: error))
        if let data = try? JSONEncoder().encodeAsString(errorResponse) {
            body = data
        }
        self.init(
            statusCode: statusCode,
            headers: APIGateway.V2.Response.defaultHeaders,
            multiValueHeaders: nil,
            body: body,
            isBase64Encoded: false
        )
    }
    
    public init<T: Encodable>(with item: T, statusCode: AWSLambdaEvents.HTTPResponseStatus) {
        var body = ""
        if let data = try? JSONEncoder().encodeAsString(item) {
            body = data
        }
        self.init(
            statusCode: statusCode,
            headers: APIGateway.V2.Response.defaultHeaders,
            multiValueHeaders: nil,
            body: body,
            isBase64Encoded: false
        )
    }
}
