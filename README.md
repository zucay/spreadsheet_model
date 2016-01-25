# SpreadsheetModel

SpreadsheetModel is an OSM(Object-Spreadsheet-Mapper) framework for Goolge Spreadsheet in Ruby on Rails.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spreadsheet_model'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spreadsheet_model

## Configuration

SpreadsheetModel configuration can be done through environment variables.
This snippet is a simplest configuration.
To use with a Rails application, write it in 'config/initializers/spreadsheet_model.rb'

```ruby
ENV['GOOGLE_DRIVE_CLIENT_ID'] ='your-client-id-of-goole-spreadsheet.apps.googleusercontent.com'
ENV['GOOGLE_DRIVE_CLIENT_SECRET'] = 'your-secret-of-google-spreadsheet'
ENV['GOOGLE_DRIVE_REFRESH_TOKEN'] = 'your-refresh-token-of-google-spreadsheet'
```
## Dataset of Google Spreadsheet
First line of spreadsheet is used as a attributes name.
Leftmost columns are used as a primary key.

## Class Definition
Include SpreadsheetModel with definitions of attr_accessor and SHEET_KEY,
so that access the sheet and column.
```ruby
class TestModel
  include SpreadsheetModel
  attr_accessor :id, :name, :long_name

  # https://docs.google.com/spreadsheets/d/sheet-key
  SHEET_KEY = 'spreadsheet-identifier-of-url'
end
```

## Usage
SpreadsheetModel provides a find('value_of_primary_key') method.
the return value acts as a ActiveModel.

```ruby
row = TestModel.find(1) # returns row of id: 1 and name
puts row.name # returns a value of the 'name' column
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/spreadsheet_model. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
