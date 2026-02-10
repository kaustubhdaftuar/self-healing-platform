import json
import boto3
import os


def get_lambda_client():
    return boto3.client("lambda")


def get_target_function_name():
    return os.environ["TARGET_FUNCTION_NAME"]


def lambda_handler(event, context):
    lambda_client = get_lambda_client()
    target_function_name = get_target_function_name()

    response = lambda_client.get_function_configuration(
        FunctionName=target_function_name
    )

    env_vars = response.get("Environment", {}).get("Variables", {})
    env_vars["FAILURE_RATE"] = "0"

    lambda_client.update_function_configuration(
        FunctionName=target_function_name,
        Environment={"Variables": env_vars}
    )

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Remediation applied",
            "target": target_function_name
        })
    }

