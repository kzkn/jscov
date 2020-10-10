module Jscov
  module Helper
    def jscov_script_tag
      return unless Jscov.enabled?

      javascript_tag jscov_javascript_code
    end

    def jscov_javascript_code
      <<~JS
        (function () {
          window.addEventListener('unload', uploadCoverage)

          function uploadCoverage () {
            const cov = window.__coverage__
            if (!cov) { return }

            const data = new FormData()
            data.append('coverage', JSON.stringify(cov))
            navigator.sendBeacon('#{Jscov.configuration.coverages_path}', data)
          }
        })()
      JS
    end
  end
end
