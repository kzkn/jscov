require_relative "./spec_helper"

describe Jscov::Bless do
  before do
    Jscov.configuration.reset!
  end

  def content_type(type)
    { 'Content-Type' => type }
  end

  it "blesses script" do
    headers = content_type('text/html')
    bless = Jscov::Bless.new([200, headers, ["<html><head></head><body>foo</body></html>"]])
    result = bless.result
    expect(result[0]).to eq 200
    expect(result[1]).to eq(headers)
    expect(result[2]).to eq ["<html><head><script>#{Jscov::Bless.js_code}</script></head><body>foo</body></html>"]
  end

  it "blesses script if head tag separated" do
    headers = content_type('text/html')
    bless = Jscov::Bless.new([200, headers, ["<html><", "h", "e", "a", "d", ">", "</head><body>foo</body></html>"]])
    result = bless.result
    expect(result[0]).to eq 200
    expect(result[1]).to eq(headers)
    expect(result[2]).to eq ["<html><head><script>#{Jscov::Bless.js_code}</script>", "</head><body>foo</body></html>"]
  end

  it "not blesses non html response" do
    headers = content_type('application/json')
    bless = Jscov::Bless.new([200, headers, [%({ "json": true })]])
    result = bless.result
    expect(result[0]).to eq 200
    expect(result[1]).to eq(headers)
    expect(result[2]).to eq [%({ "json": true })]
  end
end
