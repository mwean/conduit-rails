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

    after_create :report_response_status

    # Methods

    delegate :driver, :action, to: :request

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

  end
end
