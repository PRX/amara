# Amara

[![Build Status](https://travis-ci.org/PRX/amara.svg?branch=master)](https://travis-ci.org/PRX/amara)

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

You can use the API on these top level and nested entities (see the client.rb for top level) that match the APi docs:

```ruby
amara = Amara::Client.new

amara.videos
amara.videos.languages
amara.videos.languages.subtitles
amara.videos.urls

amara.users

amara.teams
amara.teams.applications
amara.teams.members
amara.teams.projects
amara.teams.safe_members
amara.teams.tasks

amara.activity

amara.languages

amara.message
```

For each type of entity, you get the following methods: `list`, `get`, `create`, `update`, and `delete`.

All these method calls return an `Amara::Response` instance.

Entities may be nested, and params passed in for each nesting.
params to an entity can be a Hash of options, or a string, in which case it is treated like the id of that entity type.

Here is an example of how to get the English subtitles for a video with a certain id.
It shows the use of nested entities, string id params for each entity, and the get method called with no query params:
```ruby
amara = Amara::Client.new(api_username: 'amara_api_username', api_key: 'amara_api_key')

# get the English subtitles for a video
amara.videos('yourVideoId').languages('en').subtitles.get

```

Here are some more examples of listing and creating a video:
```ruby
# get a list of videos
amara = Amara::Client.new(api_username: 'amara_api_username', api_key: 'amara_api_key')
response = amara.videos
videos = response.objects.list

# amara responses for a 'list' are paged, get the next page like this:
more_videos = response.next_page


# create a video
response = amara.videos.create({
  team:      'my-team-name',
  title:     'title',
  video_url: 'https://archive.org/download/example/example.ogg',
  primary_audio_language_code: 'en'
})
video = response.object
```

You can do these same operations for Teams and other entities.
The gem defines lists of `Amara::POLICIES` and `Amara::TEAM_POLICIES` you can use in your requests:
```ruby
# create a team
new_team = amara.teams.create(
  slug:              'prx-test-1',
  name:              'prx test 1',
  is_visible:        false,
  membership_policy: Amara::TEAM_POLICIES[:invite]
)

```

In the event of an error from the Amara service, the error will be wrapped in one of the following exception clases.
```ruby
raise Amara::NotFoundError # 404 error
raise Amara::ClientError # All other 400 errors
raise Amara::ServerError # 500 errors
raise Amara::UnknownError # All other errors
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
