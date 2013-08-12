# Amara

Ruby gem to access the Amara API.

http://www.amara.org/
http://amara.readthedocs.org/en/latest/api.html

## Installation

Add this line to your application's Gemfile:

    gem 'amara'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install amara

## Usage

You need a user account and API key to use the API.
Some capabilities (e.g. creating a team) are only enabled for enterprise customers.

```ruby
amara = Amara::Client.new(api_username: 'amara_api_username', api_key: 'amara_api_key')
amara.videos
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
