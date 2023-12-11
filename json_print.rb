#!/usr/bin/env ruby

require 'json'

def print_json(input)
  puts JSON.generate(JSON.parse(input), array_nl: "\n", object_nl: "\n", indent: "    ")
end

puts pretty_print_json(ARGF.read)