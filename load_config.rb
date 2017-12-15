require 'yaml'
require 'trello'

if File.exist?('./tmp/config.yml')
  puts 'loading from config'
  yaml_config = YAML.load_file('./tmp/config.yml')
  TRELLO_API_KEY = yaml_config['trello_api_key']
  TRELLO_API_TOKEN = yaml_config['trello_api_token']
else
  puts 'loading from ENV variables'

  TRELLO_API_KEY = ENV['TRELLO_API_KEY']
  TRELLO_API_TOKEN = ENV['TRELLO_API_TOKEN']
end

puts "KEY: #{TRELLO_API_KEY} token #{TRELLO_API_TOKEN} "

Trello.configure do |config|
  config.developer_public_key = TRELLO_API_KEY
  config.member_token = TRELLO_API_TOKEN
end
