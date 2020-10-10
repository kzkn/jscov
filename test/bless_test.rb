require "test_helper"

class Jscov::Bless::Test < ActiveSupport::TestCase
  setup do
    Jscov.configuration.reset!
  end

  test "bless script" do
    bless = Jscov::Bless.new([200, {}, ["<html><head></head><body>foo</body></html>"]])
    result = bless.result
    assert_equal 200, result[0]
    assert_equal({}, result[1])
    assert_equal ["<html><head><script>#{Jscov::Bless.js_code}</script></head><body>foo</body></html>"], result[2]
  end

  test "bless script if head tag separated" do
    bless = Jscov::Bless.new([200, {}, ["<html><", "h", "e", "a", "d", ">", "</head><body>foo</body></html>"]])
    result = bless.result
    assert_equal 200, result[0]
    assert_equal({}, result[1])
    assert_equal ["<html><head><script>#{Jscov::Bless.js_code}</script>", "</head><body>foo</body></html>"], result[2]
  end

  test "not bless non html response" do
    bless = Jscov::Bless.new([200, {}, [%({ "json": true })]])
    result = bless.result
    assert_equal 200, result[0]
    assert_equal({}, result[1])
    assert_equal [%({ "json": true })], result[2]
  end

  test "not bless if jscov disabled" do
    Jscov.configure do |config|
      config.enabled = false
    end

    bless = Jscov::Bless.new([200, {}, ["<html><head></head><body>foo</body></html>"]])
    result = bless.result
    assert_equal 200, result[0]
    assert_equal({}, result[1])
    assert_equal ["<html><head></head><body>foo</body></html>"], result[2]
  end
end
