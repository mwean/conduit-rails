module Conduit
  module ActsAsConduitSubscriber
    extend ActiveSupport::Concern

    module ClassMethods

      # Define a method that can be used to inject
      # methods into an ActiveRecord Model
      #
      def acts_as_conduit_subscriber
        include Conduit::ActsAsConduitSubscriber::LocalInstanceMethods

        has_many :conduit_subscriptions, as: :subscriber, class_name: 'Conduit::Subscription'
        has_many :conduit_requests, through: :conduit_subscriptions, source: :request
      end

    end

    # These methods are included when acts_as_conduit_request
    # is called on an ActiveRecord Model
    #
    module LocalInstanceMethods
    end

  end
end

ActiveRecord::Base.send :include, Conduit::ActsAsConduitSubscriber
