require_relative 'gis.rb'
require 'json'
require 'test/unit'

EXAMPLE_JSONS = [
  '{"type": "Feature","properties": {"title": "home","icon": "flag"},"geometry": {"type": "Point","coordinates": [-121.5,45.5,30]}}',
  '{"type": "Feature","properties": {"icon": "flag"},"geometry": {"type": "Point","coordinates": [-121.5,45.5]}}',
  '{"type": "Feature","properties": {"title": "store"},"geometry": {"type": "Point","coordinates": [-121.5,45.5]}}',
  '{"type": "Feature", "properties": {"title": "track 1"},"geometry": {"type": "MultiLineString","coordinates": [[[-122,45],[-122,46],[-121,46]],[[-121,45],[-121,46]]]}}',
  '{"type": "Feature", "properties": {"title": "track 2"},"geometry": {"type": "MultiLineString","coordinates": [[[-121,45.5],[-122,45.5]]]}}',
  '{"type": "FeatureCollection","features": [{"type": "Feature","properties": {"title": "home","icon": "flag"},"geometry": {"type": "Point","coordinates": [-121.5,45.5,30]}},{"type": "Feature","properties": {"title": "store","icon": "dot"},"geometry": {"type": "Point","coordinates": [-121.5,45.6]}},{"type": "Feature", "properties": {"title": "track 1"},"geometry": {"type": "MultiLineString","coordinates": [[[-122,45],[-122,46],[-121,46]],[[-121,45],[-121,46]]]}},{"type": "Feature", "properties": {"title": "track 2"},"geometry": {"type": "MultiLineString","coordinates": [[[-121,45.5],[-122,45.5]]]}}]}',
]

class TestGis < Test::Unit::TestCase
  def setup
    @w = Waypoint.new(-121.5, 45.5, 30, "home", "flag")
    @w_1 = Waypoint.new(-121.5, 45.5, nil, nil, "flag")
    @w_2 = Waypoint.new(-121.5, 45.5, nil, "store", nil)
    @w2 = Waypoint.new(-121.5, 45.6, nil, "store", "dot")
    @ts1 = [
      Point.new(-122, 45),
      Point.new(-122, 46),
      Point.new(-121, 46),
    ]
    @ts2 = [ Point.new(-121, 45), Point.new(-121, 46), ]
    @ts3 = [
      Point.new(-121, 45.5),
      Point.new(-122, 45.5),
    ]
    @t = Track.new([@ts1, @ts2], "track 1")
    @t2 = Track.new([@ts3], "track 2")
    @world = World.new("My Data", [@w, @w2, @t, @t2])
  end

  def test_waypoints
    expected = JSON.parse(EXAMPLE_JSONS[0])
    result = JSON.parse(@w.get_waypoint_json)
    assert_equal(result, expected)

    expected = JSON.parse(EXAMPLE_JSONS[1])
    result = JSON.parse(@w_1.get_waypoint_json)
    assert_equal(result, expected)

    expected = JSON.parse(EXAMPLE_JSONS[2])
    result = JSON.parse(@w_2.get_waypoint_json)
    assert_equal(result, expected)
  end

  def test_tracks
    expected = JSON.parse(EXAMPLE_JSONS[3])
    result = JSON.parse(@t.get_track_json)
    assert_equal(expected, result)

    @t = Track.new([@ts3], "track 2")
    expected = JSON.parse(EXAMPLE_JSONS[4])
    result = JSON.parse(@t.get_track_json)
    assert_equal(expected, result)
  end

  def test_world
    expected = JSON.parse(EXAMPLE_JSONS[5])
    result = JSON.parse(@world.to_geojson)
    assert_equal(expected, result)
  end

  def test_waypoint_without_title
    expected = JSON.parse(EXAMPLE_JSONS[2])
    result = JSON.parse(@w_2.get_waypoint_json)
    assert_equal(result, expected)
  end

  def test_track_creation
    expected = JSON.parse(EXAMPLE_JSONS[3])
    result = JSON.parse(@t.get_track_json)
    assert_equal(result, expected)
  end

  def test_second_track_creation
    expected = JSON.parse(EXAMPLE_JSONS[4])
    result = JSON.parse(@t2.get_track_json)
    assert_equal(result, expected)
  end

  def test_world_creation
    expected = JSON.parse(EXAMPLE_JSONS[5])
    result = JSON.parse(@world.to_geojson)
    assert_equal(result, expected)
  end
end