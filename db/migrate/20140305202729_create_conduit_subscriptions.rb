class CreateConduitSubscriptions < ActiveRecord::Migration
  def change
    create_table :conduit_subscriptions do |t|
      t.references :request, index: true
      t.integer    :subscriber_id
      t.string     :subscriber_type

      t.timestamps
    end
    add_index :conduit_subscriptions, [:subscriber_type, :subscriber_id], name: 'index_conduit_subscriptions_on_subscriber'
  end
end
