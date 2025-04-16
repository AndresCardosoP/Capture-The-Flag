from flask import Flask, request, redirect, make_response, render_template, flash, get_flashed_messages
import uuid

app = Flask(__name__)
app.secret_key = 'supersecretkey'
sessions = {}
reports = [
    {
        "title": "Bug in Dashboard",
        "username": "john",
        "content": (
            "Thought the reports section was moved to the main nav for everyone last week?"
            "I still see it on the dashboard, could you get to it bob? It's a bit annoying to have it in two places."
        )
    },
    {
        "title": "Reminder: JS Cleanup",
        "username": "jobe",
        "content": (
            "Hey everyone, just a reminder to clean out `/static/loginTest.js/` from the login page before we go live. "
            "Please get on it asap bob, we don't want any data leaks do we?"
        )
    },
    {
        "title": "Session Tracking Concerns",
        "username": "alex",
        "content": (
            "Just a heads up, users are reporting weird behavior where they see content from other accounts. "
            "There might be some problems related to our session handling. You mind giving it a look bob?"
        )}]
users = {
    "john": {"password": "keyholder", "is_admin": True},
    "alex": {"password": "thegreat15", "is_admin": False},
    "jobe": {"password": "jobeisawesome433", "is_admin": False},
    "bob": {"password": "johnsucks123", "is_admin": False},
    "smith": {"password": "steel658", "is_admin": False},
}

@app.route("/", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")
        
        user = users.get(username)
        if user and user["password"] == password:
            session_id = request.cookies.get("session_id")
            if not session_id:
                session_id = str(uuid.uuid4())
            sessions[session_id] = {
                "username": username,
                "is_admin": user["is_admin"]
            }
            resp = make_response(redirect("/dashboard"))
            resp.set_cookie("session_id", session_id)
            return resp
        else:
            flash("Invalid username or password.", "error")
 
    return render_template("login.html")

@app.route("/dashboard")
def dashboard():
    session_id = request.cookies.get("session_id")
    session = sessions.get(session_id)

    if not session:
        flash("You are not logged in.")
        return redirect("/")
    
    return render_template("dashboard.html", username=session["username"], is_admin=session["is_admin"])

@app.route("/vault")
def vault():
    session_id = request.cookies.get("session_id")
    session = sessions.get(session_id)

    if not session or not session["is_admin"]:
        flash("You are not authorized to access this page.")
        return redirect("/")
    
    with open("flag.txt") as f:
        flag = f.read()
    
    return render_template("vault.html", flag=flag)

@app.route("/profile")
def profile():
    session_id = request.cookies.get("session_id")
    session = sessions.get(session_id)

    if not session:
        flash("You are not logged in.")
        return redirect("/")
    
    return render_template("profile.html", session=session)

@app.route("/submit_report", methods=["GET", "POST"])
def submit_report():
    session_id = request.cookies.get("session_id")
    session = sessions.get(session_id)

    if not session:
        flash("You are not logged in.")
        return redirect("/")

    if request.method == "POST":
        title = request.form.get("title")
        content = request.form.get("content")
        reports.append({"title": title, "content": content, "username": session["username"]})
        flash("Report submitted successfully.")
        return redirect("/dashboard")

    return render_template("submit_report.html")

@app.route("/reports")
def view_reports():
    session_id = request.cookies.get("session_id")
    session = sessions.get(session_id)

    if not session:
        flash("You are not logged in.", "error")
        return redirect("/")
    
    return render_template("reports.html", reports=reports)

@app.route("/logout")
def logout():
    session_id = request.cookies.get("session_id")
    if session_id and session_id in sessions:
        sessions.pop(session_id, None)
    flash("You have been logged out.", "success")
    resp = make_response(redirect("/"))
    resp.delete_cookie("session_id")
    return resp

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)