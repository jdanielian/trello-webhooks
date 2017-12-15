require 'trello'

module Trello
  class CommandBase
    include SimpleLogger

    # peaceful-savannah-58277.herokuapp.com/

    URL_PREFIX = 'https://trello/card?date='

    def client
      Trello.client
    end

  end
end