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

      head, body = find_head_tag(plain_body)
      plain_body.close if plain_body.respond_to?(:close)

      body.unshift(bless(head))
    end

    def html?
      content_type = headers['Content-Type']
      content_type =~ /text\/html/
    end

    def find_head_tag(plain_body)
      head = ''
      remaining = []
      found = false
      plain_body.each do |body|
        if found
          remaining << body
        else
          head << body
          found = head.include?("<head>")
        end
      end

      [head, remaining]
    end

    def bless(html)
      html.gsub!("<head>", "<head><script>#{self.class.js_code}</script>")
      html
    end

    class << self
      def js_code
        <<~JS
          (function () {
            window.addEventListener("unload", uploadCoverage)

            function uploadCoverage () {
              const cov = window.__coverage__
              if (!cov) { return }

              const data = new FormData()
              data.append("coverage", JSON.stringify(cov))
              navigator.sendBeacon("#{Jscov.configuration.coverages_path}", data)
            }
          })()
        JS
      end
    end
  end
end
