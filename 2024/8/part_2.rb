input = File.readlines('input.txt').map(&:chomp)
positions = Hash.new { |h, k| h[k] = [] }

# Parse the input to map antenna positions
input.each_with_index do |row, y|
  row.chars.each_with_index do |char, x|
    positions[char] << [x, y] unless char == '.'
  end
end

# Define a function to check if a position is within map bounds
def in_bounds(input, x, y)
  y >= 0 && y < input.length && x >= 0 && x < input[y].length
end

# Calculate unique antinode positions for Part Two
result = positions.flat_map do |char, antenna_positions|
  antenna_positions.permutation(2).flat_map do |(x1, y1), (x2, y2)|
    dx, dy = x2 - x1, y2 - y1

    # Generate all points along the line defined by the two antennas
    0.step.lazy
      .map { |v| [x1 - dx * v, y1 - dy * v] }
      .take_while { |nx, ny| in_bounds(input, nx, ny) }
      .to_a
  end
end.uniq.size

puts "The number of unique locations containing an antinode is: #{result}"
