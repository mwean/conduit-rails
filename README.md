Conduit [![Code Climate](https://codeclimate.com/repos/51c2044589af7e2b8b00e93d/badges/5ca50d283c35ec593fb6/gpa.png)](https://codeclimate.com/repos/51c2044589af7e2b8b00e93d/feed)
===========================

Conduit is designed to act as a driver driven communication engine. Nothing inside conduit will dictate what you communicate with,
or how you communicate with it, but rather only gives a basic foundation for communicating with external services.

## Installation
Add conduit to your `Gemfile`.

```ruby
gem 'conduit'
rake conduit:install:migrations
```

## Configuration

After installation, you'll need to attach conduit to at least one of your models.
You can do this by simply adding `acts_as_requestable`. you can also receive
request updates via the `after_conduit_request` callback.

```ruby
class MyModel < ActiveRecord::Base
  acts_as_requestable

  def after_conduit_update(parsed_content)
    # Do neat stuff here...
  end
end
```

Conduit allows you to configure a few options, such as which file storage engine to use,
as well as where it should look for drivers. To configure conduit, create an initializer
in `config/initializers/conduit.rb`, and add the following:

```ruby
Conduit.configure do |c|

  # Filesystem based storage
  #
  c.storage_config = {
    provider:   :file
    file_path:  Rails.root.join('tmp', 'conduit')
  }

  # S3 Storage
  # Note: You can also configure AWS.config
  #       directly if you choose, just
  #       leave tkey credentials out.
  #
  # c.storage_config = {
  #   provider:           :aws,
  #   bucket:             'my-bucket',
  #   aws_access_key_id:  '',
  #   aws_access_secret:  '',
  # }

  # Local system path to driver code
  #
  c.driver_path = '/path/to/drivers/folder'
end
```

## Usage

Conduit uses 2 models to store communication parameters until such a time that it can be sent.
The first is the Conduit::Request model. To create a request, just add a record for the request,
providing the `driver name`, the `action name`, and an `options hash` for that action.

```ruby
Conduit::Request.create!(
  driver: :fusion,
  action: :purchase,
  options: {
    username: 'mike',
    token:    '12345',
    data:     'data attribute'
});
```

The above will create a `Conduit::Request` record, and trigger the communication using `after_create`.
This will also store a copy of the request data to the storage engine of your choice. Conduit defaults
to storing on the file system at `Rails.root/tmp/conduit`, but this is configurable, and even supports
AWS S3 storage.

The second model is `Conduit::Response', this is where all responses for a request are kept. Once a
response is created, the response data is then stored along side the request data in the chosen
storage driver location.

After the response is saved, the response will notify the request. The request will update it's status
as needed, and will then send a notification to the parent object (requestable) via the
`after_conduit_update` on the parent object, passing the parsed_content as a parameter.

## Creating Drivers

### TODO
