require 'trello'

module Trello
  class CommandBase
    include SimpleLogger

    def client
      Trello.client
    end

  end
end