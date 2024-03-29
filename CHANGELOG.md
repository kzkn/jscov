# Changelog

## Version 0.5.0

* **Breaking Change**
  * Requires selenium-webdriver >= 4
  * Drop support Ruby < 2.6

## Version 0.4.0

* Add `Jscov.save!`
* **Breaking Change**
  * The default rspec after hook for save coverage files has been removed. You need define it manually. See README for detail.

## Version 0.3.0

* Use `console.log` to send coverage data from browser to ruby.
  * Avoid to use `navigator.sendBeacon` because it has size limit. The limit is too small for production scale js codebase.
  * It requires to configure selenium to capture the output of `console.log`. Here is an [example](https://github.com/kzkn/jscov/blob/fc9f7fc4a989024f0d16e47a7440560c3eed95df/spec/spec_helper.rb#L17-L33).

## Version 0.2.0

* Rewritten as a Rack Middlware. It's no longer a Rails Engine.
* **Breaking Change**
  * Removed `jscov_script_tag`
  * Removed `Jscov::Engine`
  * Removed `Jscov.enabled?`
  * Removed `Jscov::Configuration#enabled` option

## Version 0.1.0

* First release
