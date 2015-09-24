module Conduit
  class Response < ActiveRecord::Base
    include Conduit::Concerns::Storage

    def self.table_name_prefix
      'conduit_'
    end

    # Associations

    belongs_to :request

    # Validations

    validates :request, presence: true

    # Hooks

    after_commit :report_response_status,  on: :create
    after_commit :set_last_error_message,  if: :error_response?
    after_commit :wipe_last_error_message, unless: :error_response?

    # Methods

    delegate :subscribers, :callback_subscribers, :callback_url, :driver, :action, to: :request

    # Raw access to the parser instance
    #
    def parsed_content
      @parsed_content ||= Conduit::Util.find_driver(driver, action, 'parser').new(content)
    end

    private

    # Generate a storage key based on parent request
    # TODO: Dynamic File Format
    #
    def generate_storage_path
      update_column(:file, File.join(File.dirname(
        request.file), "#{id}-response.xml"))
    end

    # Check for the 'response_status' attribute
    # from the parsed data, and return that to
    # the request.
    #
    # NOTE: These should be one of the following:
    #       pending/success/failure
    #
    def report_response_status
      status = parsed_content.response_status
      request.update_attributes(status: status)
    end

    def error_response?
      status = parsed_content.response_status
      ['error', 'failure'].include?(status)
    end

    def set_last_error_message
      errors = parsed_content.try(:response_errors)
      errors = errors.kind_of?(Array) ? errors.join(',') : errors.to_s
      errors = "An unknown #{parsed_content.response_status} occurred" unless errors.present?

      request.update_attributes(last_error_message: errors)
    end

    def wipe_last_error_message
      request.update_attributes(last_error_message: nil) if request.last_error_message.present?
    end
  end
end
