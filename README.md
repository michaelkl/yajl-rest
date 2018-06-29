# YajlRest

Sometimes you may end up having REST API endpoint returning huge JSON
array of some object you need to parse and load into your database. However,
if you are retrieving a really large amount of data, you can't just load it
into memory and parse. And you shouldn't!

YajlRest is a streaming JSON array parser providing you with enumerator
to lazily traverse through each object allocationg only memory required
for the single object to place.

You can use it to enumerate JSON array acquired from HTTP URL or from local file.
Local file should be plain JSON. HTTP endpoint may return plain or gzipped content.

You only need enough disk space to download the whole response into
temporary file.

## Requirements

You will need yajl2 library.
See [the link](https://github.com/chef/ffi-yajl#yajl-library-packaging) for details.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yajl-rest'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yajl-rest


## Usage

Read data from REST API endpoint:

```ruby
e = YajlRest::JsonEnumerator.new 'http://example.com/objects',
                                 accept: :json,
                                 authorization: 'Bearer token="asdf"'
e.each { |o| puts o['id'] }
```

Read data from local file:

```ruby
e = YajlRest::JsonEnumerator.new '/tmp/rest-client.20180629-25287-1fgmf91'
e.each { |o| puts o['id'] }
```

## Credits

Inspired by and based on [yajl-ffi](https://github.com/chef/ffi-yajl)
