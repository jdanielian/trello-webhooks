require 'json'

module Trello
  class WebHookDispatcher
    include SimpleLogger

    attr :body_hash
    attr :commands

    def initialize(post_body)
      @body_hash = JSON.parse(post_body, symbolize_names: true)
      logger.info("parsed body => #{@body_hash.inspect}")

    end

    def execute
      build_commands

      commands.each{|cmd| cmd.execute }
    end


    private
    TRELLO_LISTS = {:in_dev => '59b99bfec694acd6d384a115',
                    :pull_request => '59b99c0430ddaadbe1d22d93',
                    :ba_review => '59b99c097600a8d5c832b64f',
                    :'508' => '59b99c0f20d57c7e366b042a',
                    :po_review => '59b99c13f18d666f83eade72'}

    TRELLO_LIST_IDS = Set.new(TRELLO_LISTS.invert.keys)

    def build_commands

      @commands = []

      if move_from_list? && in_wip_list?
        card_id = get_card_id
        source_date = get_source_date
        
        @commands << AddDateToCardCommand.new(card_id, source_date)
      end

    end

    def move_from_list?

      if body_hash[:action][:type] == 'updateCard' && body_hash[:action][:display] && body_hash[:action][:display][:translationKey] == 'action_move_card_from_list_to_list'
        true
      else
        false
      end

    end

    # is this moving to one of our WIP lists
    def get_moved_to_list_id
      list_id = :not_found

      if move_from_list?
        list_id = body_hash[:action][:data][:listAfter][:id]
      end

      list_id

    end

    def get_card_id
      card_id = :not_found

      begin
        card_id = body_hash[:action][:display][:entities][:card][:id]
      rescue
        log.error("body_hash didnt match expected format => #{body_hash.inspect}")
      end

      card_id
    end

    def get_source_date
      body_hash[:action][:date]
    end

    def in_wip_list?
      TRELLO_LIST_IDS.include?(get_moved_to_list_id)
    end


  end
end