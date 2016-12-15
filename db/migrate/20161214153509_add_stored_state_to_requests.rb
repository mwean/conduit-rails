class AddStoredStateToRequests < ActiveRecord::Migration
  def change
    change_table :conduit_requests do |t|
      t.text :stored_state
    end
  end
end
