//
//  CloudwatchScheduleHandler.swift
//  
//
//  Created by Alexey Pichukov on 28.08.2020.
//

import Foundation
import AWSLambdaEvents
import AWSLambdaRuntime
import AsyncHTTPClient
import AWSDynamoDB
import DynamoDBService

struct CloudwatchScheduleHandler: EventLoopLambdaHandler {
    
    typealias In = Cloudwatch.Scheduled
    typealias Out = Void
    
    private let dbService: DBService
    private let tableName = "TestTable"
    private let region: Region = .uswest2
    
    init(context: Lambda.InitializationContext) throws {
        let httpClient = HTTPClient(eventLoopGroupProvider: .shared(context.eventLoop))
        dbService = DBService(httpClient: httpClient, tableName: tableName, region: region)
    }
    
    func handle(context: Lambda.Context, event: In) -> EventLoopFuture<Void> {
        
        /// For example we want to create a new `Item` every time we get `Cloudwatch.Scheduled` `event`
        let item = Item(id: UUID().uuidString, name: "Test Name", value: 10, customMap: ["somKey": 12])
        
        return dbService.create(item: item).map { _ -> Void in return }
    }
}
