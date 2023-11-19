#!/usr/bin/env ruby

require 'rdf'
require 'shacl'
require 'json/ld'
require 'rdf/turtle' # to read SHACL file written in Turtle format

# Create JSON-LD by adding JSON to cms-context.jsonld
events_json =  JSON.parse(File.read('./files/25-events.json'))
events_jsonld = JSON.parse(File.read('./files/cms-context.jsonld'))
events_jsonld["@graph"] = events_json

# Frame
frame = JSON.parse(File.read('./files/cms-frame.jsonld'))
events_framed = JSON::LD::API.frame(events_jsonld, frame)

# validate with SHACL
shacl = SHACL.open('./files/cms-shacl.ttl')
graph = RDF::Graph.load(events_framed.to_json, format: :jsonld)
report = shacl.execute(graph)  

# save report and framed events
puts "Conforms: #{report.conform?}"
File.write('./output/25-events-report.jsonld', report)
File.write('./output/25-events.jsonld', events_framed)