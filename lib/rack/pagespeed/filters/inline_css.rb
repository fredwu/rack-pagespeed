class Rack::PageSpeed::Filters::InlineCSS < Rack::PageSpeed::Filters::Base
  priority 10
  
  def execute! document
    nodes = document.css('link[rel="stylesheet"][href$=".css"]:not([href^="http"])')
    return false unless nodes.count > 0
    nodes.each do |node|
      file = file_for node
      next if file.stat.size > (@options[:max_size] or 2048)
      inline = Nokogiri::XML::Node.new 'style', document
      inline.content = file.read
      node.before inline
      node.remove
    end
  end
end
