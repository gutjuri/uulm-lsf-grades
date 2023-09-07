Update: As Uni Ulm no longer offers a HTML view of one's grades, this project does no longer work.

# uulm-lsf-grades

Get your grades on the command line!

## Prerequisites

- Have ruby installed (a recent version).
- Have nokogiri installed (if not, type `gem install nokogiri`).
- Be a student at ulm university.

## Usage

Fill in your information in credentials.rb (optional, if you don't want to store your credentials in a file you can skip this and get prompted at runtime).

Then execute `ruby grades.rb`.

## Get notified on new grades

Simply add a cronjob, e.g. `0 * * * * cd /home/yeet/git/uulm-lsf-grades && ./checkupdates recipient@mail.com sender@mail.com senderpassword`

Don't forget to update your mail account information in sendmail.rb. You can also find a more secure means to provide your email account credentials to the script if you like.

## Disclaimers

- This doesn't steal your account information (check the source code).
- See room for improvements? Leave an issue (or better, a pull request).

