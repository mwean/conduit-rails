module Conduit
  class ResponsesController < ActionController::Base

    # TODO: Determine the actual param the posted content
    # will be stored in, and modify the code below
    #
    def create
      request = Conduit::Request.find(params[:request_id])
      request.responses.create(content: params[:content])
      render nothing: true
    end

  end
end