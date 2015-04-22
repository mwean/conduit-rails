require 'spec_helper'
require 'pry'

describe Conduit::Subscription do

  let (:action) { "action" }
  let (:response) { "response" }

  context "when a response comes back with responder" do

    class TestResponder
      def self.process_conduit_response(action, response, options)
      end
    end

    let (:responder_options) { {some_parameter: 1} }
    subject { Conduit::Subscription.new(responder_type: TestResponder.to_s, responder_options: responder_options)}

    it "calls process_conduit_response on the responder" do
      expect(TestResponder).to receive(:process_conduit_response).with(action, response, responder_options)
      subject.handle_conduit_response(action, response)
    end
  end

end
