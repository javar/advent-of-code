require 'set'

# Function to parse the map and find antenna positions
def parse_map(map)
  antennas = []
  map.each_with_index do |row, y|
    row.chars.each_with_index do |cell, x|
      antennas << [x, y, cell] if cell =~ /[a-zA-Z0-9]/
    end
  end
  antennas
end

# Function to calculate unique antinodes
def calculate_antinodes(map)
  antennas = parse_map(map)
  antinode_positions = Set.new

  # Group antennas by frequency
  grouped_antennas = antennas.group_by { |_, _, freq| freq }

  # Iterate through each group of antennas
  grouped_antennas.each do |freq, positions|
    positions.combination(2) do |(x1, y1, _), (x2, y2, _)|
      # Calculate midpoint
      mid_x, mid_y = (x1 + x2) / 2.0, (y1 + y2) / 2.0

      # Check if the midpoint is valid (integer coordinates)
      if mid_x % 1 == 0 && mid_y % 1 == 0
        antinode_positions << [mid_x.to_i, mid_y.to_i]
      end

      # Calculate extended points
      dx, dy = x2 - x1, y2 - y1
      antinode_positions << [x1 - dx, y1 - dy]
      antinode_positions << [x2 + dx, y2 + dy]
    end
  end

  # Filter antinodes within the bounds of the map
  width = map[0].size
  height = map.size
  antinode_positions.select { |x, y| x.between?(0, width - 1) && y.between?(0, height - 1) }
                    .size
end

# Read the input map from a file
def read_input_file(file_path)
  File.readlines(file_path).map(&:chomp)
end

# Main execution
file_path = 'input.txt' # Ensure this file contains your puzzle input
map = read_input_file(file_path)
result = calculate_antinodes(map)
puts "The number of unique locations containing an antinode is: #{result}"
