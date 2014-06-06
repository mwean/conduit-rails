module Conduit
  class Engine < ::Rails::Engine
    isolate_namespace Conduit

    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.assets false
      g.helper false
    end

    initializer 'conduit.load_drivers', after: :load_config_initializers do |app|
      Conduit::Driver.load_drivers
    end

  end
end
