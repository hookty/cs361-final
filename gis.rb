#!/usr/bin/env ruby

require_relative 'pretty_print.rb'

class Track
  attr_accessor :name, :segments

  def initialize(segments, name=nil)
    @name = name
    @segments = segments.map { |s| TrackSegment.new(s) }
  end

  def get_track_json
    json = {
      "type" => "Feature",
      "geometry" => {
        "type" => "MultiLineString",
        "coordinates" => @segments.map { |s| s.coordinates.map { |c| [c.lon, c.lat, c.ele].compact } }
      }
    }
    json["properties"] = { "title" => @name } if @name
    JSON.generate(json)
  end
end

class TrackSegment
  attr_accessor :coordinates

  def initialize(coordinates)
    @coordinates = coordinates
  end
end

class Point
  attr_accessor :lat, :lon, :ele

  def initialize(lon, lat, ele=nil)
    @lon = lon
    @lat = lat
    @ele = ele
  end
end

class Waypoint
  attr_accessor :lat, :lon, :ele, :name, :type

  def initialize(lon, lat, ele=nil, name=nil, type=nil)
    @lat = lat
    @lon = lon
    @ele = ele
    @name = name
    @type = type
  end

  def get_waypoint_json(indent=0)
    j = '{"type": "Feature",'
    j += '"geometry": {"type": "Point","coordinates": '
    j += "[#{@lon},#{@lat}"
    j += ",#{@ele}" if ele
    j += ']},'
    if name || type
      j += '"properties": {'
      properties = []
      properties << '"title": "' + @name + '"' if name
      properties << '"icon": "' + @type + '"' if type
      j += properties.join(',')
      j += '}'
    end
    j += "}"
    j
  end
end

class World
  attr_accessor :name, :features

  def initialize(name, things)
    @name = name
    @features = things
  end

  def add_feature(f)
    @features.push(f)
  end

  def to_geojson(indent=0)
    s = '{"type": "FeatureCollection","features": ['
    features_json = @features.map do |f|
      if f.is_a? Track
        f.get_track_json
      elsif f.is_a? Waypoint
        f.get_waypoint_json
      end
    end
    s += features_json.join(',')
    s + "]}"
  end
end

def main()
  w = Waypoint.new(-121.5, 45.5, 30, "home", "flag")
  w2 = Waypoint.new(-121.5, 45.6, nil, "store", "dot")
  ts1 = [
  Point.new(-122, 45),
  Point.new(-122, 46),
  Point.new(-121, 46),
  ]

  ts2 = [ Point.new(-121, 45), Point.new(-121, 46), ]

  ts3 = [
    Point.new(-121, 45.5),
    Point.new(-122, 45.5),
  ]

  t = Track.new([ts1, ts2], "track 1")
  t2 = Track.new([ts3], "track 2")

  world = World.new("My Data", [w, w2, t, t2])

  pretty_print(world.to_geojson)
end

if File.identical?(__FILE__, $0)
  main()
end