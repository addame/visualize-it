# copyright m.adda 2012
require 'nokogiri'

class XmlReader

  def initialize(p)
    @path = p
  end

  def open_xml_file(path_to_xml)
    f = File.open(path_to_xml)
  end

  # process
  def process
    return process_entities, process_relations, process_connections
  end

  # process entities
  def process_entities
    entities = []
    xml_doc(@path) do |doc|
      doc.xpath("//entity").each do |e|
        entity = {:name => e[:name], :sname => e[:sname], :pname => e[:pname], :id => e[:id]}
        entity[:attributes] = []
        e.xpath("attribute").each do |attribute|
          entity[:attributes] << {:name => attribute[:name], :type => attribute[:type]}
        end
        entities << entity
      end
    end
    #puts entities.to_s
    return entities
  end

  # process relations
  def process_relations
    relations = []

    xml_doc(@path) do |doc|
      doc.xpath("//relation").each { |r| relations << {:name => r[:name], :sname => r[:sname], :pname => r[:pname], :id => r[:id]} }
    end
    #puts relations.to_s
    return relations
  end

  # process connections
  def process_connections
    connections = []
    xml_doc(@path) do |doc|
      doc.xpath("//connection").each { |c| connections << {:from => c[:from], :to => c[:to], :mult=> c[:multiplicity]} }
    end
    #puts connections.to_s
    return connections
  end

  def xml_doc(path, &block)
    f = open_xml_file(path)
    doc = Nokogiri::XML(f)
    block.call(doc) if block_given?
    f.close
  end

  def attributes
    xml_doc(@path) do |doc|
      connections = []
      doc.xpath("//connection").each do |c|
        connections << {:from => c[:from], :to => c[:to]}
      end
      puts connections.to_s
    end
  end
end

#xml = XmlReader.new('E:\\E\\home\\cours\\_h_2012\\_INF15107_bd1\\ruby-graphviz-erd\\visualize-it\\tp1-2.erd')

#xml.get_entities

#xml.attributes

#
# entity: name, sname, pname, id
#    ---> Attributes
#                 ----> Attribute: name, type
#
# relation: name, sname, pname, id
#
# connection: from:<id relation ou entite>, to:<id relation ou entite>
#
