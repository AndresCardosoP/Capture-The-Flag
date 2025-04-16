<?php
class Logger {
  public $filename;
  public $content;
  public function __construct($fn, $ct) {
    $this->filename = $fn;
    $this->content  = $ct;
  }
}