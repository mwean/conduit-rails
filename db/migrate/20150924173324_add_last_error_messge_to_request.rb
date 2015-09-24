class AddLastErrorMessgeToRequest < ActiveRecord::Migration
  def change
    add_column :conduit_requests, :last_error_message, :text
  end
end
