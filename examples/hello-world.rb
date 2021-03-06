require 'json'
require 'webmachine'
require 'webmachine/adapters/mongrel2'

class HelloResource < Webmachine::Resource
  def last_modified
    File.mtime(__FILE__)
  end

  def content_types_provided
    [['text/html', :to_html],
      ['text/plain', :to_text],
      ['application/json', :to_json]]
  end

  def process
    name = request.uri.path.split("/")[2]
    @data = name || 'world'
    @data.capitalize!
  end

  def to_json
    process
    return { 'hello' => @data }.to_json
  end

  def to_html
    process
    return "<html><head><title>Hello #{@data}</title></head></html>"
  end

  def to_text
    process
    return "Hello " << @data
  end
end

Webmachine.routes do
  add ['hello', '*'], HelloResource
end

Webmachine.configure do |config|
  config.adapter = :Mongrel2
  config.adapter_options[:database] = 'sqlite://config.sqlite'
  config.adapter_options[:handler_id] = '079AEFBC-6F38-425E-80F2-77C5DB19A302'
end

Mongrel2.log.level = Logger::INFO

Webmachine.run
