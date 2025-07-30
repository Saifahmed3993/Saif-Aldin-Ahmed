<?php
// ===== CONTACT FORM PROCESSING =====

// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Set headers for JSON response
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

// Check if it's a POST request
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
    exit;
}

// Get JSON input
$input = json_decode(file_get_contents('php://input'), true);

// If JSON parsing failed, try POST data
if (!$input) {
    $input = $_POST;
}

// Validate required fields
$required_fields = ['name', 'email', 'subject', 'message'];
$missing_fields = [];

foreach ($required_fields as $field) {
    if (empty($input[$field])) {
        $missing_fields[] = $field;
    }
}

if (!empty($missing_fields)) {
    http_response_code(400);
    echo json_encode([
        'success' => false, 
        'message' => 'Missing required fields: ' . implode(', ', $missing_fields)
    ]);
    exit;
}

// Sanitize input data
$name = filter_var(trim($input['name']), FILTER_SANITIZE_STRING);
$email = filter_var(trim($input['email']), FILTER_SANITIZE_EMAIL);
$subject = filter_var(trim($input['subject']), FILTER_SANITIZE_STRING);
$message = filter_var(trim($input['message']), FILTER_SANITIZE_STRING);

// Validate email
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Invalid email address']);
    exit;
}

// Validate message length
if (strlen($message) < 10) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Message must be at least 10 characters long']);
    exit;
}

// Prepare email content
$to = 'saifahmedelbattawy@gmail.com'; // Saif's email address
$email_subject = "Portfolio Contact: $subject";

$email_body = "
New message from your portfolio website:

Name: $name
Email: $email
Subject: $subject

Message:
$message

---
This message was sent from your portfolio contact form.
";

$headers = [
    'From' => $email,
    'Reply-To' => $email,
    'X-Mailer' => 'PHP/' . phpversion(),
    'Content-Type' => 'text/plain; charset=UTF-8'
];

// Function to send email
function sendEmail($to, $subject, $message, $headers) {
    // Try to send using mail() function
    if (mail($to, $subject, $message, $headers)) {
        return true;
    }
    
    // If mail() fails, try alternative method
    $header_string = '';
    foreach ($headers as $key => $value) {
        $header_string .= "$key: $value\r\n";
    }
    
    return mail($to, $subject, $message, $header_string);
}

// Send email
$email_sent = sendEmail($to, $email_subject, $email_body, $headers);

if ($email_sent) {
    // Log the contact (optional)
    logContact($name, $email, $subject, $message);
    
    echo json_encode([
        'success' => true, 
        'message' => 'Thank you for your message! I will get back to you soon.'
    ]);
} else {
    http_response_code(500);
    echo json_encode([
        'success' => false, 
        'message' => 'Sorry, there was an error sending your message. Please try again later.'
    ]);
}

// Function to log contacts to a file (optional)
function logContact($name, $email, $subject, $message) {
    $log_file = 'contacts.log';
    $timestamp = date('Y-m-d H:i:s');
    $log_entry = "[$timestamp] Name: $name | Email: $email | Subject: $subject | Message: " . substr($message, 0, 100) . "...\n";
    
    // Create logs directory if it doesn't exist
    if (!is_dir('logs')) {
        mkdir('logs', 0755, true);
    }
    
    file_put_contents('logs/' . $log_file, $log_entry, FILE_APPEND | LOCK_EX);
}

// Alternative: Database logging (if you have a database)
function logContactToDatabase($name, $email, $subject, $message) {
    try {
        $pdo = new PDO('mysql:host=localhost;dbname=portfolio', 'username', 'password');
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        
        $stmt = $pdo->prepare("INSERT INTO contacts (name, email, subject, message, created_at) VALUES (?, ?, ?, ?, NOW())");
        $stmt->execute([$name, $email, $subject, $message]);
        
        return true;
    } catch (PDOException $e) {
        // Log error but don't fail the contact form
        error_log("Database error: " . $e->getMessage());
        return false;
    }
}

// Security: Rate limiting (optional)
function checkRateLimit($email) {
    $rate_limit_file = 'logs/rate_limit.log';
    $current_time = time();
    $time_window = 3600; // 1 hour
    $max_requests = 5; // Max 5 requests per hour
    
    // Create logs directory if it doesn't exist
    if (!is_dir('logs')) {
        mkdir('logs', 0755, true);
    }
    
    // Read existing rate limit data
    $rate_data = [];
    if (file_exists($rate_limit_file)) {
        $rate_data = json_decode(file_get_contents($rate_limit_file), true) ?: [];
    }
    
    // Clean old entries
    $rate_data = array_filter($rate_data, function($entry) use ($current_time, $time_window) {
        return $entry['time'] > ($current_time - $time_window);
    });
    
    // Check if email has exceeded limit
    $email_requests = array_filter($rate_data, function($entry) use ($email) {
        return $entry['email'] === $email;
    });
    
    if (count($email_requests) >= $max_requests) {
        return false;
    }
    
    // Add current request
    $rate_data[] = [
        'email' => $email,
        'time' => $current_time
    ];
    
    // Save updated rate limit data
    file_put_contents($rate_limit_file, json_encode($rate_data));
    
    return true;
}

// Apply rate limiting (uncomment if needed)
// if (!checkRateLimit($email)) {
//     http_response_code(429);
//     echo json_encode(['success' => false, 'message' => 'Too many requests. Please try again later.']);
//     exit;
// }
?> 