#!/usr/bin/env ruby
require 'json'

def pretty_print(j)
    json = JSON.parse(j)

    json['features'].each do |feature|
    properties = feature['properties']
    geometry = feature['geometry']

    output = "Title: #{properties['title']}"
    output += ", Icon: #{properties['icon']}" if properties['icon'] && properties['icon'] != 'N/A'
    puts output

    case geometry['type']
    when 'Point'
        puts "Location: #{geometry['coordinates'].join(', ')}"
    when 'MultiLineString'
        puts "Tracks:"
        geometry['coordinates'].each_with_index do |track, index|
        puts "  Track #{index + 1}: #{track.map { |point| point.join(', ') }.join(' | ')}"
        end
    end
    puts "\n"
    end
end

pretty_print(ARGF.read)