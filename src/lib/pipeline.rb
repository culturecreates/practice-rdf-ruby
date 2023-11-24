#!/usr/bin/env ruby

require 'rdf'
require 'shacl'
require 'json/ld'
require 'rdf/turtle' # to read SHACL file written in Turtle format

class Pipeline
  #attr_accessor  :frame, :fixture, :context, :shacl

  def initialize(frame:, fixture:, context:, shacl:)
    @frame = frame
    @fixture = fixture 
    @context = context 
    @shacl = shacl
  end

  # Create JSON-LD by adding JSON to cms-context.jsonld
  def map_to_jsonld
    events =  JSON.parse(File.read(@fixture))
    input = JSON.parse(File.read(@context))
    input["@graph"] = events
    @events_expanded = JSON::LD::API.expand(input)
    File.write("../output/expanded-#{@fixture.split('/').last}", @events_expanded.to_json)
  end


  # Frame
  def frame
    frame = JSON.parse(File.read(@frame))
    @events_framed = JSON::LD::API.frame(@events_expanded, frame)
    File.write("../output/framed-#{@fixture.split('/').last}", @events_framed.to_json)
  end

  # validate with SHACL
  def validate
    shacl = SHACL.open(@shacl)
    graph = RDF::Graph.load("../output/framed-#{@fixture.split('/').last}")
    # graph = RDF::Graph.new.from_jsonld(@events_framed.to_json) 
    report = shacl.execute(graph)  
    puts "Conforms: #{report.conform?}"
    File.write("../output/report-#{@fixture.split('/').last}.yml", report)
  end

  def run
    map_to_jsonld
    frame
    validate
  end
end
