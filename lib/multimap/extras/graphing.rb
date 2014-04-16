require 'graphviz'

class Object
  def to_graph_node
    "node#{object_id}"
  end

  def to_graph_label
    inspect.dot_escape
  end

  def add_to_graph(graph)
    graph.add_node(to_graph_node, :label => to_graph_label)
  end
end

class Array
  def to_graph_label
    "{#{map { |e| e.to_graph_label }.join('|')}}"
  end
end

class String
  DOT_ESCAPE = %w( \\ < > { } )
  DOT_ESCAPE_REGEXP = Regexp.compile("(#{Regexp.union(*DOT_ESCAPE).source})")

  def dot_escape
    gsub(DOT_ESCAPE_REGEXP) {|s| "\\#{s}" }
  end
end

class Multimap
  def to_graph_label
    label = []
    @hash.each_key do |key|
      label << "<#{key.to_graph_node}> #{key.to_graph_label}"
    end
    "#{label.join('|')}|<default>"
  end

  def add_to_graph(graph)
    hash_node = super

    @hash.each_pair do |key, container|
      node = container.add_to_graph(graph)
      graph.add_edge("#{hash_node.name}:#{key.to_graph_node}", node)
    end

    unless default.nil?
      node = default.add_to_graph(graph)
      graph.add_edge("#{hash_node.name}:default", node)
    end

    hash_node
  end

  def to_graph
    g = GraphViz::new('G')
    g[:nodesep] = '.05'
    g[:rankdir] = 'LR'

    g.node[:shape] = 'record'
    g.node[:width] = '.1'
    g.node[:height] = '.1'

    add_to_graph(g)

    g
  end

  def open_graph!
    to_graph.output(:png => '/tmp/graph.png')
    system('open /tmp/graph.png')
  end
end

if __FILE__ == $0
  $: << 'lib'
  require 'multimap'

  map = Multimap['a' => 100, 'b' => [200, 300]]
  map.open_graph!
end
