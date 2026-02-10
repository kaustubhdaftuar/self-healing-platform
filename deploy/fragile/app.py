import json
import random
import time
import os

# Control failure injection
FAILURE_RATE = float(os.environ.get("FAILURE_RATE", 0))

def lambda_handler(event, context):
    # Simulate downstream API timeout
    if random.random() < FAILURE_RATE:
        time.sleep(2)  # simulate slow dependency
        raise Exception("Downstream API timeout")

    return {
        "statusCode": 200,
        "body": json.dumps({
            "status": "healthy",
            "failure_rate": FAILURE_RATE
        })
    }
