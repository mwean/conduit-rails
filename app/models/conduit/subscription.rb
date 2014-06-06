module Conduit
  class Subscription < ActiveRecord::Base

    def self.table_name_prefix
      'conduit_'
    end

    belongs_to :subscriber, polymorphic: true
    belongs_to :request, class_name: 'Conduit::Request'

  end
end