require_relative './command_base'


module Trello
  class AddDateToCardCommand < CommandBase

    attr :card_id
    attr :source_date

    URL_PREFIX = 'https://peaceful-savannah-58277.herokuapp.com/trello/card?date='

    def initialize(card_id, source_date)
      @card_id = card_id
      @source_date = source_date
    end

    def execute
      logger.info("execute called on #{self.class.name}")
      card = client.find(:card, card_id)

      if card.attachments.length > 0 && card.attachments.any?{|attach| attach.url =~ /date=/ }
        attachments_to_remove = card.attachments.select{|attach| attach.url =~ /date=/}
        logger.info("remove attachments on card_id #{card_id}")
        attachments_to_remove.each{|attachment| card.remove_attachment(attachment) }
      end

      card.add_attachment(get_url)
      logger.info("added attachments back on card_id #{card_id}")
    end

    private

    def get_url
      short_date = @source_date #.strftime('%Y-%m-%d')

      "#{URL_PREFIX}#{short_date}"

    end




  end

end