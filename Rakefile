#!/usr/bin/env rake

require 'httparty'
require 'json'

namespace :bootstrap do

  desc 'task to create the webhook for trello'
  task :webhook,[:api_key,:api_token] do |t,args|

    puts "webhook task"
    puts "other #{args.extras}"
    puts "api_key #{args[:api_key]} api_token #{args[:api_token]}"

    api_token = args[:api_token]
    api_key = args[:api_key]

    list_id = args.extras.first
    callback_host = "https://peaceful-savannah-58277.herokuapp.com"
    callback_url = "#{callback_host}/trello/lists"
    trello_url = "https://api.trello.com/1/tokens/#{api_token}/webhooks/?key=#{api_key}"
    body_hash = { :callbackURL => callback_url, :idModel => list_id, :description => "webhook"}

    puts "body is  #{body_hash.to_json} "

    result = HTTParty.post(trello_url, :body =>  body_hash.to_json, :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    puts "callback POST creation completed result is #{result.inspect}"
    puts "body is #{result.response.body.to_s}"
    puts "body status is #{result.response.code.to_s}"
     
  end

end