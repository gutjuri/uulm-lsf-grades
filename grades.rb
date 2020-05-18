require 'open-uri'
require 'net/http'
require 'nokogiri'
require 'io/console'
require_relative 'credentials.rb'

def url_from_html(html, name)
  URI.parse(Nokogiri::HTML.parse(html).xpath("//a[text() = \"#{name}\"]/@href").to_s)
end

if $username.nil? 
  print "KIZ-username: "
  $username = gets.chomp
end

if $password.nil?
  print "KIZ-password: "
  $password = STDIN.noecho(&:gets).chomp
end

if $degree.nil?
  print "Your degree (as seen in the LSF under Startseite -> Prüfungsverwaltung -> HTML-Ansicht ihrer erbrachten Leistungen, e.g. 'Abschluss Master of Science'): "
  $degree = gets.chomp
end

puts "\nWorking...\n"

login_post_target = URI.parse('https://campusonline.uni-ulm.de/qislsf/rds?state=user&type=1&category=auth.login&startpage=portal.vm&breadCrumbSource=portal')

# some expert called the username input field "asdf" and the password input field "fdsa" 😂😂
resp, data = Net::HTTP.post_form(login_post_target, {fdsa: $password, asdf: $username, submit: 'Anmelden'})
token = resp['set-cookie'].split(';')[0].split('=')
grades_url = URI.parse(resp['location'])

resp, data = Net::HTTP.post_form(grades_url, {token[0] => token[1]})
exam_control_url = url_from_html(resp.body, "Prüfungsverwaltung")

resp, data = Net::HTTP.post_form(exam_control_url, {token[0] => token[1]})
html_selection_url = url_from_html(resp.body, "HTML-Ansicht Ihrer erbrachten Leistungen")

resp, data = Net::HTTP.post_form(html_selection_url, {token[0] => token[1]})
html_selection_url2 = url_from_html(resp.body, $degree)

resp, data = Net::HTTP.post_form(html_selection_url2, {token[0] => token[1]})
perf_html_url = URI::parse(Nokogiri::HTML.parse(resp.body).xpath('//a[img/@src = "/QIS/images//information.svg"]/@href').to_s)

resp, data = Net::HTTP.post_form(perf_html_url, {token[0] => token[1]})

# Get the table of grades. There's another table on this page which contains student information.
# We filter it out with not(@summary).
html_table = Nokogiri::HTML.parse(resp.body).xpath('//table[not(@summary)]')
table = html_table[0].elements.map do |row|
  pnr = row.elements[0].text.strip
  pname = row.elements[1].text.strip
  pgrade = row.elements[3].text.strip
  ppassed = row.elements[4].text.strip
  plp = row.elements[5].text.strip
  "#{pnr.ljust(15)} #{pname.ljust(40)} #{pgrade.ljust(5)} #{ppassed.ljust(20)} #{plp.ljust(4)}"
end

puts table