require 'spec_helper'

describe Conduit::Response do

  before do
    Excon.stub({}, body: read_support_file("xml/xml_response.xml"), status: 200)

    @request = Conduit::Request.create(driver: :my_driver, action: :foo,
      options: request_attributes)
    @request.perform_request
  end

  let(:xml_response) do
    read_support_file('xml/xml_response.xml')
  end

  subject { @request.responses.first }

  describe "#create" do
    it "generates a file path from the request" do
      File.dirname(subject.file).should eq File.dirname(@request.file)
    end

    it "saves the record to the database" do
      subject.persisted?.should be_true
    end
  end

  describe "#destroy" do
    before { subject.destroy }

    it "removes the record from the database" do
      subject.destroyed?.should be_true
    end
  end

  describe '#content' do
    it "returns the xml view" do
      a = subject.content.gsub(/\s+/, "") # Strip whitespace for comparison
      b = xml_response.gsub(/\s+/, "")    # Strip whitespace for comparison
      a.should == b
    end
  end

  describe "#parsed_content" do
    it "returns a parser object" do
      klass = Conduit::Driver::MyDriver::Foo::Parser
      subject.parsed_content.class.should == klass
    end
  end

  describe '.set_last_error_on_request' do
    it 'should set the last error message on the conduit request' do
      OpenStruct.new(response_status: 'error', response_errors: 'boom')
      allow_any_instance_of(Conduit::Response).to receive(:error_response?).and_return(true)
      allow_any_instance_of(Conduit::Response).to receive(:parsed_content).and_return(OpenStruct.new(response_errors: ['boom']))

      @request.responses.create(content: "some content")

      expect(@request.reload.last_error_message).to eql 'boom'
    end
  end
end