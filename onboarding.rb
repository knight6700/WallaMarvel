require 'json'
require 'fileutils'

# Make sure all project ruby dependencies are installed
begin
  require 'bundler'
  require 'arkana'
  require 'fastlane'
rescue LoadError
  `sudo gem install bundler`
  `bundle update`
end

puts "Hello There!, Welcome to Marvel Heroes"
puts "Basically this is just a simple quick script to setup Marvel environment"
puts "As of now, we are using Arkana and Fastlane, so we will be needing the following..."

#puts "1. AppleID"
#puts "2. Apple Password"
#puts "We will be using Fastlane's Credential Manager for this"
#puts "Please enter your Apple ID"
#apple_id = gets.chomp
#system("fastlane fastlane-credentials add --username #{apple_id}")

puts "3. Public_KEY_Debug for Marvel"
ENV["publicKeyDebug"] = gets.chomp
puts "4. Private_KEY_Debug for Marvel"
ENV["privateKeyDebug"] = gets.chomp
puts "5. Public_KEY_Release for Marvel"
ENV["privateKeyRelease"] = gets.chomp
puts "6. Private_KEY_Release for Marvel"
ENV["publicKeyRelease"] = gets.chomp
system("bundle exec arkana")
system("xed .")
puts "✅ All Done! ✅"
