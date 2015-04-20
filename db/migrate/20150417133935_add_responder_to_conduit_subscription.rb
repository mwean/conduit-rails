class AddResponderToConduitSubscription < ActiveRecord::Migration
  def change
    add_column :conduit_subscriptions, :responder_type, :string
    add_column :conduit_subscriptions, :responder_options, :text
  end
end
