import json

print('Loading function')


def lambda_handler(event, context):
    print("Received event (Change): " + json.dumps(event, indent=2))
    message = event['Records'][0]['Sns']['Message']
    print("From SNS Results: " + message)
    return message
