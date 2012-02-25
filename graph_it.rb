# copyright m.adda 2012
require "graphviz"
require "./xml_reader"

class GraphIt

  def initialize p, gp, out
    @path = p
    @gpath= gp
    @output = out
  end

  def graph_it
    # get xml date from @path
    xml = XmlReader.new(@path)
    entities, relations, connections = xml.process

    # create a graph
    g = GraphViz::new(@output, :path => @gpath, :type => "graph")

    g.node[:shape] = "square"
    g.node[:color] = "blue"

    g.edge[:color] = "black"
    g.edge[:weight] = "2"
    g.edge[:style] = "filled"

    #g[:size] = "30,30"

    # entities
    nodes = {}
    entities.each do |entity|
      node  = g.add_nodes(entity[:name], :label => "Entity: #{entity[:name]}")
      #puts node.to_s
      nodes[entity[:id].to_sym] = node

      puts entity[:attributes].to_s
      # attributes
      entity[:attributes].each do |attribute|
        att_node  = g.add_nodes("#{entity[:name]}_#{attribute[:name]}", :label => attribute[:name] , :shape => "ellipse", :color =>"green")
        g.add_edges(att_node, node, :color => "green", :style => "filled")
      end

    end

    # relations
    relations.each do |relation|
      nodes[relation[:id].to_sym] = g.add_nodes(relation[:name], :label => "Association: #{relation[:name]}", :shape => "diamond", :color => "red")
    end

    # connections
    connections.each do |connection|
      from = connection[:from].to_sym
      to = connection[:to].to_sym
      mult = (connection[:mult].to_s == "0"? "1":"N")
      g.add_edges(nodes[from], nodes[to], :color => "red", :style => "filled", :label => mult) #, :label =>)
    end

    g.output(:png => @output)

  end

end

path = 'E:\\E\\home\\cours\\_h_2012\\_INF15107_bd1\\ruby-graphviz-erd\\visualize-it\\tp1-2.erd'
gp = "C:\\Program Files\\Graphviz 2.28\\bin"
output_file = "output.png"

g = GraphIt.new(path, gp, output_file)
g.graph_it