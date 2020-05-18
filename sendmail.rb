require 'net/smtp'

$recipient = ARGV[0]
$sender = ARGV[1]
$password = ARGV[2]
$subject = "uulm-lsf-grades"
$msg = "Your received a new grade!"

message = <<END_OF_MESSAGE
From: #{$sender}
To: #{$recipient}
Subject: #{$subject}

#{$msg}
END_OF_MESSAGE


smtp = Net::SMTP.new 'smtp.gmail.com', 587
smtp.enable_starttls
smtp.start('gmail.com', $sender, $password, :login) do |smtp|
  smtp.send_message message, $sender, $recipient
end
