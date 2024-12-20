class Position
  attr_reader :x, :y
  
  def initialize(x, y)
    @x = x
    @y = y
  end
  
  def neighbors
    [[x+1, y], [x-1, y], [x, y+1], [x, y-1]].map { |nx, ny| Position.new(nx, ny) }
  end
  
  def ==(other)
    x == other.x && y == other.y
  end
  
  def hash
    [x, y].hash
  end
  
  alias eql? ==
end

def build_distance_map(grid, start_pos)
  distances = Hash.new(Float::INFINITY)
  distances[start_pos] = 0
  queue = [start_pos]
  
  while !queue.empty?
    current_pos = queue.shift
    current_dist = distances[current_pos]
    
    current_pos.neighbors.each do |next_pos|
      next if next_pos.x < 0 || next_pos.x >= grid[0].length ||
              next_pos.y < 0 || next_pos.y >= grid.length ||
              grid[next_pos.y][next_pos.x] == '#' ||
              distances[next_pos] != Float::INFINITY
      
      distances[next_pos] = current_dist + 1
      queue << next_pos
    end
  end
  
  distances
end

def manhattan_distance(pos1, pos2)
  (pos1.x - pos2.x).abs + (pos1.y - pos2.y).abs
end

def count_cheats(grid)
  # Find start and end positions
  start_pos = nil
  end_pos = nil
  
  grid.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      start_pos = Position.new(x, y) if cell == 'S'
      end_pos = Position.new(x, y) if cell == 'E'
    end
  end
  
  # Build distance maps from start and end
  distances_from_start = build_distance_map(grid, start_pos)
  distances_to_end = build_distance_map(grid, end_pos)
  
  normal_length = distances_from_start[end_pos]
  return 0 if normal_length == Float::INFINITY
  
  valid_cheats = 0
  height = grid.length
  width = grid[0].length
  
  # Try all possible cheat positions
  (0...height).each do |y1|
    (0...width).each do |x1|
      next if grid[y1][x1] == '#'
      pos1 = Position.new(x1, y1)
      dist_to_cheat = distances_from_start[pos1]
      next if dist_to_cheat == Float::INFINITY
      
      # Check positions within 20 steps
      (0...height).each do |y2|
        (0...width).each do |x2|
          next if grid[y2][x2] == '#'
          next if x1 == x2 && y1 == y2
          
          pos2 = Position.new(x2, y2)
          cheat_dist = manhattan_distance(pos1, pos2)
          next if cheat_dist > 20  # Maximum cheat distance is now 20
          
          dist_from_cheat = distances_to_end[pos2]
          next if dist_from_cheat == Float::INFINITY
          
          total_length = dist_to_cheat + cheat_dist + dist_from_cheat
          savings = normal_length - total_length
          
          valid_cheats += 1 if savings >= 100
        end
      end
    end
  end
  
  valid_cheats
end

# Read input
grid = File.readlines('input.txt').map(&:chomp).map(&:chars)
result = count_cheats(grid)
puts "Number of cheats saving at least 100 picoseconds: #{result}"