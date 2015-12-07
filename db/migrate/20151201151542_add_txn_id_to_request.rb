class AddTxnIdToRequest < ActiveRecord::Migration
  def change
    add_column :conduit_requests, :transaction_id, :string
  end
end
