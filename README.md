# Sunsetter

[![Gem Version](https://badge.fury.io/rb/sunsetter.svg)](https://badge.fury.io/rb/sunsetter)
[![Build Status](https://github.com/ryoh827/sunsetter/actions/workflows/ci.yml/badge.svg)](https://github.com/ryoh827/sunsetter/actions/workflows/ci.yml)

A Ruby gem that helps you mark Mongoid model fields as deprecated and display warning messages when they are used.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sunsetter'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install sunsetter
```

## Usage

To mark a field as deprecated in your Mongoid model:

```ruby
class User
  include Mongoid::Document
  include Sunsetter

  field :old_name
  field :new_name
  deprecate_field :old_name
end
```

When the deprecated field is accessed, you'll see warning messages like this:

```
[SUNSETTER] User#old_name is deprecated and will be removed in a future version.
[SUNSETTER] Called from: app/models/user.rb:42:in `some_method'
[SUNSETTER] Please update your code to use alternative methods.
```

## Features

- Displays warnings when deprecated fields are accessed
- Shows caller information (file name and line number)
- Prevents usage in non-Mongoid::Document models
- Implementation is independent of include order

## Development

### Setup

```bash
$ git clone https://github.com/ryoh827/sunsetter.git
$ cd sunsetter
$ bundle install
```

### Running Tests

```bash
$ bundle exec ruby test/test_sunsetter.rb
```

## License

The gem is available as open source under the terms of the [MIT License](LICENSE).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request 
