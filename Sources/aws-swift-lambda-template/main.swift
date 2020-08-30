import AWSLambdaRuntime
import AWSLambdaEvents
import Foundation

/// run with `APIGateway` handler
Lambda.run(ApiGatewayHandler.init)

/// run with `Cloudwatch.Scheduled` handler
//Lambda.run(CloudwatchScheduleHandler.init)
