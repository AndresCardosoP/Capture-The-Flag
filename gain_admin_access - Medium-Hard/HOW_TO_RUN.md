# Load the Docker Files

**Path to Docker archive:**
```
\ctf-major-project-middlecase-a\gain_admin_access - Medium-Hard\jwt-working.tar
```
---

### 🐧 For Linux/macOS:

```bash
sudo docker load -i jwt-working.tar
sudo docker run -p 5000:5000 jwt-working
```

### 🪟 For Windows:
Open Docker Desktop

Open a shell (e.g., Command Prompt or PowerShell) inside the flask-docker directory.

Run:

```
docker load -i jwt-working.tar
docker run -p 5000:5000 jwt-working
```

### 🌐 Navigate to the app in your browser:
```http://127.0.0.1:5000```



# To use the generate_key.py

This code uses an older version of PyJWT so you will likely have to uninstall the current version you have and install the old one

### 🐧 For Linux/macOS:

#### If using a virtual environment or recommended Kali Image

uninstall with 

```sudo apt remove python3-jwt```

install new package with 

```
python3 -m venv venv
source venv/bin/activate
pip install "PyJWT<2"
```

#### Without a virtual environemnt

```sudo pip uninstall pyjwt```

```sudo pip install pyjwt<2.0.0```

### 🪟 For Windows:

```pip uninstall pyjwt```

```pip install pyjwt<2.0.0```
