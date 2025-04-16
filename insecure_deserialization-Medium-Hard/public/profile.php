<?php
session_start();
if (!isset($_SESSION['user'])) {
  header('Location: login.php');
  exit;
}

// Load necessary class definitions (so unserialize() knows about both Logger and AdminBackdoor)
require_once __DIR__ . '/tmp/Tools/Secret/Backdoor.php';
require_once __DIR__ . '/Logger.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $content = $_POST['content'] ?? '';
  
  if (!empty($content)) {
    // Attempt to treat the posted content as a Base64-encoded serialized object.
    $decoded = base64_decode($content, true);
    $object = false;
    if ($decoded !== false) {
      $object = @unserialize($decoded);
    }
    
    if ($object !== false && is_object($object)) {
      // A valid serialized object was provided.
      // For example, if it's an instance of AdminBackdoor, its __wakeup() will run.
      $logger = $object;
      // Ensure we have a filename; if not, generate one.
      if (empty($logger->filename)) {
        $logger->filename = 'mylog_' . time() . '.log';
      }
      // Save the (crafted) log without re-serializing.
      file_put_contents(__DIR__ . '/logs/' . $logger->filename, $logger->content);
      $message = "Log saved as " . $logger->filename;
    } else {
      // Otherwise, treat the input as a plain-text log.
      $filename = 'mylog_' . time() . '.log';
      $logger = new Logger($filename, $content);
      // Serialize and encode the Logger object.
      $serialized = base64_encode(serialize($logger));
      file_put_contents(__DIR__ . '/logs/' . $filename, $serialized);
      $message = "Log saved as " . $filename;
    }
  }
}
?>
<!DOCTYPE html>
<html>
<head>
  <title>CipherGuard Labs - Profile</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
  <style>
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      background: linear-gradient(135deg, #000000, #434343);
      color: #e0e0e0;
    }
    .header {
      text-align: center;
      padding: 20px;
      background: rgba(0, 0, 0, 0.8);
      border-bottom: 1px solid #333;
    }
    .container {
      max-width: 600px;
      margin: 40px auto;
      background: rgba(0, 0, 0, 0.7);
      padding: 30px;
      border-radius: 8px;
      box-shadow: 0 0 15px rgba(0,0,0,0.7);
    }
    h1 {
      text-align: center;
      margin: 0 0 20px;
      color: #fff;
    }
    textarea {
      width: 100%;
      height: 80px;
      border-radius: 4px;
      border: none;
      padding: 10px;
      margin-bottom: 10px;
    }
    button {
      width: 100%;
      padding: 10px;
      background: #007bff;
      border: none;
      border-radius: 4px;
      color: #fff;
      font-size: 1em;
      cursor: pointer;
      transition: background 0.3s;
    }
    button:hover {
      background: #0056b3;
    }
    .notice {
      margin: 10px 0;
      color: #90ee90;
      font-style: italic;
      text-align: center;
    }
  </style>
</head>
<body>
  <div class="header">
    <h1>CipherGuard Labs</h1>
  </div>
  <div class="container">
    <h1>Hello, <?= htmlspecialchars($_SESSION['user']) ?>!</h1>
    <p>Submit your logs below:</p>
    <form method="POST">
      <textarea name="content" placeholder="Enter your log here..."></textarea>
      <button type="submit">Submit Log</button>
    </form>
    <?php if (!empty($message)): ?>
      <p class="notice"><?= htmlspecialchars($message) ?></p>
    <?php endif; ?>
    <hr style="margin:20px 0; border-color: #333;">
    <p>Other features:</p>
    <nav style="text-align:center;">
      <a href="#"><i class="fas fa-chart-line"></i> Analytics</a>
      <a href="#"><i class="fas fa-cog"></i> Settings</a>
      <a href="#"><i class="fas fa-life-ring"></i> Support</a>
    </nav>
  </div>
</body>
</html>