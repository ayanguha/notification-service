import json
import boto3
import os 
client = boto3.client('sns')
SNS_ARN = os.environ['target_sns_topic_arn']
print(SNS_ARN)
def lambda_handler(event, context):
   response = client.publish(TopicArn=SNS_ARN,Message="Test message from notification-service-consolidator with Env Var")
   print("Message published")
   return(response)