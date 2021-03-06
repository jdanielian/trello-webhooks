require 'rack'
require 'rack/cors'

use Rack::Static, :urls => ['/public/', '/public/images/'], :header_rules => [
    [:all, {'Access-Control-Allow-Origin' => '*'}],
    [:all, {'Access-Control-Allow-Methods' =>  'GET, HEAD'}]
]

use Rack::Cors do
  allow do
    origins '*'
    resource '/**/*', :headers => :any,
             :methods => [:get, :post, :delete, :put, :patch, :options, :head],
             :max_age => 600

  end
end



require_relative 'app'


PATH_SPLITTER  = '/'.freeze


SimpleLogger.logger.info("server starting up")


run(App.freeze.app)