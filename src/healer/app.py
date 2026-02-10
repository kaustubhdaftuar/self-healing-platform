import json
import boto3
import os

lambda_client = boto3.client("lambda")

TARGET_FUNCTION_NAME = os.environ["TARGET_FUNCTION_NAME"]

def lambda_handler(event, context):
    response = lambda_client.get_function_configuration(
        FunctionName=TARGET_FUNCTION_NAME
    )

    env_vars = response.get("Environment", {}).get("Variables", {})
    env_vars["FAILURE_RATE"] = "0"

    lambda_client.update_function_configuration(
        FunctionName=TARGET_FUNCTION_NAME,
        Environment={"Variables": env_vars}
    )

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Remediation applied",
            "target": TARGET_FUNCTION_NAME
        })
    }
