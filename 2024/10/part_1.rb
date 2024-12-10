require 'set'

# Function to parse the map into a grid
def parse_map(file_path)
  File.readlines(file_path).map { |line| line.chomp.chars.map(&:to_i) }
end

# Function to find all trailheads (positions with height 0)
def find_trailheads(grid)
  trailheads = []
  grid.each_with_index do |row, y|
    row.each_with_index do |height, x|
      trailheads << [x, y] if height == 0
    end
  end
  trailheads
end

# Function to calculate the score for a single trailhead
def calculate_score(grid, start)
  directions = [[0, 1], [1, 0], [0, -1], [-1, 0]] # Right, Down, Left, Up
  visited = Set.new
  queue = [start]
  visited.add(start)
  reachable_nines = Set.new

  while !queue.empty?
    x, y = queue.shift

    directions.each do |dx, dy|
      nx, ny = x + dx, y + dy
      next if nx < 0 || ny < 0 || ny >= grid.size || nx >= grid[0].size # Out of bounds
      next if visited.include?([nx, ny])                               # Already visited
      next if grid[ny][nx] != grid[y][x] + 1                          # Not an uphill step of +1

      visited.add([nx, ny])
      queue << [nx, ny]

      # Add to reachable nines if the height is 9
      reachable_nines.add([nx, ny]) if grid[ny][nx] == 9
    end
  end

  reachable_nines.size
end

# Main function to calculate the sum of all trailhead scores
def sum_trailhead_scores(file_path)
  grid = parse_map(file_path)
  trailheads = find_trailheads(grid)

  trailheads.sum { |trailhead| calculate_score(grid, trailhead) }
end

# Read the input file
input_file = 'input.txt'

# Calculate and print the sum of the scores
total_score = sum_trailhead_scores(input_file)
puts "The sum of the scores of all trailheads is: #{total_score}"
