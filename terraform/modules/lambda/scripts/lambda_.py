import base64
import io
import os
import json
import boto3
import pandas as pd

import boto3

s3_client = boto3.client("s3")

bucket_name = os.environ["BUCKET_NAME"]
file_name = os.environ["FILE_NAME"]

class MyResponse:
    SUCCESS_STATUS_CODE = 200
    ERROR_STATUS_CODE = 500
    CONTENT_TYPE_HEADER = {"Content-Type": "application/json"}
    BASE64_ENCODED_HEADER = {"isBase64Encoded": False}

    @classmethod
    def success(cls, body):
        return {
            "statusCode": cls.SUCCESS_STATUS_CODE,
            "headers": cls.CONTENT_TYPE_HEADER,
            "body": body,
            **cls.BASE64_ENCODED_HEADER
        }

    @classmethod
    def error(cls, body):
        return {
            "statusCode": cls.ERROR_STATUS_CODE,
            "headers": cls.CONTENT_TYPE_HEADER,
            "body": body,
            **cls.BASE64_ENCODED_HEADER
        }


def lambda_handler(event, context) -> None:
    """
    AWS Lambda function handler
    """
    
    
    if event.get("isBase64Encoded"):
        user = json.loads(base64.b64decode(event["body"]))
    else:
        print(event)
        user = json.loads(event["body"])
    
    
    try:
        response = s3_client.get_object(
            Bucket=bucket_name, Key=file_name)
        status = response.get("ResponseMetadata", {}).get("HTTPStatusCode")
    except:
        response = None
        status = 500 
        
    print(user)
    
    first_name = user['first_name']
    last_name = user['last_name']
    email = user['email']
    address = user['address']
    photograph = user['photograph']
    photo = user['picture']
    size = user['size']
    frame = user['frame']

    
    if status == 200:
        print(f"Successful S3 get_object response. Status - {status}")
        orders_df = pd.read_csv(response.get("Body"))
        print(orders_df)
        
        # get order id by number of orders already created 
        order_id = len(orders_df) + 1
        
        
        # add a Row 
        orders_df = pd.concat([orders_df, pd.DataFrame([[order_id,first_name,last_name,email,address,photograph,photo,size,frame]], columns = ["order_id","first_name","last_name","email","address","photograph","photo","size","frame"])], ignore_index = True)
        
    else:
        order_id = 1
        orders_df = pd.DataFrame([[order_id,first_name,last_name,email,address,photograph,photo,size,frame]], columns = ["order_id","first_name","last_name","email","address","photograph","photo","size","frame"])

    with io.StringIO() as csv_buffer:
        orders_df.to_csv(csv_buffer, index=False)

        response = s3_client.put_object(
            Bucket=bucket_name, Key=file_name, Body=csv_buffer.getvalue()
        )

        status = response.get("ResponseMetadata", {}).get("HTTPStatusCode")

        if status == 200:
            print(f"Successful S3 put_object response. Status - {status}")
            return MyResponse.success(order_id)
        return MyResponse.error("Error :(")
