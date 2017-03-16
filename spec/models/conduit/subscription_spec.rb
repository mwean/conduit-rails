require "spec_helper"

describe Conduit::Subscription, type: :model do
  let(:action) { "action" }
  let(:response) { "response" }
  let(:responder_options) { { some_parameter: 1 } }

  context "when a response comes back with responder" do
    class TestResponder
      def self.process_conduit_response(_action, _response, _options)
      end
    end

    subject do
      Conduit::Subscription.new(responder_type: TestResponder.to_s,
                                responder_options: responder_options)
    end

    it "calls process_conduit_response on the responder" do
      TestResponder.should_receive(:process_conduit_response).
                    with(action, response, responder_options)
      subject.handle_conduit_response(action, response)
    end
  end
end
