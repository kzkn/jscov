# Jscov

Collect JavaScript code coverages. It works with [istanbul](https://istanbul.js.org/).

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'jscov'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install jscov
```

## Usage

Install [babel-plugin-istanbul](https://github.com/istanbuljs/babel-plugin-istanbul).

```bash
$ yarn add -D babel-plugin-istanbul
```

And setup it. In babel.config.js:

```js
module.exports = function (api) {
  // ....
  return {
    plugins: [
      // ...
      isTestEnv && 'babel-plugin-istanbul' // Add this
    ].filter(Boolean)
  }
}
```

Mount `Jscov::Engine`. In route.rb:

```ruby
if Jscov.enabled?
  mount Jscov::Engine => "/jscov"
end
```

Insert `jscov_script_tag` in your layout file:

```html
<html>
  <head>
    <%= jscov_script_tag %>
  </head>
  ...
</html>
```

Load rspec helper. In spec/rails_helper.rb:

```ruby
require 'jscov/rspec'
```

Run `NODE_ENV=test RAILS_ENV=test bin/rails assets:precompile` for generating js codes that applied `istanbul`:

```bash
NODE_ENV=test RAILS_ENV=test bin/rails assets:precompile
```

OK, run rspec! It will dump collected coverage files in `tmp/jscov`.
The collected coverages can be output as a report using [nyc](https://github.com/istanbuljs/nyc).

```bash
$ npx nyc report --temp-dir=tmp/jscov
```

## Configuration

In `config/initializers/jscov.rb`, you can configure the following values.

```ruby
Jscov.configure do |config|
  # config.enabled = Rails.env.test?
  # config.coverage_report_dir_path = Rails.root.join("tmp/jscov")
end
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
