//
//  File.swift
//  
//
//  Created by Alexey Pichukov on 28.08.2020.
//

import Foundation
import AWSLambdaEvents
import AWSLambdaRuntime
import AsyncHTTPClient
import NIO
import AWSDynamoDB
import DynamoDBService

struct ApiGatewayHandler: EventLoopLambdaHandler {
    
    typealias In = APIGateway.V2.Request
    typealias Out = APIGateway.V2.Response
    
    private let dbService: DBService
    private let tableName = "TestTable"
    private let region: Region = .uswest2
    
    init(context: Lambda.InitializationContext) throws {
        let httpClient = HTTPClient(eventLoopGroupProvider: .shared(context.eventLoop))
        dbService = DBService(httpClient: httpClient, tableName: tableName, region: region)
    }
    
    func handle(context: Lambda.Context, event: APIGateway.V2.Request) -> EventLoopFuture<APIGateway.V2.Response> {
        
        switch (event.context.http.path, event.context.http.method) {
            
            case ("/items", .POST):
                return createItem(context: context, event: event)
            
            case ("/items", .PUT):
                return updateItem(context: context, event: event)
            
            case ("/items", .GET):
                return readItem(context: context, event: event)
            
            case ("/items", .DELETE):
                return deleteItem(context: context, event: event)
            
            default:
                return context.eventLoop.makeSucceededFuture(APIGateway.V2.Response(statusCode: .notFound))
        }
    }
    
    // MARK: Private methods
    
    private func createItem(context: Lambda.Context, event: APIGateway.V2.Request) -> EventLoopFuture<APIGateway.V2.Response> {
        guard let item: Item = try? event.decode() else {
            return context.eventLoop.makeSucceededFuture(APIGateway.V2.Response(with: ErrorType.parsing,
                                                                                statusCode: .badRequest))
        }
        return dbService.create(item: item).map { result -> APIGateway.V2.Response in
            switch result {
                case .success:
                    return APIGateway.V2.Response(with: EmptyObject(), statusCode: .ok)
                case .failure(let error):
                    return APIGateway.V2.Response(with: error, statusCode: .badRequest)
            }
        }
    }
    
    private func readItem(context: Lambda.Context, event: APIGateway.V2.Request) -> EventLoopFuture<APIGateway.V2.Response> {
        /// `NOTE`: for `APIGateway` the path parameter is `/items/{id}` for example
        guard let id = event.pathParameters?[Item.primaryKeyField] else {
            return context.eventLoop.makeSucceededFuture(APIGateway.V2.Response(with: ErrorType.parsing,
                                                                                statusCode: .badRequest))
        }
        return dbService.read(itemWithPrimaryKey: id).map { (result: Result<Item, DynamoDBError>) -> APIGateway.V2.Response in
            switch result {
                case .success(let item):
                    return APIGateway.V2.Response(with: item, statusCode: .ok)
                case .failure(let error):
                    return APIGateway.V2.Response(with: error, statusCode: .badRequest)
            }
        }
    }
    
    private func deleteItem(context: Lambda.Context, event: APIGateway.V2.Request) -> EventLoopFuture<APIGateway.V2.Response> {
        /// `NOTE`: for `APIGateway` the path parameter is `/items/{id}` for example
        guard let id = event.pathParameters?[Item.primaryKeyField] else {
            return context.eventLoop.makeSucceededFuture(APIGateway.V2.Response(with: ErrorType.parsing,
                                                                                statusCode: .badRequest))
        }
        return dbService.delete(itemWithPrimaryKey: id,
                                keyFieldName: Item.primaryKeyField).map { (result: Result<Void, DynamoDBError>) -> APIGateway.V2.Response in
            switch result {
                case .success:
                    return APIGateway.V2.Response(with: EmptyObject(), statusCode: .ok)
                case .failure(let error):
                    return APIGateway.V2.Response(with: error, statusCode: .badRequest)
            }
        }
    }
    
    private func updateItem(context: Lambda.Context, event: APIGateway.V2.Request) -> EventLoopFuture<APIGateway.V2.Response> {
        guard let item: Item = try? event.decode() else {
            return context.eventLoop.makeSucceededFuture(APIGateway.V2.Response(with: ErrorType.parsing,
                                                                                statusCode: .badRequest))
        }
        return dbService.update(item: item).map { result -> APIGateway.V2.Response in
            switch result {
                case .success:
                    return APIGateway.V2.Response(with: EmptyObject(), statusCode: .ok)
                case .failure(let error):
                    return APIGateway.V2.Response(with: error, statusCode: .badRequest)
            }
        }
    }
}

