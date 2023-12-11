#!/usr/bin/env ruby

require 'json'

def print_json(input)
  puts JSON.generate(JSON.parse(input), array_nl: "\n", object_nl: "\n", indent: "    ")
end

if __FILE__ == $0
  puts pretty_print_json(ARGF.read)
end