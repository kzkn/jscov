# Changelog

## Unreleased

* Use `console.log` to send coverage data from browser to ruby.
  * Avoid to use `navigator.sendBeacon` because it has size limit. The limit is too small for production scale js codebase.

## Version 0.2.0

* Rewritten as a Rack Middlware. It's no longer a Rails Engine.
* **Breaking Change**
  * Removed `jscov_script_tag`
  * Removed `Jscov::Engine`
  * Removed `Jscov.enabled?`
  * Removed `Jscov::Configuration#enabled` option

## Version 0.1.0

* First release
