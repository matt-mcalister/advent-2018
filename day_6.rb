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
  attr_accessor :left_boundary, :right_boundary, :top_boundary, :bottom_boundary,
    :top_left_coord, :top_right_coord, :bottom_left_coord, :bottom_right_coord

  def initialize
    @left_boundary = 0
    @right_boundary = 0
    @top_boundary = 0
    @bottom_boundary = 0
  end


  def generate(coordinates)
    coordinates.each do |c|
      coord = Coordinate.new(c[0], c[1], self, c[2])
      self.update_boundary(coord)
    end
    self.assign_corners
  end

  def finite_points
    Coordinate.all.select {|c| c.map == self && c.finite_point?}
  end

  def update_boundary(coord)
    if self.left_boundary >= coord.x
      self.left_boundary = coord.x
    end

    if self.right_boundary <= coord.x
      self.right_boundary = coord.x
    end

    if self.top_boundary >= coord.y
      self.top_boundary = coord.y
    end

    if self.bottom_boundary <= coord.y
      self.bottom_boundary = coord.y
    end
  end

  def assign_corners
    self.top_left_coord = self.closest_point(self.left_boundary, self.top_boundary)
    self.top_right_coord = self.closest_point(self.right_boundary, self.top_boundary)
    self.bottom_left_coord = self.closest_point(self.left_boundary, self.bottom_boundary)
    self.bottom_right_coord = self.closest_point(self.right_boundary, self.bottom_boundary)
  end

  def closest_point(x, y)
    self.coordinates.min_by do |c|
      mid_width = ((self.right_boundary - self.left_boundary) / 2) + self.left_boundary
      mid_height = ((self.bottom_boundary - self.top_boundary) / 2) + self.top_boundary
      maximum_area = self.right_boundary * self.bottom_boundary
      case [x,y]
      when [self.left_boundary, self.top_boundary]
        if c.x <= mid_width && c.y <= mid_height
          c.area_between(x,y)
        else
          maximum_area
        end
      when [self.right_boundary, self.top_boundary]
        if c.x >= mid_width && c.y <= mid_height
          c.area_between(x,y)
        else
          maximum_area
        end
      when [self.left_boundary, self.bottom_boundary]
        if c.x <= mid_width && c.y >= mid_height
          c.area_between(x,y)
        else
          maximum_area
        end
      when [self.right_boundary, self.bottom_boundary]
        if c.x >= mid_width && c.y >= mid_height
          c.area_between(x,y)
        else
          maximum_area
        end
      else
        c.area_between(x,y)
      end
    end
  end

  def coordinates_between_points(x,y, coord2)
    # returns any coordinates inside of maximal area between two points
    # include coord2 in that array
  end

  def coordinates
    Coordinate.all.select {|c| c.map == self}
  end

end

class Coordinate

  @@all = []

  attr_reader :x, :y, :map, :name
  # attr_accessor :closest_above, :closest_below, :closest_right, :closest_left

  def initialize(x, y, map, name = nil)
    @x = x
    @y = y
    @map = map
    @name = name
    @@all << self
  end

  # def find_closest_points
  #   # the area between two points is always a rectangle (even if it's a width/height of 1)
  #   # see if any points reside in that area- if they do, recalculate with the closer point until you've found the closest point.
  #   find_closest_above
  #   find_closest_below
  #   find_closest_left
  #   find_closest_right
  # end

  # def find_closest_above
  #   possible_coords = self.coordinates_between_points(self, self.map.top_boundary)
  #   while possible_coords.length > 1
  #     binding.pry
  #   end
  # end

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

  def area_between(x,y)
    width = (x - self.x).abs
    height = (y - self.y).abs
    width * height
  end

  def self.all
    @@all
  end

  def on_top_edge
    self.y == self.map.top_boundary
  end

  def on_bottom_edge
    self.y == self.map.bottom_boundary
  end

  def on_left_edge
    self.x == self.map.left_boundary
  end

  def on_right_edge
    self.x == self.map.right_boundary
  end

  def finite_point?
    !self.on_top_edge &&
    !self.on_bottom_edge &&
    !self.on_left_edge &&
    !self.on_right_edge
  end

end

test = [[1, 1, "A"],
[1, 6, "B"],
[8, 3, "C"],
[3, 4, "D"],
[5, 5, "E"],
[8, 9, "F"]]

def run(arr)
  m = Map.new
  m.generate(arr)
  puts m.top_left_coord.name
  puts m.top_right_coord.name
  puts m.bottom_left_coord.name
  puts m.bottom_right_coord.name
end

run(test)
