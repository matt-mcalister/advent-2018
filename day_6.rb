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
    :top_left_coord, :top_right_coord, :bottom_left_coord, :bottom_right_coord, :grid

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
    # width = self.right_boundary - self.left_boundary
    # height = self.bottom_boundary - self.top_boundary
    self.grid = []
    (self.top_boundary..self.bottom_boundary).each do |y|
      (self.left_boundary..self.right_boundary).each do |x|
        cp = self.closest_point(x,y)
        if !cp.nil?
          cp.closest_point_count += 1
          if x == self.left_boundary || x == self.right_boundary || y == self.top_boundary || y == self.bottom_boundary
            cp.area_has_border_point = true
          end
        end
        # puts "#{x},#{y}: #{cp.nil? ? 'nil' : cp.x == x && cp.y == y ? cp.name.upcase : cp.name.downcase}"
        self.grid[y] ||= []
        self.grid[y][x] = cp.nil? ? 'nil' : cp.x == x && cp.y == y ? cp.name.upcase : cp.name.downcase
      end
    end
  end

  def finite_points
    Coordinate.all.select {|c| c.map == self && c.finite_point?}
  end

  def update_boundary(coord)
    if self.left_boundary == 0 || self.left_boundary >= coord.x
      self.left_boundary = coord.x
    end

    if self.right_boundary <= coord.x
      self.right_boundary = coord.x
    end

    if self.top_boundary == 0 || self.top_boundary >= coord.y
      self.top_boundary = coord.y
    end

    if self.bottom_boundary <= coord.y
      self.bottom_boundary = coord.y
    end
  end

  def assign_corners
    self.top_left_coord = self.closest_point(self.left_boundary, self.top_boundary, true)
    self.top_right_coord = self.closest_point(self.right_boundary, self.top_boundary, true)
    self.bottom_left_coord = self.closest_point(self.left_boundary, self.bottom_boundary, true)
    self.bottom_right_coord = self.closest_point(self.right_boundary, self.bottom_boundary, true)
  end

  def closest_point(x, y, is_corner = false)
    sorted = self.coordinates.sort_by do |c|
      if is_corner
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
        end
      else
        # puts "aint a corner"
        c.area_between(x,y)
      end
    end
    # puts "#{sorted.map {|c| { name: c.name, value: c.area_between(x,y)}}}"
    # puts "FIRST MIN: #{sorted[0].area_between(x,y)}"
    # puts "SECOND MIN: #{sorted[1].area_between(x,y)}"
    # puts "X: #{x}"
    # puts "Y: #{y}"
    # puts "**********************************"
    if sorted[0].area_between(x,y) == sorted[1].area_between(x,y)
      return nil
    else
      return sorted[0]
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
  attr_accessor :closest_point_count, :area_has_border_point

  def initialize(x, y, map, name = nil)
    @x = x
    @y = y
    @map = map
    @name = name
    @closest_point_count = 0
    @area_has_border_point = false
    @@all << self
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

  def area_between(x,y)
    width = (x - self.x).abs
    height = (y - self.y).abs
    width + height
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
    !self.area_has_border_point &&
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

input = [
  [195, 221, "AA"],
[132, 132, "AB"],
[333, 192, "AC"],
[75, 354, "AD"],
[162, 227, "AE"],
[150, 108, "AF"],
[46, 40, "AG"],
[209, 92, "AH"],
[153, 341, "AI"],
[83, 128, "AJ"],
[256, 295, "AK"],
[311, 114, "AL"],
[310, 237, "AM"],
[99, 240, "AN"],
[180, 337, "AO"],
[332, 176, "AP"],
[212, 183, "AQ"],
[84, 61, "AR"],
[275, 341, "AS"],
[155, 89, "AT"],
[169, 208, "AU"],
[105, 78, "AV"],
[151, 318, "AW"],
[92, 74, "AX"],
[146, 303, "AY"],
[184, 224, "AZ"],
[285, 348, "BA"],
[138, 163, "BB"],
[216, 61, "BC"],
[277, 270, "BD"],
[130, 155, "BE"],
[297, 102, "BF"],
[197, 217, "BG"],
[72, 276, "BH"],
[299, 89, "BI"],
[357, 234, "BJ"],
[136, 342, "BK"],
[346, 221, "BL"],
[110, 188, "BM"],
[82, 183, "BN"],
[271, 210, "BO"],
[46, 198, "BP"],
[240, 286, "BQ"],
[128, 95, "BR"],
[111, 309, "BS"],
[108, 54, "BT"],
[258, 305, "BU"],
[241, 157, "BV"],
[117, 162, "BW"],
[96, 301, "BX"]
]

def run(arr)
  m = Map.new
  m.generate(arr)
  coord = m.finite_points.max_by {|c| c.closest_point_count}
  finite = m.finite_points.map {|c| {x: c.x, y: c.y, count: c.closest_point_count}}
  # grid_with_names = m.grid.map do |row|
  #   row.map do |c|
  #     c ? c.name : c
  #   end
  # end
  # puts "*********"
  m.grid.each do |row|
    puts "#{row}"
  end
  binding.pry
end

run(input)
