<?php
session_start();
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $_SESSION['user'] = $_POST['username'];
  header('Location: profile.php');
  exit;
}
?>
<!DOCTYPE html>
<html>
<head>
  <title>CipherGuard Labs - Sign Up</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
  <style>
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      background: linear-gradient(135deg, #000000, #434343);
      color: #e0e0e0;
      display: flex;
      align-items: center;
      justify-content: center;
      height: 100vh;
    }
    .register-container {
      background: rgba(0, 0, 0, 0.8);
      padding: 40px;
      border-radius: 8px;
      box-shadow: 0 0 15px rgba(0,0,0,0.7);
      width: 25%;
      height: 40%;
      text-align: center;
    }
    h2 {
      margin-bottom: 20px;
      font-size: 1.8em;
    }
    input[type="text"],
    input[type="password"] {
      width: 50%;
      padding: 20px;
      margin: 2.5% 5%;
      border: none;
      border-radius: 4px;
    }
    button {
      width: 35%;
      padding: 10px;
      background: #007bff;
      border: none;
      border-radius: 4px;
      color: #fff;
      font-size: 1em;
      margin: 10px 0;
      cursor: pointer;
      transition: background 0.3s;
    }
    button:hover {
      background: #0056b3;
    }
    .switch {
      margin-top: 15px;
      font-size: 0.9em;
    }
    .switch a {
      color: #007bff;
      text-decoration: none;
    }
    .switch a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
  <div class="register-container">
    <h2>Sign Up for CipherGuard</h2>
    <form method="POST">
      <input type="text" name="username" placeholder="Username" required>
      <input type="password" name="password1" placeholder="Password" required>
      <input type="password" name="password2" placeholder="re-Type Password" required>
      <button type="submit">Sign Up</button>
    </form>
    <div class="switch">
      Already have an account? <a href="login.php">Log In</a>
    </div>
  </div>
</body>
</html>