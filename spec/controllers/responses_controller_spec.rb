require 'spec_helper'

describe Conduit::ResponsesController do

  let(:request) do
    Conduit::Request.create(driver: :my_driver,
      action: :foo, options: request_attributes)
  end

  let(:xml_content) do
    read_support_file('xml/xml_response.xml')
  end

  describe 'create' do
    before do
      post :create, { request_id: request.id,
        content: xml_content, use_route: :conduit }
    end

    it 'returns a 200 status' do
      response.status.should == 200
    end

    it 'creates a response object' do
      request.responses.length.should == 1
    end
  end

end