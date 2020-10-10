require 'action_controller/railtie'

module TestRailsApp
  class Application < Rails::Application
    config.hosts.clear if Rails::VERSION::MAJOR >= 6

    config.secret_key_base = 'c08fed00b5faa65c7af2ba27307e787a42db4c90abbf835967a7dd9ae567f3ec7e30cdedbaae40f4a2eadd38340b0ee259ff12d97a00765b9ec978c31e599c34'

    routes.draw do
      get '/' => 'test_rails_app/root#show'
      get '/hello' => 'test_rails_app/hello#show'
    end
  end

  def html(body)
    <<~HTML
      <html>
        <head>
          <title>hello</title>
          <script>
            window.__coverage__ = { dummy: 1 }
          </script>
        </head>
        <body>
          #{body}
        </body>
      </html>
    HTML
  end
  module_function :html

  class RootController < ActionController::Base
    def show
      render inline: TestRailsApp.html("this is root")
    end
  end

  class HelloController < ActionController::Base
    def show
      render inline: TestRailsApp.html("this is hello")
    end
  end
end

Rails.logger = Logger.new('/dev/null')
