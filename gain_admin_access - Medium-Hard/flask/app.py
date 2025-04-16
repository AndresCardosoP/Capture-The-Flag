from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
import jwt
from jwt import InvalidTokenError
from datetime import datetime, timedelta
import os

app = Flask(__name__, static_folder="frontend/web")
CORS(app)

# Serve the frontend
@app.route("/", defaults={"path": ""})
@app.route("/<path:path>")
def serve(path):
    if path != "" and os.path.exists(f"frontend/web/{path}"):
        return send_from_directory("frontend/web", path)
    else:
        return send_from_directory("frontend/web", "index.html")


# Load keys
with open("private.pem", "r") as f:
    PRIVATE_KEY = f.read()

with open("public.pem", "r") as f:
    PUBLIC_KEY = f.read()

@app.route("/")
def home():
    return "JWT Confusion CTF Server is running!"

@app.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    username = data.get("username", "guest")

    payload = {
        "username": username,
        "admin": False,
        "exp": datetime.utcnow() + timedelta(minutes=10)
    }

    print(payload)

    token = jwt.encode(payload, PRIVATE_KEY, algorithm="RS256").decode('utf-8')

    return jsonify({"token": token})

@app.route("/.well-known/jwks.json")
def jwks():
    return jsonify({
        "keys": [
            {
                "kty": "RSA",
                "kid": "test",
                "use": "sig",
                "n": 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArcqwnNCWhp45zzOGewwHmU2jCh/1pIWP9owrr80V7S4rhxwuPdgSYxnMsH2y6wfqua+7ukvStNa9Q+DtnETLpHTEreFnihOGUj2VW9txYw72RLpb8apB9yuDWTyUeiLimyYqi0edkCtSKEdGXBEd3YTSAHRtsYs8x1HDMXDzfmLVtSJSjS7C3mjy5og4yy3jBHQDGkAFK560RG07zrTt7SLDSy71fBwkMuZ8jyPWWPr+ogQjJ2Bcha60mr0EnPgNHCFNKBmDWVkhXupGfPhJGBuEAzrAE+DppJkCSqTvh++aJ8oRArzlM8TnBS2oi7ZIs0s7/yqo/R5GWw+5qdO+jwIDAQAB',
                "e": "AQAB",
            }
        ]
    })

@app.route("/admin", methods=["GET"])
def admin():
    auth_header = request.headers.get("Authorization")
    if not auth_header:
        return "Missing token", 401

    try:
        token = auth_header.split(" ")[1]

        decoded = jwt.decode(token, PUBLIC_KEY, algorithms=["HS256", "RS256"],options={"verify_signature": False})
        
        if decoded.get("admin"):
            print("User is admin")
            return "🎉 FLAG: jwt-algo-confused --success", 200
        else:
            print("User is not admin")
            return "🚫 Access denied. You are not an admin.", 403

    except InvalidTokenError as e:
        print(f"Invalid token: {str(e)}")
        return f"Invalid token: {str(e)}", 400

if __name__ == "__main__":
    app.run(debug=True)
