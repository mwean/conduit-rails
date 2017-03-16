require "rails/generators/migration"
require "rails/generators"
require "conduit/engine"
require "conduit"

class Conduit::InstallGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  desc "Installs Conduit Models, Migrations, and Controllers."

  def self.source_root
    @source_root ||= File.join(__dir__, "../../../app")
  end

  def copy_controllers
    template "controllers/conduit/responses_controller.rb", "app/controllers/conduit/responses_controller.rb"
  end

  def copy_models
    template "models/conduit/subscription.rb", "app/models/conduit/subscription.rb"
    template "models/conduit/response.rb", "app/models/conduit/response.rb"
    template "models/conduit/request.rb", "app/models/conduit/request.rb"
  end

  def copy_migrations
    rake("conduit:install:migrations")
  end
end
