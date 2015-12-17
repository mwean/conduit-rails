class AddSelfJoinToConduitRequest < ActiveRecord::Migration
  def change
    add_column :conduit_requests, :parent_id, :integer, index: true
  end
end
