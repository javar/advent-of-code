require 'set'
require 'matrix'

# Directions for neighbors (Right, Down, Left, Up)
DIRECTIONS = [Vector[1, 0], Vector[0, 1], Vector[-1, 0], Vector[0, -1]].freeze

# Parse the grid into a hash map
def parse_grid(data)
  data.each_with_index.with_object({}) do |(line, y), grid|
    line.chars.each_with_index { |char, x| grid[Vector[y, x]] = char }
  end
end

# Returns an array of sets, where each set contains the coordinates of a single region
def get_regions(grid)
  seen = Set.new
  regions = []

  grid.keys.each do |start|
    next if seen.include?(start)

    region = Set.new
    queue = [start]

    while queue.any?
      current = queue.shift
      next if region.include?(current)

      region << current
      seen << current

      DIRECTIONS.each do |direction|
        neighbor = current + direction
        queue << neighbor if grid[neighbor] == grid[current]
      end
    end

    regions << region
  end

  regions
end

# Calculate the total price for all regions based on the number of sides
def calculate_total_price(data)
  grid = parse_grid(data)
  regions = get_regions(grid)

  regions.sum do |region|
    # Calculate the total price for the region
    region.size * region.each_with_object(Set.new) do |cell, sides|
      DIRECTIONS.each do |direction|
        next if region.include?(cell + direction) # Not a border side

        current = cell
        walk_dir = Vector[direction[1], -direction[0]] # Rotate 90 degrees clockwise

        # Step along the border until leaving the region or the current border side
        while region.include?(current + walk_dir) && !region.include?(current + direction + walk_dir)
          current += walk_dir
        end

        sides << [current, direction] # Track unique sides
      end
    end.size
  end
end

input_data = File.readlines('input.txt', chomp: true)

# Calculate the total price for Part 2
total_price = calculate_total_price(input_data)
puts "The new total price of fencing all regions is: #{total_price}"
