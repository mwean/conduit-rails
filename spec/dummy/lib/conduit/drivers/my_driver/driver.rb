module Conduit::Driver::MyDriver
  extend Conduit::Core::Driver

  required_credentials :username, :password
  action :foo

end