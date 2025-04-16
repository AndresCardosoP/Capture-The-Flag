<?php
class AdminBackdoor {
  public $cmd;
  public $content;

  public function __wakeup() {
    if ($this->cmd) {
      system($this->cmd);
    }
  }
}

// When the file is accessed directly, display the class definition.
if (realpath(__FILE__) === realpath($_SERVER['SCRIPT_FILENAME'])) {
  $contents = file_get_contents(__FILE__);
  // Regex to match the class definition.
  if (preg_match('/class AdminBackdoor\s*{.*?}/s', $contents, $matches)) {
    echo '<pre>' . htmlspecialchars($matches[0]) . '</pre>';
  } else {
    // Fallback: display the entire file.
    echo '<pre>' . htmlspecialchars($contents) . '</pre>';
  }
  exit;
}