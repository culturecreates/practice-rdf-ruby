#!/usr/bin/env ruby

require_relative './lib/pipeline.rb'

# Related to "Add recommended properties to event JSON-LD in Open API"
# https://github.com/culturecreates/footlight-calendar-api/issues/767

pipeline = Pipeline.new( 
  frame: "./frame/frame-event-seo.jsonld",
  fixture: "./fixtures/alicia-moffet-event.json",
  context: "./context/cms-context.jsonld", 
  shacl: "./shacl/cms-shacl.ttl" )

pipeline.run