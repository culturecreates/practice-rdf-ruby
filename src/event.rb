#!/usr/bin/env ruby

require_relative './lib/pipeline.rb'

pipeline = Pipeline.new( 
  frame: "./frame/frame-event-seo.jsonld",
  fixture: "./fixtures/alicia-moffet-event.json",
  context: "./context/cms-context.jsonld", 
  shacl: "./shacl/cms-shacl.ttl" )

pipeline.run