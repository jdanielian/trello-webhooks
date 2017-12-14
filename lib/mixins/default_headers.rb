module Mixins
  module DefaultHeaders


    def append_headers

      {'Content-Type'=>'application/json',
       #        #'Strict-Transport-Security'=>'max-age=16070400;', # Uncomment if only allowing https:// access
       'X-Frame-Options'=>'deny',
       'X-Content-Type-Options'=>'nosniff',
       'Access-Control-Allow-Origin' => '*',
       'Access-Control-Expose-Headers' => 'Location',
       'Access-Control-Allow-Headers' =>  'Origin, X-Requested-With, Content-Type, Accept',
       'Access-Control-Allow-Methods' => 'GET, POST, PUT, DELETE, OPTIONS, HEAD'}


    end


  end
end