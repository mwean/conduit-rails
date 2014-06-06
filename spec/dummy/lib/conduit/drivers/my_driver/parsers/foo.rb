module Conduit::Driver::MyDriver
  class Foo::Parser

    def initialize(xml)
      @xml = xml
    end

    def response_status
      "success"
    end

  end
end
