require "spec_helper"

describe Conduit::Request, type: :model do
  let(:xml_request) do
    read_support_file("xml/xml_request.xml")
  end

  subject do
    Excon.stub({}, body: read_support_file("xml/xml_response.xml"), status: 200)

    Conduit::Request.create(driver: :my_driver, action: :foo,
      options: request_attributes)
  end

  before do
    subject.perform_request
  end

  describe "#create" do
    it "generates a file path for storage" do
      subject.file.should_not be_nil
    end

    it "saves the record to the database" do
      subject.persisted?.should be true
    end

    it "creates a response in the database" do
      subject.responses.should_not be_empty
    end

    it "perserves the transaction id" do
      RequestStore.store[:transaction_id] = "foo"
      req = Conduit::Request.create(driver: :my_driver, action: :foo,
        options: request_attributes)
      req.transaction_id.should eq("foo")
    end
  end

  describe "#destroy" do
    before { subject.destroy }

    it "removes the record from the database" do
      subject.destroyed?.should be true
    end
  end

  describe "#content" do
    it "returns the xml view" do
      a = subject.content.gsub(/\s+/, "") # Strip whitespace for comparison
      b = xml_request.gsub(/\s+/, "")     # Strip whitespace for comparison
      a.should == b
    end
  end

  context "with a subscriber" do
    let(:subscription) { Conduit::Subscription.new }
    let(:response) { subject.responses.create(content: "some content") }

    before :each do
      subject.subscriptions << subscription
    end

    it 'it notifies the subscriber with response' do
      subscription.should_receive(:handle_conduit_response).with(subject.action, response)
      subject.status = "failure"
      subject.save
    end

    context "with exception in subscriber" do
      let(:second_subscription) { Conduit::Subscription.new }

      before do
        subject.subscriptions << second_subscription
      end

      it "notifies subscribers in the face of adversity" do
        subscription.should_receive(:handle_conduit_response).
                     with(subject.action, response).
                     and_raise(StandardError, "boom")

        second_subscription.should_receive(:handle_conduit_response).
                            with(subject.action, response)

        Rails.logger.should_receive(:error).twice

        subject.status = "failure"
        subject.save
      end
    end
  end
end
