[![Gem Version](https://badge.fury.io/rb/jscov.svg)](http://badge.fury.io/rb/jscov)
[![Build Status](https://travis-ci.org/kzkn/jscov.svg?branch=master)](https://travis-ci.org/kzkn/jscov)

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

Add Jscov middleware to rails middleware stack. Add the following in `config/environments/test.rb`:

```ruby
[MyRailsApp]::Application.configure do |config|
  ...
  config.middleware.use Jscov::RackMiddleware
  ...
end
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

### Vue.js

To collect coverage for `.vue` files, you will need to change the configurations.

In babel.config.js:

```js
module.exports = function (api) {
  // ....
  return {
    plugins: [
      // ...
      // Add below
      isTestEnv && [
        'babel-plugin-istanbul',
        {
          extension: ['.js', '.vue']
        }
      ]
    ].filter(Boolean)
  }
}
```

And, you need to add an argument to `nyc`:

```bash
$ npx nyc report --temp-dir=tmp/jscov --extension=.vue
```

## Configuration

You can configure the following values.

```ruby
Jscov.configure do |config|
  # config.coverage_report_dir_path = Rails.root.join("tmp/jscov")
end
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
