module Jscov
  class Bless
    def initialize(response)
      @response = response
    end

    def result
      [
        @response[0],
        @response[1],
        blessed_body
      ]
    end

    private

    def blessed_body
      plain_body = @response[2]
      head, body = find_head_tag(plain_body.dup)
      body.unshift(bless(head))
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
