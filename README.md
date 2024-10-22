# Gamefic::Autoload

A Zeitwerk autoloader for Gamefic projects.

Using Gamefic::Autoload gives the Gamefic::SDK a way to use autoloading in web apps.

## Installation

The Gamefic SDK installs gamefic-autoloader by default. If you need to set it up in a bespoke project, add it to your Gemfile:

    gem 'gamefic-autoloader'

Then set it up in whatever directory needs autoloading (e.g., `lib/my_project.rb`):

```ruby
require 'gamefic-autoload'

module MyProject
  Gamefic::Autoload.setup(__dir__)
end
```

## Usage

Gamefic::Autoload sets up autoloading in your directory using standard Zeitwerk conventions. With the above example, you could define a class named `MyProject::MyClass` in
`lib/my_project/my_class.rb`, and it would be automatically loaded without the need to `require` the file.

For Opal-based web apps, The Gamefic SDK will create an `autoload.rb` file that preloads your files, classes, and modules in the same manner that Zeitwerk does.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/gamefic-autoload.
