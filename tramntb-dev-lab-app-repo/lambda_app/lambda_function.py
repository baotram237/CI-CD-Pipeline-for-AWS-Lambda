def handler(event, context):
    print("Hello from Lambda! Test CI/CD pipeline")
    print("Hello from Lambda!")
    return {
        "statusCode": 200,
        "body": "Hello from Lambda!"
    }