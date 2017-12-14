module API
  class Trello < Roda
    extend ::Mixins::DefaultHeaders

    plugin :default_headers, append_headers
    plugin :json,  classes: [Array, Hash]
    plugin :all_verbs
    plugin :slash_path_empty
    plugin :shared_vars
    plugin :halt
    plugin :app_logger
    plugin :error_handler do |e|

      error_string = "error is #{e.to_s}, error backtrace => #{e.backtrace.join("\n\t")}"
      log.error("error in request #{self.request.path}")
      log.error(error_string)
      {"errors" => [{"field" =>"server", "message" => "Internal error occurred."}]}
    end

    route do |r|

      r.on 'lists' do
        r.head do
          {:ok => 'head'}
        end
        r.post do
          log.info("lists route hit")
          parsed_body = r.body.read
          log.info("incoming body => #{parsed_body}")

          {:ok => 'good'}
        end

      end
      
    end


  end
end
