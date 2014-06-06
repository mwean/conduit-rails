class CreateConduitRequests < ActiveRecord::Migration
  def change
    create_table :conduit_requests do |t|
      t.string  :driver
      t.string  :action
      t.text    :options
      t.string  :file
      t.string  :status

      t.timestamps
    end
  end
end
