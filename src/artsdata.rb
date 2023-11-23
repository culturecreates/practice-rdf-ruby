#!/usr/bin/env ruby

require_relative './lib/pipeline.rb'

# Experiments for issue#65 Export all Events to Artsdata on a schedule
# https://github.com/culturecreates/footlight-aggregator/issues/65

pipeline = Pipeline.new( 
  frame: "./frame/cms-frame.jsonld",
  fixture: "./fixtures/25-events.json",
  context: "./context/cms-context.jsonld", 
  shacl: "./shacl/cms-shacl.ttl" )

pipeline.run
