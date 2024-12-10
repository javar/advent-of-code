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

# Function to calculate the rating for a single trailhead
def calculate_rating(grid, start)
  directions = [[0, 1], [1, 0], [0, -1], [-1, 0]] # Right, Down, Left, Up
  trails = Set.new
  queue = [[start, [start]]] # Queue holds the current position and path

  while !queue.empty?
    (x, y), path = queue.shift

    directions.each do |dx, dy|
      nx, ny = x + dx, y + dy
      next if nx < 0 || ny < 0 || ny >= grid.size || nx >= grid[0].size # Out of bounds
      next if path.include?([nx, ny])                                  # Prevent loops
      next if grid[ny][nx] != grid[y][x] + 1                          # Not an uphill step of +1

      new_path = path + [[nx, ny]]

      # Add trail to the set if it ends at height 9
      trails.add(new_path) if grid[ny][nx] == 9

      queue << [[nx, ny], new_path]
    end
  end

  trails.size
end

# Main function to calculate the sum of all trailhead ratings
def sum_trailhead_ratings(file_path)
  grid = parse_map(file_path)
  trailheads = find_trailheads(grid)

  trailheads.sum { |trailhead| calculate_rating(grid, trailhead) }
end

# Read the input file
input_file = 'input.txt'

# Calculate and print the sum of the ratings
total_rating = sum_trailhead_ratings(input_file)
puts "The sum of the ratings of all trailheads is: #{total_rating}"
