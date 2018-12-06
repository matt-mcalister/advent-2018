require 'pry'
# Your goal is to find the size of the largest area that isn't infinite.
# For example, consider the following list of coordinates:
#
# 1, 1
# 1, 6
# 8, 3
# 3, 4
# 5, 5
# 8, 9
# If we name these coordinates A through F, we can draw them on a grid, putting 0,0 at the top left:
#
# ..........
# .A........
# ..........
# ........C.
# ...D......
# .....E....
# .B........
# ..........
# ..........
# ........F.
# This view is partial - the actual grid extends infinitely in all directions.
# Using the Manhattan distance, each location's closest coordinate can be determined,
# shown here in lowercase:
#
# aaaaa.cccc
# aAaaa.cccc
# aaaddecccc
# aadddeccCc
# ..dDdeeccc
# bb.deEeecc
# bBb.eeee..
# bbb.eeefff
# bbb.eeffff
# bbb.ffffFf
# Locations shown as . are equally far from two or more coordinates,
# and so they don't count as being closest to any.
#
# In this example, the areas of coordinates A, B, C, and F are infinite -
# while not shown here, their areas extend forever outside the visible grid.
# However, the areas of coordinates D and E are finite: D is closest to 9
# locations, and E is closest to 17 (both including the coordinate's location itself).
# Therefore, in this example, the size of the largest area is 17.

class Map
  attr_accessor :left_most_point, :right_most_point, :top_most_point, :bottom_most_point

  def generate(coordinates)
    coordinates.each do |c|
      coord = Coordinate.new(c.first, c.last, self)
      self.is_boundary?(coord)
    end
  end

  def finite_points
    Coordinate.all.select {|c| c.map == self && c.finite_point?}
  end

  def is_boundary?(coord)
    if self.left_most_point.nil? || self.left_most_point.x >= coord.x
      self.left_most_point = coord
    end

    if self.right_most_point.nil? || self.right_most_point.x <= coord.x
      self.right_most_point = coord
    end

    if self.top_most_point.nil? || self.top_most_point.y >= coord.y
      self.top_most_point = coord
    end

    if self.bottom_most_point.nil? || self.bottom_most_point.y <= coord.y
      self.bottom_most_point = coord
    end
  end

  def coordinates_between_points(coord1, coord2)
    # returns any coordinates inside of maximal between two points
  end

  def coordinates
    Coordinate.all.select {|c| c.map == self}
  end

end

class Coordinate

  @@all = []

  attr_reader :x, :y, :map
  attr_accessor :closest_above, :closest_below, :closest_right, :closest_left

  def initialize(x, y, map)
    @x = x
    @y = y
    @map = map
    @@all << self
  end

  def find_closest_points
    # the area between two points is always a rectangle (even if it's a width/height of 1)
    # see if any points reside in that area- if they do, recalculate with the closer point until you've found the closest point.


  end

  def vertical_distance_from(coord)
    # if it's positive, the coord is below self
    # if it's negative, the coord is above self
    coord.y - self.y
  end

  def horizontal_distance_from(coord)
    # if it's positive, the coord is to the right of self
    # if it's negative, the coord is to the left of self
    coord.x - self.x
  end

  def self.all
    @@all
  end

  def on_top_edge
    self.y == self.map.top_most_point.y
  end

  def on_bottom_edge
    self.y == self.map.bottom_most_point.y
  end

  def on_left_edge
    self.x == self.map.left_most_point.x
  end

  def on_right_edge
    self.x == self.map.right_most_point.x
  end

  def finite_point?
    !self.on_top_edge &&
    !self.on_bottom_edge &&
    !self.on_left_edge &&
    !self.on_right_edge
  end

end

test = [[1, 1],
[1, 6],
[8, 3],
[3, 4],
[5, 5],
[8, 9]]

def run(arr)
  m = Map.new
  m.generate(arr)
  binding.pry
end

run(test)
