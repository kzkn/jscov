require_relative "./spec_helper"

describe Jscov::Bless do
  before do
    Jscov.configuration.reset!
  end

  it "blesses script" do
    bless = Jscov::Bless.new([200, {}, ["<html><head></head><body>foo</body></html>"]])
    result = bless.result
    expect(result[0]).to eq 200
    expect(result[1]).to eq({})
    expect(result[2]).to eq ["<html><head><script>#{Jscov::Bless.js_code}</script></head><body>foo</body></html>"]
  end

  it "blesses script if head tag separated" do
    bless = Jscov::Bless.new([200, {}, ["<html><", "h", "e", "a", "d", ">", "</head><body>foo</body></html>"]])
    result = bless.result
    expect(result[0]).to eq 200
    expect(result[1]).to eq({})
    expect(result[2]).to eq ["<html><head><script>#{Jscov::Bless.js_code}</script>", "</head><body>foo</body></html>"]
  end

  it "not blesses non html response" do
    bless = Jscov::Bless.new([200, {}, [%({ "json": true })]])
    result = bless.result
    expect(result[0]).to eq 200
    expect(result[1]).to eq({})
    expect(result[2]).to eq [%({ "json": true })]
  end
end
