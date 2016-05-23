require 'erb'

module Valencias
  module BasicRender
    def render(template)
      ERB.new(File.open(template).read).result(binding)
    end
  end
end
