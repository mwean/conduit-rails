module Conduit
  class Request < ActiveRecord::Base
    include Conduit::Concerns::Storage

    def self.table_name_prefix
      'conduit_'
    end

    serialize :options, Hash

    # Associations

    has_many :responses,   dependent: :destroy
    has_many :subscriptions, autosave: true

    has_many   :children, class_name: 'Conduit::Request', foreign_key: :parent_id
    belongs_to :parent,   class_name: 'Conduit::Request'

    # Validations

    validates :driver, presence: true
    validates :action, presence: true
    validate  :assure_supported_driver_and_action

    # Hooks

    after_initialize  :set_defaults
    after_commit      :notify_subscribers, on: [:update]

    before_save       :set_transaction_id, on: [:create]

    # Scopes

    scope :by_action, -> (actions) { where(action: actions) }
    scope :by_driver, -> (drivers) { where(driver: drivers) }
    scope :by_status, -> (status)  { where(status: status)  }

    # Methods

    # Overriding this method fixes an issue
    # where content isn't set until after
    # the raw action is instantiated
    #
    def content
      raw.view || super
    end

    # Perform the requested action for the specified driver
    # We need to also capture any timeouts, and update
    # the status accordingly.
    #
    def perform_request
      return unless response = raw.perform
      responses.create(content: response.body)
    rescue Conduit::TimeOut
      update_attributes(status: :timeout)
      nil
    rescue Conduit::ConnectionError
      update_attributes(status: :error)
      nil
    end

    # Allow creation of subscriptions through the
    # subscribers virtual attribute.
    #
    # NOTE: This is usually possible by default with a
    #       has_many :through, but with polymorphic
    #       association it gets more complicated.
    #
    def subscribers=(args)
      args.map do |arg|
        next unless arg.class < ActiveRecord::Base
        subscriptions.build(subscriber: arg)
      end
    end

    # Fetch a list of subscribers through
    # the subscriptions association
    #
    # NOTE: This is usually possible by default with a
    #       has_many :through, but with polymorphic
    #       association it gets more complicated.
    #
    def subscribers
      subscriptions.map(&:subscriber)
    end

    def callback_url=(callback_url)
      options.merge!(callback_url: callback_url)
      attribute_will_change!(:options)
    end

    def callback_url
      options[:callback_url]
    end

    def subscribe(responder_type, **responder_options)
      raise StandardError.new("Responder must implement process_conduit_response") unless responder_type.respond_to?(:process_conduit_response)
      self.subscriptions.create(responder_type: responder_type.to_s, responder_options: responder_options)
    end

    private

    def set_transaction_id
      self.transaction_id ||= RequestStore.store[:transaction_id] || Thread.current[:transaction_id]
      true
    end


    def conduit_driver
      @conduit_driver ||= Conduit::Util.find_driver(driver)
    end

    def assure_supported_driver_and_action
      unless conduit_driver.present?
        errors.add(:driver, "#{driver} is not a supported driver")
        return false
      end

      unless conduit_driver.actions.include?(action.to_sym)
        errors.add(:action, "not supported by the #{driver} driver")
        return false
      end
    end



    # Set some default values
    #
    def set_defaults
      self.status ||= 'open'
    end

    def connection_error?
      %w(timeout error).include?(status.to_s)
    end

    # Generate a unique storage key
    # TODO: Dynamic File Format
    #
    def generate_storage_path
      update_column(:file, File.join("#{id}".reverse!,
                                     driver.to_s, action.to_s, 'request.xml'))
    end

    # Notify the requestable that our status
    # has changed. This is done by calling
    # a predefined method name on the
    # requestable instance
    #
    def notify_subscribers
      return unless should_notify_subscribers?
      return unless last_response = responses.last

      to_notify = (subscriptions + (self.respond_to?(:subscribers) ? subscribers : [])).uniq.compact
      to_notify.each do |subscription|
        with_logged_exceptions do
          subscription.handle_conduit_response(action, last_response)
        end
      end
    end

    # Raw access to the action instance
    #
    def raw
      @raw ||= Conduit::Util.find_driver(driver,
                                         action).new(options.symbolize_keys!)
    end

    def should_notify_subscribers?
      !connection_error? && previous_changes.include?(:status)
    end

    def with_logged_exceptions(&block)
      begin
        yield
      rescue StandardError => e
        Rails.logger.error e.message
        Rails.logger.error e.backtrace.join("\n")
      end
    end
  end
end
