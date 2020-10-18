module Jscov
  class Bless
    def initialize(response)
      @response = response
    end

    def result
      [
        @response[0],
        headers,
        blessed_body
      ]
    end

    private

    def headers
      @response[1]
    end

    def blessed_body
      plain_body = @response[2]
      return plain_body unless html?

      blessed = []
      plain_body.each do |fragment|
        blessed << bless(fragment)
      end

      plain_body.close if plain_body.respond_to?(:close)

      blessed
    end

    def html?
      content_type = headers['Content-Type']
      content_type =~ /text\/html/
    end

    def bless(fragment)
      index = fragment.index(/<head>/i)
      if index
        fragment.insert(index + '<head>'.size, script_tag)
      else
        fragment
      end
    end

    def script_tag
      tag = "<script>#{self.class.js_code}</script>"
      tag = tag.html_safe if tag.respond_to?(:html_safe)
      tag
    end

    class << self
      def js_code
        <<~JS
          window.addEventListener("unload", __jscov_dumpCoverage)

          function __jscov_dumpCoverage() {
            const cov = window.__coverage__
            if (!cov) { return }

            console.log('__jscov', JSON.stringify(cov))
          }
        JS
      end
    end
  end
end
