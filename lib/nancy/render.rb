begin
  require 'tilt'
rescue LoadError => e
  puts "Please install tilt gem to use Valencias::Render"
  raise e
end

module Valencias
  module Render

    def render(template, locals = {}, options = {}, &block)
      templates_cache.fetch(template) {
        Tilt.new(template, options)
      }.render(self, locals, &block)
    end

    def templates_cache
      Thread.current[:templates_cache] ||= Tilt::Cache.new
    end
  end
end
