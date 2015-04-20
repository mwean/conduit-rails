module Conduit
  class Subscription < ActiveRecord::Base

    def self.table_name_prefix
      'conduit_'
    end

    belongs_to :subscriber, polymorphic: true
    belongs_to :request, class_name: 'Conduit::Request'

    def handle_conduit_response(action, response)
      if responder_type
        responder = responder_type.constantize
        if responder && responder.respond_to?(:process_conduit_response)
          responder.process_conduit_response(action, response, responder_options)
        end
      end
    end

  end
end