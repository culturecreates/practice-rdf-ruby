#!/usr/bin/env ruby

require 'rdf'
require 'shacl'
require 'json/ld'
require 'rdf/turtle' # to read SHACL file written in Turtle format

# Create JSON-LD by adding JSON to cms-context.jsonld
events =  JSON.parse(File.read('./fixtures/25-events.json'))
input = JSON.parse(File.read('./context/cms-context.jsonld'))
input["@graph"] = events
events_expanded = JSON::LD::API.expand(input)
File.write('./output/25-events-expanded.jsonld', events_expanded.to_json)

# Frame
frame = JSON.parse(File.read('./frame/cms-frame.jsonld'))
events_framed = JSON::LD::API.frame(events_expanded, frame)
File.write('./output/25-events-framed.jsonld', events_framed.to_json)

# validate with SHACL
shacl = SHACL.open('./shacl/cms-shacl.ttl')
graph = RDF::Graph.load('./output/25-events-framed.jsonld')
report = shacl.execute(graph)  
puts "Conforms: #{report.conform?}"
File.write('./output/25-events-report.text', report)
