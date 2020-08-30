# AWS Swift Lambda Template

The goal of this package is to have a simple template for AWS Lambda on Swift.

#### DBService

`DBService` is a `CRUD` implementation wrapper for `AWSDynamoDB`.

The `item` representation from the data base should confirm `DynamoDBConvertable` protocol:

```swift
protocol DynamoDBConvertable {
    static var primaryKeyField: String { get }
    var primaryKeyValue: String { get }
    var dbItem: [String: DynamoDB.AttributeValue] { get }
    init(withDBItem dbItem: [String: DynamoDB.AttributeValue]) throws
}
```

- `primaryKeyField` is a name of `primaryKey` in `DynamoDB` table
- `primaryKeyValue` is a value of `primaryKey` in `item` object
- `dbItem` is a representation of your object for `DynamoDB`

#### Handlers

You will find two test handlers in the package:
1. `ApiGatewayHandler` implements a `CRUD` functionality for `\items` test resource. For each endpoint it calls a `DBService` function respectively.
2. `CloudwatchScheduleHandler` is a simple `Cloudwatch.Scheduled` event implementation. It will handle any scheduled event from `CloudWatch` and create a new `item` in `DynamoDB` using `DBService`.

#### Run Locally on Mac OS

To run lambda locally on Mac OS you need to add `LOCAL_LAMBDA_SERVER_ENABLED` with value `true` as an `Environment Variable`
- Open `Edit Scheme...` menu
- In `Run` section add `LOCAL_LAMBDA_SERVER_ENABLED` variable with value `true`

#### Build for AWS

1. Execute `docker build` command
```bash
$ docker build -t aws-swift-lambda-template-image .
```
2. Execute `docker run` command
```bash
$ docker run \ 
    --rm \
    --volume "$(pwd)/:/src" \
    --workdir "/src/" \
    aws-swift-lambda-template-image \
    swift build --product aws-swift-lambda-template -c release
```
3. Execute `docker run` command
```bash
$ docker run \
    --rm \
    --volume "$(pwd)/:/src" \
    --workdir "/src/" \
    aws-swift-lambda-template-image \
    scripts/package.sh aws-swift-lambda-template
```
4. Take a `lambda.zip` from `.build/lambda/aws-swift-lambda-template` folder and upload to `AWS` 🎉