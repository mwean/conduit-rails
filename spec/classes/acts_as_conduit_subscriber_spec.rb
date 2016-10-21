require 'spec_helper'

# Create a temporary ActiveRecord object to test with
#
class MySubscriber < ActiveRecord::Base
  acts_as_conduit_subscriber

end

describe MySubscriber do

  # Silly magic to create an empty table for MySubscriber
  #
  before(:each) do
    ActiveRecord::Migration.tap do |a|
      a.verbose = false
      a.create_table(:my_subscribers) do |t|
        t.timestamps
      end
    end
  end

  # Silly magic to remove an empty table for MySubscriber
  #
  after(:each) do
    ActiveRecord::Migration.tap do |a|
      a.verbose = false
      a.drop_table(:my_subscribers)
    end
  end

  context 'without an instance' do
    its(:class) { should respond_to(:acts_as_conduit_subscriber) }
    it { should have_many :conduit_requests }
  end

  context 'with an instance' do
    before(:each) do
      Excon.stub({}, body: read_support_file("xml/xml_response.xml"), status: 200)

      @obj = MySubscriber.create
      @obj.conduit_requests.create(driver: :my_driver, action: :foo,
        options: request_attributes).perform_request
    end
  end

end