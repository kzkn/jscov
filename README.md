[![Gem Version](https://badge.fury.io/rb/jscov.svg)](http://badge.fury.io/rb/jscov)
![](https://github.com/kzkn/jscov/workflows/CI/badge.svg)

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

Configure selenium to capture the output of `console.log`:

```ruby
RSpec.configure do |config|
  config.before(type: :system) do
    caps = Selenium::WebDriver::Remote::Capabilities.chrome(
      'goog:loggingPrefs' => { browser: 'ALL' }
    )
    driven_by :selenium, using: :headless_chrome, options: { capabilities: caps }
  end
end
```

And configure rspec to save coverage files after each examples:

```ruby
RSpec.configure do |config|
  config.after(type: :system) do
    Jscov.save!
  end
end
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

### Tips

Selenium's `logs.get(:browser)` is a destructive method. `jscov` depends on it. If you use it out of `jscov`, it will affect to result of `jscov`, and vice versa.

You can pass browser logs to `Jscov.save!` to avoid this issue:

```ruby
logs = Capybara.current_session.driver.browser.logs.get(:browser)
Jscov.save!(logs: logs)
```

If you use multiple capybara sessions, you can pass your capybara sessions to `Jscov.save!` to save coverages that collected on your sessions:

```
Jscov.save!(session: your_capybara_session)
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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kzkn/jscov.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
