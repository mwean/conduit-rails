module Conduit
  module Concerns
    module Storage
      extend ActiveSupport::Concern

      included do
        attr_writer :content

        after_commit  :add_to_storage, on: :create, if: :generate_storage_path
        after_destroy :remove_from_storage, if: :file
      end

      # Read the content from the storage location
      #
      def content
        @content ||= Conduit::Storage.read(file)
      end

      private

        # Generate a unique storage key
        #
        def generate_storage_path
          false
        end

        # Remove the file from remote storage
        #
        def remove_from_storage
          Conduit::Storage.delete(file)
        end

        # Write the content to the storage location
        #
        def add_to_storage
          Conduit::Storage.write(file, content)
        end

    end
  end
end
