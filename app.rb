require 'json'
require 'roda'
require_relative 'models'



class App < Roda
  plugin :multi_route
  plugin :json
  plugin :shared_vars
  plugin :halt

  Dir[File.dirname(__FILE__) + '/routes/**/*.rb'].each {|file| require file }

  route do |r|
    r.multi_route

    r.on 'trello' do
      r.run API::Trello
    end

    r.on 'health' do
      {:version => 1}
    end

  end
end