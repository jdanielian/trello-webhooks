module API
  class Trello < Roda
    extend ::Mixins::DefaultHeaders
    include ::Trello

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
          post_body = r.body.read

          dispatcher = Trello::WebHookDispatcher.new(post_body)
          dispatcher.execute

          {:ok => 'good'}
        end

      end

      # ***TODO: do I get a webhook when the card update is due to the webhook custom data being saved to the card?

      # r.on 'card' do
      #   r.get do
      #     passed_date = r.params['date']
      #
      #     log.info("passed_date is #{passed_date}")
      #     response['Content-Type'] = 'image/png'.freeze
      #     dummy = [2,3]
      #     sample = dummy.sample
      #     root_path = File.join(File.dirname(__FILE__), '..'.freeze, '..'.freeze, 'public/images/'.freeze)
      #     log.info("root_path #{root_path}")
      #     file = "#{root_path}number-#{sample}.png"
      #
      #     r.halt response.finish_with_body(File.open(file, 'rb'.freeze))
      #
      #
      #   end
      # end
      
    end


  end
end
