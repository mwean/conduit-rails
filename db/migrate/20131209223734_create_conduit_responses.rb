class CreateConduitResponses < ActiveRecord::Migration
  def change
    create_table :conduit_responses do |t|
      t.string :file
      t.references :request, index: true

      t.timestamps
    end
  end
end
